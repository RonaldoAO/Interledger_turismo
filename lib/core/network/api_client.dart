import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  //static const String baseUrl = 'https://d132nmj5ubutr8.cloudfront.net'; 
  static const String baseUrl = 'http://18.117.247.51:3000'; 
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          jsonDecode(response.body)['error'] ?? 'Error desconocido',
        );
      }
    } catch (e) {
      throw ApiException('Error de conexión: $e');
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint')
          .replace(queryParameters: queryParameters);
      
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          jsonDecode(response.body)['error'] ?? 'Error desconocido',
        );
      }
    } catch (e) {
      throw ApiException('Error de conexión: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}