import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = false;

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          FlutterSwitch(
            width: 40.0,
            height: 20.0,
            toggleSize: 16.0,
            value: value,
            activeColor: const Color(0xFFB4B4B4),
            inactiveColor: const Color(0xFFB4B4B4),
            toggleColor: Colors.white,
            padding: 2.0,
            onToggle: onChanged,
            showOnOff: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildSwitchItem(
            title: 'Push Notifications',
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
          ),
          const Divider(),
          _buildSwitchItem(
            title: 'Email Notifications',
            value: _emailNotifications,
            onChanged: (val) {
              setState(() {
                _emailNotifications = val;
              });
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
