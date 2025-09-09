// lib/services/matric_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/shared_preferences.dart'; // your PersistentData path

class MatricApi {
  static const String baseUrl = "http://192.168.1.30:8000/matric/";

  // Get headers with optional Authorization

  // Get headers with optional Authorization
  static Future<Map<String, String>> _getHeaders() async {
    final token = await PersistentData.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // Generic GET request for matric
  static Future<dynamic> getRequest(String endpoint) async {
    final url = Uri.parse(baseUrl + endpoint);
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("GET request failed: $e");
    }
  }

  // Fetch matric by type (weight, fat, etc.)
  static Future<dynamic> getMatricByType(String type) async {
    try {
      final data = await getRequest(type);
      print("✅ Matric '$type' fetched: $data");
      return data;
    } catch (e) {
      print("❌ Failed to fetch matric '$type': $e");
      return null; // return null instead of throwing for easier FutureBuilder handling
    }
  }

  // Handle response
  static dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else if (statusCode == 400) {
      throw Exception("Bad request: $body");
    } else if (statusCode == 401) {
      throw Exception("Unauthorized: $body");
    } else if (statusCode == 404) {
      throw Exception("Not found: $body");
    } else if (statusCode >= 500) {
      throw Exception("Server error: $body");
    } else {
      throw Exception("Unexpected error (${response.statusCode}): $body");
    }
  }
}
