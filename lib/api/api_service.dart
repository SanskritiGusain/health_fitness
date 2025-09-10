import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:test_app/shared_preferences.dart'; // replace with your actual path

class ApiService {
  static const String baseUrl = "http://192.168.1.35:8000/";

  // Get headers with optional Authorization
  static Future<Map<String, String>> _getHeaders() async {
    final token = await PersistentData.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // GET request
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

  // POST request
  static Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(baseUrl + endpoint);
    try {
      final headers = await _getHeaders();
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      throw Exception("POST request failed: $e");
    }
  }




  // PUT request
  static Future<dynamic> putRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(baseUrl + endpoint);
    try {
      final headers = await _getHeaders();
      final response = await http.put(url, headers: headers, body: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      throw Exception("PUT request failed: $e");
    }
  }

  // DELETE request
  static Future<dynamic> deleteRequest(String endpoint) async {
    final url = Uri.parse(baseUrl + endpoint);
    try {
      final headers = await _getHeaders();
      final response = await http.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("DELETE request failed: $e");
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
