
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/profile/rewards.dart'; 





class ReferralScreen extends StatefulWidget {
  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool _copied = false;

  void _copyReferralCode() {
    Clipboard.setData(ClipboardData(text: 'FITDAY20'));
    setState(() {
      _copied = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _copied = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Refer Friend',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(


        padding: EdgeInsets.all(20),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                    Divider(
  color: Colors.grey[300], // light grey line
  thickness: 1.0,          // line thickness
  height: 0,               // space above/below the line
),SizedBox(height: 24),
            // Title Section
            Text(
              'Refer Friends.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.w600,),
                children: [
                  TextSpan(text: 'Get a '),
                  TextSpan(
                    text: 'coupon',
                    style: TextStyle(
                      color:  Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: ' For Each Signup.'),
                ],
              ),
            ),
            SizedBox(height: 12),
              RichText(
              text: TextSpan(
                style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
                children: [
                  TextSpan(text: 'They get '),
                  TextSpan(
                    text: 'Upto ₹200 OFF',
                    style: TextStyle(
                      color:  const Color.fromARGB(255, 40, 40, 40),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: 'on their first purchase'),
                ],
              ),
            ),
           
            SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        // Share functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, color: Colors.white, size: 14),
                          SizedBox(width: 8),
                          Text(
                            'Share Link',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _copyReferralCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _copied ? Icons.check : Icons.copy,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 8),
                          Text(
                            _copied ? 'COPIED!' : 'FITDAY20',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Rewards Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RewardsScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.card_giftcard, color: Colors.black),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Rewards',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, color: const Color.fromARGB(255, 40, 40, 40), size: 17),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // How it works section
            Text(
              'How it works:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 14),
            _buildHowItWorksItem('Share your referral code with friends'),
            _buildHowItWorksItem('They get Upto ₹200 OFF on their first purchase'),
            _buildHowItWorksItem('You earn a coupon when they subscribe'),
            _buildHowItWorksItem('Use your earned coupons on future purchases'),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 29, 28, 28),
               
              ),
            ),
          ),
        ],
      ),
    );
  }
}