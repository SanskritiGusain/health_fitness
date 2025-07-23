import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
 

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
                            iconAsset: 'assets/icons/ri_customer-service-2-line.png',
                            title: 'Customer Services',
                            // onTap: ,
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
    // required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        // onTap: onTap,
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
            
            ],
          ),
        ),
      ),
    );
  }



}

