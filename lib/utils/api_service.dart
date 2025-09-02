// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'http://192.168.1.30:8000';

//   static Future<bool> updateUserData(Map<String, dynamic> data) async {
//     final url = Uri.parse('$baseUrl/user');

//     try {
//       final response = await http.put(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Success
//         print('Response: ${response.statusCode}, ${response.body}');

//         return true;
//       } else {
//         // API returned an error
//         print('Failed to update: ${response.statusCode} ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       // Network or other error
//       print('Error updating user: $e');
//       return false;
//     }
//   }
// }


// lib/utils/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.30:8000';
  
  /// Update user data to the API
  static Future<bool> updateUserData(Map<String, dynamic> userData) async {
    try {
      final url = Uri.parse('$baseUrl/user');
      
      // Convert any null values to appropriate defaults for the API
      final sanitizedData = _sanitizeUserData(userData);
      
      print('Sending user data to API: ${jsonEncode(sanitizedData)}'); // Debug log
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(sanitizedData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('User data updated successfully');
        return true;
      } else {
        print('Failed to update user data. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating user data: $e');
      return false;
    }
  }

  /// Sanitize and format user data for API submission
  static Map<String, dynamic> _sanitizeUserData(Map<String, dynamic> userData) {
    return {
      "name": userData["name"] ?? "",
      "email": userData["email"] ?? "user@example.com",
      "age": userData["age"] ?? 0,
      "gender": userData["gender"] ?? "",
      "country_id": userData["country_id"] ?? "",
      "state_id": userData["state_id"], // Can be null for non-India countries
      "current_height": userData["current_height"] ?? 0,
      "current_weight": userData["current_weight"] ?? 0,
      "current_bmi": userData["current_bmi"] ?? 0,
      "target_weight": userData["target_weight"] ?? userData["current_weight"] ?? 0,
      "level_id": userData["level_id"] ?? "",
      "workout_type_ids": userData["workout_type_ids"] ?? [],
      "time_availability": userData["time_availability"] ?? "",
      "special_needs": userData["special_needs"] ?? "",
      "conditions": userData["conditions"] ?? [],
      "dietary_preferences": userData["dietary_preferences"] ?? [],
      "goal_options": userData["goal_options"] ?? [],
      "allergies": userData["allergies"] ?? [],
      "dietary_special_needs": userData["dietary_special_needs"] ?? [],
      "auth_id": userData["auth_id"] ?? "",
      "auth_provider": userData["auth_provider"] ?? "",
    };
  }

  /// Fetch user data from API (if needed for profile viewing)
  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/user/$userId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch user data. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  /// Helper method for testing API connection
  static Future<bool> testConnection() async {
    try {
      final url = Uri.parse('$baseUrl/public/countries');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}