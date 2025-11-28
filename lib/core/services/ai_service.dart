import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AiService {
  Future<String> generateSummary(String content);
  Future<String> improveText(String text);
}

class AiServiceImpl implements AiService {
  static const String _apiUrl = 'https://api.cohere.com/v1/generate';
  static const String _apiKey = 'YOUR_COHERE_API_KEY';

  @override
  Future<String> generateSummary(String content) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'command-light',
          'prompt': 'Resume el siguiente texto en máximo 3 líneas:\n\n$content',
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['generations'][0]['text'].trim();
      }
      return 'No se pudo generar el resumen';
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Future<String> improveText(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'command-light',
          'prompt': 'Mejora la siguiente nota haciéndola más clara y profesional:\n\n$text',
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['generations'][0]['text'].trim();
      }
      return 'No se pudo mejorar el texto';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
