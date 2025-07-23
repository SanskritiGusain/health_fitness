// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:test_app/utils/custom_date_picker.dart'; 

// class FitnessWellnessScreen extends StatefulWidget {
//   const FitnessWellnessScreen({Key? key}) : super(key: key);

//   @override
//   State<FitnessWellnessScreen> createState() => _FitnessWellnessScreenState();
// }

// class _FitnessWellnessScreenState extends State<FitnessWellnessScreen> {
//   int _selectedIndex = 0;
//   DateTime selectedDate = DateTime.now();

//   String get displayDateText {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    
//     if (selected == today) {
//       return "Today";
//     } else if (selected == today.subtract(Duration(days: 1))) {
//       return "Yesterday";
//     } else if (selected == today.add(Duration(days: 1))) {
//       return "Tomorrow";
//     } else {
//       return "${selected.day.toString().padLeft(2, '0')} ${_getMonthName(selected.month)}";
//     }
//   }

//   String _getMonthName(int month) {
//     const months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return months[month - 1];
//   }

//   void _navigateToPreviousDay() {
//     setState(() {
//       selectedDate = selectedDate.subtract(Duration(days: 1));
//     });
//   }

//   void _navigateToNextDay() {
//     setState(() {
//       selectedDate = selectedDate.add(Duration(days: 1));
//     });
//   }

//   Future<void> _showDatePicker() async {
//     final DateTime? picked = await showDialog<DateTime>(
//       context: context,
//       builder: (context) => CustomDatePicker(
//         initialDate: selectedDate,
//         firstDate: DateTime(2020),
//         lastDate: DateTime.now().add(Duration(days: 365)),
//       ),
//     );
    
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   Widget _buildDateSelector() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: _navigateToPreviousDay,
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
//               ],
//             ),
//             child: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
//           ),
//         ),
//         const SizedBox(width: 12),
//         GestureDetector(
//           onTap: _showDatePicker,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   displayDateText, 
//                   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)
//                 ),
//                 const SizedBox(width: 4),
//                 const Icon(Icons.keyboard_arrow_down, size: 21, color: Colors.black),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         GestureDetector(
//           onTap: _navigateToNextDay,
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
//               ],
//             ),
//             child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//         title: Row(
//           children: [
//             const CircleAvatar(
//               radius: 20,
//               backgroundColor: Color(0xFFE8E8E8),
//               child: Icon(Icons.person, color: Color(0xFF666666)),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'Hi, Jane',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_outlined, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
            
//             // Date Selector
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: _buildDateSelector(),
//             ),
            
//             const SizedBox(height: 20),
            
//             // Progress Bar Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Let's setup your plan",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: LinearProgressIndicator(
//                           value: 0.0,
//                           backgroundColor: const Color(0xFFE0E0E0),
//                           valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
//                           minHeight: 4,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         '0% completed',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 30),
            
//             // Get Started Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Get Started',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
                  
//                   // Setup Items
//                  _buildSetupItem(
//                     imagePath: 'assets/icons/fitness_icon.png',
//                     title: 'Set up your fitness flow',
//                   ),
//                   const SizedBox(height: 12),
//                                    _buildSetupItem(
//                     imagePath: 'assets/icons/diet_icon.png',
//                     title: 'Set up your dietary preferences',
//                   ),

//                   const SizedBox(height: 12),
//                   _buildSetupItem(
//                     imagePath: 'assets/icons/alarm_icon.png',
//                     title: 'Set up your alarms',
//                   ),
//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 30),
            
//             // My Activities Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//             //       const Text(
//             //         'My Activities',
//             //         style: TextStyle(
//             //           fontSize: 18,
//             //           fontWeight: FontWeight.w600,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       const SizedBox(height: 15),
                  
//             //       // Activity Grid
//             //       Row(
//             //         children: [
//             //           Expanded(
//             //             child: _buildActivityCard('sleeps', '2',Image.asset('assets/images/sleep.png'))

//             //           const SizedBox(width: 12),
//             //           Expanded(
//             //             child: _buildActivityCard('Calories', '0',Image.asset(/assests/)),
//             //           ),
//             //         ],
//             //       ),
//             //       const SizedBox(height: 12),
//             //       Row(
//             //         children: [
//             //           Expanded(
//             //             child: _buildActivityCard('Water', '0',Image.asset(/assests/)),
//             //           ),
//             //           const SizedBox(width: 12),
//             //           Expanded(
//             //             child: _buildActivityCard('Sleep', '0',Image.asset(/assests/)),
//             //           ),
//             //         ],
//             //       ),
//             //     ],
//             //   ),
//             // ),
            
//             const SizedBox(height: 30),
            
//             // Progress Journey Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Progress Journey',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Container(
//                     height: 120,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'About our clients',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 30),
            
//             // Pro Advice Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF6BB6FF),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Get Pro Advice for a Healthier You',
//                             style: TextStyle(
//                              fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                     color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           const Text(
//                             'Our app gives you access to expert advice from professional trainers and nutritionists.',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12,
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 8,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                             child: const Text(
//                               'Request a Call',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                        SizedBox(
//             width: 100,
//             height: 100,
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 // Positioned circle (adjust offset here)
//                 Positioned(
//                   top: 10, // move up
//                   child: Container(
//                     width: 95,
//                     height: 95,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Color(0xFF518FBF),
//                     ),
//                   ),
//                 ),
//                 // Image
//                 Positioned(
//                   top: 10,
//                   right: -10,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.asset(
//                       'assets/images/plan_bottom.png',
//                       width: 178,
//                       height: 110,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//                   ],
//                 ),
//               ),
//             ),
            
//             const SizedBox(height: 100),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: const Color(0xFF6BB6FF),
//         unselectedItemColor: Colors.grey,
//         elevation: 8,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             activeIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.fitness_center_outlined),
//             label: 'Fitness',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.restaurant_outlined),
//             label: 'Nutrition',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSetupItem({
//       required String imagePath,
//     required String title,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 42.59,
//             height: 38.62,
           
//             child: Image.asset(imagePath),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           const Icon(
//             Icons.chevron_right,
//             color: Colors.grey,
//             size: 20,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActivityCard(String title, String value, String unit) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//      child: Row(
//         children: [
//           Image.asset('assets/icons/step_icon.png', width: 24, height: 24),
//           const SizedBox(width: 32,height: 32,),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF767780),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF222326),
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 unit,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                  ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),
//         const Icon(
//             Icons.chevron_right,
//             color: Colors.grey,
//             size: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }