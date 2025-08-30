import 'package:flutter/material.dart';
import '/profile/delete_account.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme = 'System Default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Settings Options
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildSettingItem(
                            iconAsset: 'assets/icons/mode_icon.png',
                            title: 'Theme',
                            onTap: _showThemeDialog,
                          ),
                          _buildSettingItem(
                            iconAsset: 'assets/icons/notification_icon.png',
                            title: 'Notification Setting',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationSettingsPage(),
                              ),
                            ),
                          ),
                          _buildSettingItem(
                            iconAsset: 'assets/icons/iconamoon_profile.png',
                            title: 'Delete Account',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => const DeleteAccountDialog(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Home Indicator
            Container(
              width: 120,
              height: 4,
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String iconAsset,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Image.asset(
                  iconAsset,
                  width: 16,
                  height: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 26,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

void _showThemeDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white, // 🔴 Background set to black
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose theme',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black, // 🔴 Text color white
                    ),
                  ),
                  SizedBox(height: 12),
                  ...['System Default', 'Light', 'Dark'].map((theme) {
                    return RadioListTile<String>(
                      title: Text(
                        theme,
                        style: TextStyle(
                           fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 100, 100, 100), // 🔴 White text
                        ),
                      ),
                      value: theme,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        setState(() => selectedTheme = value!);
                      },
                      activeColor: Colors.black, // 🔴 Radio active color
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black, // 🔴 Button text white
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Apply theme logic here
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black, // 🔴 Button text white
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

}

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool generalNotification = false;
  bool sound = true;
  bool dontDisturbMode = false;
  bool vibrate = true;
  bool lockScreen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Notifications Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Notification Options
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildSwitchItem('General Notification', generalNotification, (val) => setState(() => generalNotification = val)),
                    _buildSwitchItem('Sound', sound, (val) => setState(() => sound = val)),
                    _buildSwitchItem("Don't Disturb Mode", dontDisturbMode, (val) => setState(() => dontDisturbMode = val)),
                    _buildSwitchItem('Vibrate', vibrate, (val) => setState(() => vibrate = val)),
                    _buildSwitchItem('Lock Screen', lockScreen, (val) => setState(() => lockScreen = val)),
                  ],
                ),
              ),
            ),

            // Home Indicator
            Container(
              width: 120,
              height: 4,
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
            activeTrackColor: Colors.green.withOpacity(0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
