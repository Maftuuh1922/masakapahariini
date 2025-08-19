import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🔍 Testing Masak API Service...');
  print('================================');

  // Test dengan beberapa URL yang umum digunakan
  final testUrls = [
    'https://masak-apa.tomorisakura.vercel.app/api/recipes',
    'https://masak-apa.tomorisakura.vercel.app/api/recipe/new',
    'https://masak-apa-tomorisakura.vercel.app/api/recipes',
    'https://api-resep-masakan.vercel.app/api/recipes',
  ];

  for (String url in testUrls) {
    print('\n🌐 Testing: $url');
    print('-' * 50);

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 8));

      print('📊 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = response.body;
        print('📝 Response length: ${body.length} characters');

        try {
          final data = json.decode(body);

          if (data is Map<String, dynamic>) {
            print('📋 Response type: Map');

            if (data.containsKey('results') && data['results'] is List) {
              final results = data['results'] as List;
              print('✅ SUCCESS! Found ${results.length} recipes in results');

              if (results.isNotEmpty) {
                final sample = results[0];
                print('📖 Sample recipe:');
                print('   Title: ${sample['title'] ?? 'No title'}');
                print('   Key: ${sample['key'] ?? 'No key'}');
                print('   Thumb: ${sample['thumb'] ?? 'No thumb'}');
                print('\n🎉 This API endpoint is working!');
                return;
              }
            } else if (data.containsKey('data') && data['data'] is List) {
              final results = data['data'] as List;
              print('✅ SUCCESS! Found ${results.length} recipes in data');
              return;
            } else {
              print('❓ Map structure: ${data.keys.join(', ')}');
            }
          } else if (data is List) {
            print('📋 Response type: List');
            print('✅ SUCCESS! Found ${data.length} items in direct list');

            if (data.isNotEmpty) {
              final sample = data[0];
              if (sample is Map) {
                print('📖 Sample item:');
                print('   Title: ${sample['title'] ?? 'No title'}');
                print('   Key: ${sample['key'] ?? 'No key'}');
              }
              print('\n🎉 This API endpoint is working!');
              return;
            }
          } else {
            print('❓ Unknown response type: ${data.runtimeType}');
          }
        } catch (e) {
          print('❌ JSON parse error: $e');
          print(
            '📄 Raw response preview: ${body.length > 200 ? body.substring(0, 200) + "..." : body}',
          );
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print(
          '📄 Response: ${response.body.length > 100 ? response.body.substring(0, 100) + "..." : response.body}',
        );
      }
    } catch (e) {
      print('❌ Request failed: $e');
    }
  }

  print('\n⚠️  No working API endpoints found.');
  print('📋 Application will use mock data as fallback.');
  print('✨ Mock data includes:');
  print('   - Nasi Goreng Spesial');
  print('   - Soto Ayam Bening');
  print('   - Ayam Geprek Sambal Matah');
  print('   - Rendang Daging Sapi');
  print('   - And more...');
}
