// import 'package:flutter/material.dart';
// import 'package:test_app/chat/chat_start.dart';
// import 'package:test_app/utils/custom_bottom_nav.dart';
// import 'package:test_app/plan/plan_screen.dart';
// import 'package:test_app/gamification/gamification_screen.dart';
// import 'package:test_app/tools/tools_screen.dart';
// import 'package:test_app/plan/fitness_wellness.dart';
// import 'package:test_app/shift/checkout_screen.dart';

// class ChatWelcomeScreen extends StatelessWidget {
//   const ChatWelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: CustomBottomNav(
//         currentIndex: 2, // 0 for Home
//         onTap: (index) {
//           if (index == 2) return; // Already on home

//           switch (index) {
//             case 1:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => HealthDashboardScreen(),
//                 ),
//               );
//               break;
//             case 0:
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => FitnessWellnessScreen(),
//               //   ),
//               // );
//               break;
//             case 3:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => GamificationScreen()),
//               );
//               break;
//             case 4:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ToolsScreen()),
//               );
//               break;
//           }
//         },
//       ),

//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 24.0,
//               vertical: 126,
//             ),
//             child: Column(
//               children: [
//                 const Spacer(),
//                 Image.asset(
//                   'assets/images/Conversation-pana.jpg', // Replace with your actual image path
//                   height: 220,
//                 ),
//                 const SizedBox(height: 6),
//                 const Text(
//                   'Hello, Jane',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 2),
//                 const Text(
//                   'How can I help?',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Color.fromARGB(137, 0, 0, 0),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 26),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ChatScreen()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 26,
//                       vertical: 10,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Start Chat',
//                         style: TextStyle(fontSize: 14, color: Colors.white),
//                       ),
//                       SizedBox(width: 8),
//                       Icon(Icons.arrow_forward, color: Colors.white),
//                     ],
//                   ),
//                 ),
//                 const Spacer(flex: 2),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return BottomNavigationBar(
//       currentIndex: 2,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//         BottomNavigationBarItem(icon: Icon(Icons.flag), label: "My Plan"),
//         BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
//         BottomNavigationBarItem(icon: Icon(Icons.star), label: "Merits"),
//         BottomNavigationBarItem(icon: Icon(Icons.extension), label: "Tools"),
//       ],
//       selectedItemColor: Colors.black,
//       unselectedItemColor: Colors.grey,
//     );
//   }
// }
