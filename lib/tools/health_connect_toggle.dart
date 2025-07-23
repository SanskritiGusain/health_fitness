import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart'; // ✅ Import the package

class HealthConnectToggleScreen extends StatefulWidget {
  const HealthConnectToggleScreen({super.key});

  @override
  State<HealthConnectToggleScreen> createState() => _HealthConnectToggleScreenState();
}

class _HealthConnectToggleScreenState extends State<HealthConnectToggleScreen> {
  bool isSyncOn = false;

  void _handleToggle(bool value) async {
    if (value) {
      final result = await Navigator.pushNamed(context, '/health-connect');
      if (result == true) {
        setState(() => isSyncOn = true);
      }
    } else {
      setState(() => isSyncOn = false);
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF8FBFB),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF8FBFB),
      elevation: 0,
      leading: const BackButton(color: Colors.black),
      title: const Text(
        'Health Connect',
        style: TextStyle(
          fontFamily: 'Merriweather',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF222326),
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sync with Health Connect',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222326),
                ),
              ),
              FlutterSwitch(
              width: 34.0,
              height: 18.0,
              toggleSize: 16.0, // 👈 Thumb size
              value: isSyncOn,
              activeColor: const Color(0xFF8E8E93),
              inactiveColor: const Color(0xFF8E8E93),
              toggleColor: const Color(0xFFFFFFFF),
              padding: 1.5,
              onToggle: _handleToggle,
            ),
            ],
          ),
          
          // You can add more widgets below here if needed
        ],
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
  currentIndex: 4,
  selectedItemColor: Colors.black,
  unselectedItemColor: Colors.grey,
  type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.white,
  items: [
 BottomNavigationBarItem(
  icon: Image.asset(
    'assets/icons/ant-design_home-outlined.png', // <-- Your image path here
    width: 24,
    height: 24,
  ),
  label: 'Home',
),

    BottomNavigationBarItem(
    icon: Image.asset(
                    'assets/icons/plan.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'My Plan',
    ),
    BottomNavigationBarItem(
    icon: Image.asset(
                'assets/icons/tabler_message.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'Chat',
    ),
    BottomNavigationBarItem(
    icon:Image.asset(
                  'assets/icons/heroicons_trophy.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'Merits',
    ),
    BottomNavigationBarItem(
      icon:Image.asset(
                   'assets/icons/hugeicons_tools.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'Tools',
    ),
  ],
)
  );
}

}
