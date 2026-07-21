// ignore_for_file: prefer_initializing_formals
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import '../../../core/network/dictionary_service.dart';
import '../../../core/vision/marker_detector.dart';
import '../../../core/vision/ocr_service.dart';
import '../../word/data/word_generation_service.dart';
import '../../word/data/word_repository.dart';

final markerDetectorProvider = Provider((ref) => MarkerDetector());

final ocrServiceProvider = Provider<OcrService>((ref) {
  final service = OcrService();
  ref.onDispose(service.dispose);
  return service;
});

final scanServiceProvider = Provider<ScanService>((ref) {
  return ScanService(
    detector: ref.watch(markerDetectorProvider),
    ocr: ref.watch(ocrServiceProvider),
    dictionary: ref.watch(dictionaryServiceProvider),
    wordRepository: ref.watch(wordRepositoryProvider),
  );
});

class ScanCandidate {
  const ScanCandidate({
    required this.text,
    required this.needsReview,
    required this.isDuplicate,
  });

  /// OCRで認識された単語/フレーズ
  final String text;

  /// 辞書に見つからず読み取り不完全の疑いがある場合true
  final bool needsReview;

  /// 既存単語帳に同じ単語が存在する場合true
  final bool isDuplicate;
}

class ScanService {
  ScanService({
    required MarkerDetector detector,
    required OcrService ocr,
    required DictionaryService dictionary,
    required WordRepository wordRepository,
  })  : _detector = detector,
        _ocr = ocr,
        _dictionary = dictionary,
        _wordRepository = wordRepository;

  final MarkerDetector _detector;
  final OcrService _ocr;
  final DictionaryService _dictionary;
  final WordRepository _wordRepository;

  Future<List<ScanCandidate>> scan(img.Image image) async {
    final regions = _detector.detect(image);

    final texts = <String>[];
    for (final region in regions) {
      final cropped = _cropWithMinSize(image, region);
      if (cropped == null) continue;
      final text = await _ocr.recognizeText(cropped);
      if (text.isNotEmpty) texts.add(text);
    }

    // 候補内重複の集約（正規化した完全一致・大小文字無視）
    final seenNormalized = <String>{};
    final uniqueTexts = <String>[];
    for (final text in texts) {
      final trimmed = text.trim();
      final normalized = trimmed.toLowerCase();
      if (trimmed.isEmpty || seenNormalized.contains(normalized)) continue;
      seenNormalized.add(normalized);
      uniqueTexts.add(trimmed);
    }

    final candidates = <ScanCandidate>[];
    for (final text in uniqueTexts) {
      var needsReview = false;
      try {
        await _dictionary.lookup(text);
      } on WordNotFoundException {
        needsReview = true;
      }
      final existing = await _wordRepository.findByWord(text);
      candidates.add(
        ScanCandidate(
          text: text,
          needsReview: needsReview,
          isDuplicate: existing != null,
        ),
      );
    }
    return candidates;
  }
}

/// ML Kitは入力画像の幅・高さが32px未満だとエラーになるため、
/// 余白を付けつつ最小サイズを確保してクロップする
img.Image? _cropWithMinSize(img.Image image, MarkerRegion region) {
  const padding = 10;
  const minSize = 48;

  var left = region.left - padding;
  var top = region.top - padding;
  var width = region.width + padding * 2;
  var height = region.height + padding * 2;

  if (width < minSize) {
    left -= (minSize - width) ~/ 2;
    width = minSize;
  }
  if (height < minSize) {
    top -= (minSize - height) ~/ 2;
    height = minSize;
  }

  left = left.clamp(0, image.width - 1);
  top = top.clamp(0, image.height - 1);
  width = width.clamp(1, image.width - left);
  height = height.clamp(1, image.height - top);

  if (width < minSize || height < minSize) return null;

  return img.copyCrop(image, x: left, y: top, width: width, height: height);
}
