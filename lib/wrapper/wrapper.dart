// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:test_app/login/login_page.dart'; // ✅ make sure this is imported
// import 'package:test_app/pages/home_page.dart';

// class Wrapper extends StatefulWidget {
//   const Wrapper({super.key});

//   @override
//   _WrapperState createState() => _WrapperState();
// }

// class _WrapperState extends State<Wrapper> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasData) {
//             return const HomePage(); // ✅ logged in
//           } else {
//             return const LoginSelectionPage(); // ✅ not logged in
//           }
//         },
//       ),
//     );
//   }
// }
