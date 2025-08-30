// import 'dart:convert';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';

// Future<void> signUpWithGoogle(BuildContext context) async {
//   try {
//     // Step 1: Trigger Google Sign-In popup
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     if (googleUser == null) {
//       // User cancelled sign in
//       return;
//     }

//     // Step 2: Get authentication tokens
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;
//     final String? idToken = googleAuth.idToken;

//     if (idToken == null) {
//       throw Exception("Google ID Token is null");
//     }

//     // Step 3: Send token to your backend API
//  final response = await http.post(
//       Uri.parse("http://192.168.1.11:8000/auth/google"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"id_token": idToken}), // <-- FIXED
//     );


//     // Step 4: Handle backend response
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       // Example: store user and token
//       final user = data['user'];
//       final accessToken = data['accessToken'];

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Welcome ${user['name']}!")));

//       // Navigate to dashboard/home
//       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Signup failed: ${response.body}")),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text("Error: $e")));
//   }
// }
