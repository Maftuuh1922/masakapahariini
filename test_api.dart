import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  print('Testing Masak API endpoints...');
  print('=================================');

  final apiUrls = [
    'https://masak-apa.tomorisakura.vercel.app',
    'https://masak-apa-tomorisakura.vercel.app',
    'https://api-masak-apa.vercel.app',
    'https://masakapahariini.herokuapp.com',
    'https://resep-hari-ini.vercel.app',
  ];

  final endpoints = ['/api', '/api/recipes', '/recipes'];

  for (String baseUrl in apiUrls) {
    print('\nTesting base URL: $baseUrl');
    print('-' * 50);

    for (String endpoint in endpoints) {
      try {
        final url = '$baseUrl$endpoint';
        print('Testing: $url');

        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 5));

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final body = response.body;
          print('Response length: ${body.length} chars');
          print(
            'Preview: ${body.length > 100 ? body.substring(0, 100) + "..." : body}',
          );

          try {
            final data = json.decode(body);
            if (data is Map && data.containsKey('results')) {
              final results = data['results'];
              if (results is List) {
                print('✅ SUCCESS! Found ${results.length} recipes');
                if (results.isNotEmpty) {
                  final first = results[0];
                  print('Sample recipe: ${first['title'] ?? 'No title'}');
                }
                print('\nThis endpoint is working! 🎉');
                exit(0);
              }
            } else if (data is List && data.isNotEmpty) {
              print('✅ SUCCESS! Found ${data.length} items in direct list');
              print('\nThis endpoint is working! 🎉');
              exit(0);
            }
          } catch (e) {
            print('JSON parse error: $e');
          }
        } else {
          print('❌ HTTP ${response.statusCode}');
        }
      } catch (e) {
        print('❌ Error: $e');
      }
      print('');
    }
  }

  print('\n❌ No working endpoints found. Using mock data.');
  exit(1);
}
