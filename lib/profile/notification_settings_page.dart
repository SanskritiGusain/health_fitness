import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _generalNotification = true;
  bool _sound = true;
  bool _dontDisturbMode = false;
  bool _vibrate = true;
  bool _lockScreen = true;

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Transform.scale(
                scale: 0.7,
                child: Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.white, // White thumb when active
                  activeTrackColor: Colors.black, // Black track when active
                  inactiveThumbColor: Colors.white, // White thumb when inactive
                  inactiveTrackColor:
                      Colors.grey[400], // Grey track when inactive
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(
            height: 0.5,
            margin: const EdgeInsets.only(left: 20),
            color: const Color(0xFFE5E5EA),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 29, 29, 29), // iOS blue
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 36),
            // Settings container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildSwitchItem(
                    title: 'General Notification',
                    value: _generalNotification,
                    onChanged: (val) {
                      setState(() {
                        _generalNotification = val;
                      });
                    },
                  ),
                  _buildSwitchItem(
                    title: 'Sound',
                    value: _sound,
                    onChanged: (val) {
                      setState(() {
                        _sound = val;
                      });
                    },
                  ),
                  _buildSwitchItem(
                    title: 'Don\'t Disturb Mode',
                    value: _dontDisturbMode,
                    onChanged: (val) {
                      setState(() {
                        _dontDisturbMode = val;
                      });
                    },
                  ),
                  _buildSwitchItem(
                    title: 'Vibrate',
                    value: _vibrate,
                    onChanged: (val) {
                      setState(() {
                        _vibrate = val;
                      });
                    },
                  ),
                  _buildSwitchItem(
                    title: 'Lock Screen',
                    value: _lockScreen,
                    onChanged: (val) {
                      setState(() {
                        _lockScreen = val;
                      });
                    },
                    showDivider: false, // Last item doesn't need divider
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
