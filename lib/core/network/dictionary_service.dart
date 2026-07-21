import 'dart:convert';

import 'package:http/http.dart' as http;

class DictionaryLookupResult {
  const DictionaryLookupResult({
    required this.definitionEn,
    required this.exampleEn,
    required this.synonyms,
  });

  final String definitionEn;
  final String? exampleEn;
  final List<String> synonyms;
}

class WordNotFoundException implements Exception {
  WordNotFoundException(this.word);
  final String word;
}

/// Free Dictionary API (https://dictionaryapi.dev/) — APIキー不要
class DictionaryService {
  static const _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  Future<DictionaryLookupResult> lookup(String word) async {
    final uri = Uri.parse('$_baseUrl/${Uri.encodeComponent(word)}');
    final response = await http.get(uri);

    if (response.statusCode == 404) {
      throw WordNotFoundException(word);
    }
    if (response.statusCode != 200) {
      throw Exception('辞書APIエラー: ${response.statusCode}');
    }

    final entries = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    if (entries.isEmpty) {
      throw WordNotFoundException(word);
    }

    String? definition;
    String? example;
    final synonyms = <String>{};

    for (final entry in entries) {
      final meanings = (entry as Map<String, dynamic>)['meanings'] as List? ?? [];
      for (final meaning in meanings) {
        final meaningMap = meaning as Map<String, dynamic>;
        synonyms.addAll((meaningMap['synonyms'] as List? ?? []).cast<String>());

        final definitions = meaningMap['definitions'] as List? ?? [];
        for (final def in definitions) {
          final defMap = def as Map<String, dynamic>;
          definition ??= defMap['definition'] as String?;
          example ??= defMap['example'] as String?;
          synonyms.addAll((defMap['synonyms'] as List? ?? []).cast<String>());
        }
      }
    }

    if (definition == null) {
      throw WordNotFoundException(word);
    }

    return DictionaryLookupResult(
      definitionEn: definition,
      exampleEn: example,
      synonyms: synonyms.take(5).toList(),
    );
  }
}
