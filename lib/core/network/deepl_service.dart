import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// DeepL API — 英語→日本語翻訳
class DeeplService {
  String get _apiKey => dotenv.env['DEEPL_API_KEY'] ?? '';

  /// キーが":fx"で終わるものはFree/Developerプラン用エンドポイントを使う
  String get _baseUrl =>
      _apiKey.endsWith(':fx') ? 'https://api-free.deepl.com/v2/translate' : 'https://api.deepl.com/v2/translate';

  Future<String> translateToJapanese(String text) async {
    if (_apiKey.isEmpty) {
      throw Exception('DeepL APIキーが設定されていません');
    }
    if (text.trim().isEmpty) return '';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'DeepL-Auth-Key $_apiKey',
      },
      body: jsonEncode({
        'text': [text],
        'target_lang': 'JA',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('DeepL APIエラー: ${response.statusCode}');
    }

    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final translations = body['translations'] as List;
    return (translations.first as Map<String, dynamic>)['text'] as String;
  }
}
