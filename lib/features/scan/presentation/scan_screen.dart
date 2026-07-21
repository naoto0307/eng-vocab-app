import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';

import '../../../core/database/app_database.dart';
import '../../../core/settings/settings_provider.dart';
import '../../word/data/word_generation_service.dart';
import '../../word/data/word_repository.dart';
import '../data/scan_service.dart';
import 'scan_preview_screen.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _processing = false;

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage(ImageSource source) async {
    final xfile = await ImagePicker().pickImage(source: source, maxWidth: 2400);
    if (xfile == null) return;
    final bytes = await xfile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) {
      _showMessage('画像を読み込めませんでした');
      return;
    }
    await _process([image]);
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    final path = result?.files.single.path;
    if (path == null) return;

    final document = await PdfDocument.openFile(path);
    final images = <img.Image>[];
    for (var i = 1; i <= document.pagesCount; i++) {
      final page = await document.getPage(i);
      final rendered = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: PdfPageImageFormat.png,
      );
      await page.close();
      if (rendered != null) {
        final decoded = img.decodePng(rendered.bytes);
        if (decoded != null) images.add(decoded);
      }
    }
    await document.close();

    if (images.isEmpty) {
      _showMessage('PDFのページを読み込めませんでした');
      return;
    }
    await _process(images);
  }

  Future<void> _process(List<img.Image> images) async {
    setState(() => _processing = true);
    try {
      final scanService = ref.read(scanServiceProvider);
      final allCandidates = <ScanCandidate>[];
      final seen = <String>{};
      for (final image in images) {
        final candidates = await scanService.scan(image);
        for (final c in candidates) {
          final normalized = c.text.toLowerCase();
          if (seen.contains(normalized)) continue;
          seen.add(normalized);
          allCandidates.add(c);
        }
      }

      if (allCandidates.isEmpty) {
        _showMessage('マーカーで強調された単語が見つかりませんでした');
        return;
      }

      final skipPreview = ref.read(settingsProvider).skipScanPreview;
      if (skipPreview) {
        await _registerDirectly(allCandidates);
      } else if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ScanPreviewScreen(candidates: allCandidates)),
        );
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      _showMessage('スキャンに失敗しました: $e');
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _registerDirectly(List<ScanCandidate> candidates) async {
    final repo = ref.read(wordRepositoryProvider);
    final generator = ref.read(wordGenerationServiceProvider);
    var added = 0;

    for (final c in candidates) {
      if (c.isDuplicate) continue;

      var meaning = '';
      var exampleEn = '';
      var exampleJa = '';
      var synonyms = const <String>[];
      String? imageUrl;

      if (!c.needsReview) {
        try {
          final draft = await generator.generate(c.text);
          meaning = draft.meaningJa;
          exampleEn = draft.exampleEn;
          exampleJa = draft.exampleJa;
          synonyms = draft.synonyms;
          imageUrl = draft.imageUrl;
        } catch (_) {
          // 自動生成失敗時も登録は続行する
        }
      }

      try {
        await repo.addWord(
          word: c.text,
          meaning: meaning,
          exampleEn: exampleEn,
          exampleJa: exampleJa,
          synonyms: synonyms,
          imageUrl: imageUrl,
          source: WordSource.markerScan,
          status: c.needsReview ? WordStatus.pendingReview : WordStatus.unstudied,
        );
        added++;
      } on DuplicateWordException {
        // skip
      }
    }

    _showMessage('$added 件の単語を追加しました');
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マーカースキャン')),
      body: Center(
        child: _processing
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('解析中...'),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('カメラで撮影'),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('画像を選択'),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _pickPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('PDFを選択'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
