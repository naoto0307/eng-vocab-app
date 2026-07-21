import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Unsplash API — キーワードに対応するイメージ画像を1枚検索する
class UnsplashService {
  static const _baseUrl = 'https://api.unsplash.com/search/photos';

  String get _accessKey => dotenv.env['UNSPLASH_ACCESS_KEY'] ?? '';

  /// 画像が見つからない場合やキー未設定の場合はnullを返す（呼び出し側は任意項目として扱う）
  Future<String?> searchImageUrl(String query) async {
    if (_accessKey.isEmpty) return null;

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'query': query,
      'per_page': '1',
      'orientation': 'squarish',
    });
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Client-ID $_accessKey'},
    );

    if (response.statusCode != 200) return null;

    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final results = body['results'] as List;
    if (results.isEmpty) return null;

    final urls = (results.first as Map<String, dynamic>)['urls'] as Map<String, dynamic>;
    return urls['small'] as String?;
  }
}
