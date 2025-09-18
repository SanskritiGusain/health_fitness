import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:test_app/tools/health_connect_intro.dart';

class HealthConnectToggleScreen extends StatefulWidget {
  const HealthConnectToggleScreen({super.key});

  @override
  State<HealthConnectToggleScreen> createState() => _HealthConnectToggleScreenState();
}

class _HealthConnectToggleScreenState extends State<HealthConnectToggleScreen> {
  bool isSyncOn = false;

  void _handleToggle(bool value) async {
    if (value) {
      // Navigate to another screen and wait for result
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HealthConnectIntroScreen()),
      );

      // Only turn toggle ON if result is true
      if (result == true) {
        setState(() => isSyncOn = true);
      }
    } else {
      // Turn toggle OFF immediately
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
                  toggleSize: 16.0,
                  value: isSyncOn,
                  activeColor: const Color(0xFF8E8E93),
                  inactiveColor: const Color(0xFF8E8E93),
                  toggleColor: const Color(0xFFFFFFFF),
                  padding: 1.5,
                  onToggle: _handleToggle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

