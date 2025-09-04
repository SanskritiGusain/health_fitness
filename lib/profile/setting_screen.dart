import 'package:flutter/material.dart';
import 'package:test_app/main.dart';
import 'package:test_app/profile/notification_settings_page.dart';
import '/profile/delete_account.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme = 'System Default';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                        bottom: BorderSide(color: theme.dividerColor),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios, size: 20, color: theme.iconTheme.color),
                        SizedBox(width: 12),
                        Text(
                          'Settings',
                          style: theme.textTheme.titleMedium,
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
                                builder: (context) => const DeleteAccountDialog(),
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
                color: theme.iconTheme.color,
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
    final theme = Theme.of(context);

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
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Image.asset(
                  iconAsset,
                  width: 16,
                  height: 16,
                  color: theme.iconTheme.color,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 26,
                color: theme.iconTheme.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

void _showThemeDialog() {
  final theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor, // Dialog background
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
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.onSurface, // ensures visibility
                    ),
                  ),
                  SizedBox(height: 12),
                  ...['System Default', 'Light', 'Dark'].map((themeOption) {
                    return RadioListTile<String>(
                      title: Text(
                        themeOption,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurface, // visible in light/dark
                        ),
                      ),
                      value: themeOption,
                      groupValue: selectedTheme,
                      onChanged: (value) {
                        setState(() => selectedTheme = value!);
                      },
                      activeColor: theme.colorScheme.primary,
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
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.primary, // visible
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      TextButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          // if (selectedTheme == 'Light') {
                          //   MyApp.of(context)?.setThemeMode(ThemeMode.light);
                          // } else if (selectedTheme == 'Dark') {
                          //   MyApp.of(context)?.setThemeMode(ThemeMode.dark);
                          // } else {
                          //   MyApp.of(context)?.setThemeMode(ThemeMode.system);
                          // }
                        },
                        child: Text(
                          'OK',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.primary, // visible
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