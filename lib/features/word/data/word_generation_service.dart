// ignore_for_file: prefer_initializing_formals
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/deepl_service.dart';
import '../../../core/network/dictionary_service.dart';
import '../../../core/network/unsplash_service.dart';

final dictionaryServiceProvider = Provider((ref) => DictionaryService());
final deeplServiceProvider = Provider((ref) => DeeplService());
final unsplashServiceProvider = Provider((ref) => UnsplashService());

final wordGenerationServiceProvider = Provider<WordGenerationService>((ref) {
  return WordGenerationService(
    dictionary: ref.watch(dictionaryServiceProvider),
    deepl: ref.watch(deeplServiceProvider),
    unsplash: ref.watch(unsplashServiceProvider),
  );
});

class GeneratedWordDraft {
  const GeneratedWordDraft({
    required this.meaningJa,
    required this.exampleEn,
    required this.exampleJa,
    required this.synonyms,
    required this.imageUrl,
  });

  final String meaningJa;
  final String exampleEn;
  final String exampleJa;
  final List<String> synonyms;
  final String? imageUrl;
}

class WordGenerationService {
  WordGenerationService({
    required DictionaryService dictionary,
    required DeeplService deepl,
    required UnsplashService unsplash,
  })  : _dictionary = dictionary,
        _deepl = deepl,
        _unsplash = unsplash;

  final DictionaryService _dictionary;
  final DeeplService _deepl;
  final UnsplashService _unsplash;

  Future<GeneratedWordDraft> generate(String word) async {
    final lookup = await _dictionary.lookup(word);
    final meaningJa = await _deepl.translateToJapanese(lookup.definitionEn);
    final exampleEn = lookup.exampleEn ?? '';
    final exampleJa = exampleEn.isEmpty ? '' : await _deepl.translateToJapanese(exampleEn);
    final imageUrl = await _unsplash.searchImageUrl(word);

    return GeneratedWordDraft(
      meaningJa: meaningJa,
      exampleEn: exampleEn,
      exampleJa: exampleJa,
      synonyms: lookup.synonyms,
      imageUrl: imageUrl,
    );
  }
}
