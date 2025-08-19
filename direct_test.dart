import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  print('🔍 Testing Masak API directly...');
  print('=====================================');

  // Test the working URL directly
  final testUrl = 'https://masak-apa.tomorisakura.vercel.app/api/recipes';

  try {
    print('Testing: $testUrl');

    final response = await http
        .get(Uri.parse(testUrl))
        .timeout(const Duration(seconds: 10));

    print('Status: ${response.statusCode}');
    print('Response length: ${response.body.length} characters');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response type: ${data.runtimeType}');

      if (data is Map<String, dynamic>) {
        print('Response keys: ${data.keys.join(', ')}');

        if (data.containsKey('results') && data['results'] is List) {
          final results = data['results'] as List;
          print('✅ SUCCESS! Found ${results.length} recipes');

          if (results.isNotEmpty) {
            final sample = results[0];
            print('\n📖 Sample recipe:');
            print('   Title: ${sample['title'] ?? 'No title'}');
            print('   Key: ${sample['key'] ?? 'No key'}');
            print('   Thumb: ${sample['thumb'] ?? 'No thumb'}');
            print('   Times: ${sample['times'] ?? 'No times'}');
            print('   Serving: ${sample['serving'] ?? 'No serving'}');
            print('   Difficulty: ${sample['difficulty'] ?? 'No difficulty'}');
          }

          print('\n🎉 API is working! Data structure looks good.');
        } else {
          print('⚠️ Unexpected response structure');
          print(
            'Sample data: ${data.toString().length > 200 ? data.toString().substring(0, 200) + "..." : data.toString()}',
          );
        }
      } else if (data is List) {
        print('✅ SUCCESS! Direct list with ${data.length} items');

        if (data.isNotEmpty) {
          print('Sample item: ${data[0]}');
        }
      } else {
        print('❓ Unknown response format: ${data.runtimeType}');
      }
    } else {
      print('❌ HTTP Error: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('❌ Request failed: $e');
  }

  print('\n✨ Test completed!');
}
