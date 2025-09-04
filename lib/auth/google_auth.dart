import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http; // For API call
import 'dart:convert';

import 'package:test_app/pages/user_details.dart';
import 'package:test_app/shared_preferences.dart';

class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? backendAccessToken; // store token received from backend

  // Sign in with Google via Firebase Auth and get backend access token
  Future<void> signInAndNotify(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("⚠️ Google Sign-In canceled by user.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase sign-in
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Fresh Firebase ID token
      String? firebaseIdToken = await userCredential.user?.getIdToken(true);

      print("✅ Firebase Sign-In Details:");
      print("UID          : ${userCredential.user?.uid}");
      print("Display Name : ${userCredential.user?.displayName}");
      print("Email        : ${userCredential.user?.email}");
      print("Photo URL    : ${userCredential.user?.photoURL}");
      print(
        "Firebase ID Token (first 40 chars) : ${firebaseIdToken?.substring(0, 40)}...",
      );

      // Send Firebase token to backend and receive access token
      if (firebaseIdToken != null) {
        final response = await http.post(
          Uri.parse("http://192.168.1.30:8000/google"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"idToken": firebaseIdToken}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          backendAccessToken = data['access_token']; // backend token

          // Save token in PersistentData
          if (backendAccessToken != null) {
            await PersistentData.saveAuthToken(backendAccessToken!);
            print("✅ Backend token saved in SharedPreferences");
          }

          print("✅ Backend Full Response: $data");

          // Navigate to next page
          if (backendAccessToken != null && context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const UserDetailsPage()),
            );
          }
        }
 else {
          print("❌ Backend rejected token: ${response.body}");
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed in and backend token received!'),
          ),
        );
      }
    } catch (e) {
      print("❌ Firebase Sign-In Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Firebase Sign-In Failed')),
        );
      }
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    backendAccessToken = null;
    print("🔒 User signed out successfully.");
  }

  // Get current Firebase user
  User? get currentUser => _auth.currentUser;
}
