import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/utils/custom_app_bars.dart';
import 'customer_service.dart';
class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FBFB),
      appBar: CustomAppBars.backAppBar(context, "Help"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
               

                  // Settings Options
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 12),
                      child: Column(
                        children: [
                    _buildSettingItem(
                            iconAsset:
                                'assets/icons_update/tdesign_chat-bubble-help-filled.svg',
                            title: 'Customer Services',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          ContactUsScreen(), // replace with your target screen
                                ),
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
     required VoidCallback onTap, // required VoidCallback onTap,
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
                width: 44,
                height: 44,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFFE0E7ED),
                ),
                child: SvgPicture.asset(
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
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
