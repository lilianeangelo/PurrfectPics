
import 'dart:convert';

import 'package:puurfect_pics/main.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class CatApi {
  final String baseUrl = 'https://api.thecatapi.com/v1';
  final String apiKey;

  CatApi(this.apiKey);

  Future<List<String>> fetchCatPhotos({int limit = 5}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/images/search?limit=$limit'),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((cat) => cat['url'] as String).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}

void main() {
  group('Cat API Test', () {
    final apiKey = 'live_YEGmteSZB1ylRjnRbolzwijadQ0bGFYPpzsbQv9wQT59B2SkoFUhi7DqyRL0bPqB'; 
    final catApi = CatApi(apiKey);

    test('Fetch cat photos', () async {
      final photos = await catApi.fetchCatPhotos();
      expect(photos.length, 5);
    });

    test('Fetch cat photos with different limit', () async {
      final limit = 10;
      final photos = await catApi.fetchCatPhotos(limit: limit);
      expect(photos.length, limit);
    });
  });
}