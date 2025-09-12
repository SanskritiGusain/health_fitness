import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test_app/shared_preferences.dart'; // your path

class ApiService {
  static const String baseUrl = "http://192.168.1.35:8000/";

  static Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    final token = await PersistentData.getAuthToken();
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Upload image
  static Future<dynamic> uploadImage(File imageFile, {int? userId}) async {
    final url = Uri.parse(baseUrl + 'upload-image/${userId ?? ''}');
    final request = http.MultipartRequest('POST', url);

    // Add headers with token
    request.headers.addAll(await _getHeaders(isMultipart: true));

    // Attach file
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else {
      throw Exception("Upload failed: ${response.statusCode} ${response.body}");
    }
  }
}
