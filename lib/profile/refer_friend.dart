import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/profile/rewards.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/utils/custom_app_bars.dart';
class ReferralScreen extends StatefulWidget {
  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool _copied = false;

  void _copyReferralCode() {
    Clipboard.setData(const ClipboardData(text: 'FITDAY20'));
    setState(() => _copied = true);
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(() => _copied = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
         appBar: CustomAppBars.backAppBar(context, "Refer Friend"),
   
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SizedBox(height: 24),
            const Text(
              'Refer Friends.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(text: 'Get a ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'coupon',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: ' For Each Signup.',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                children: const [
                  TextSpan(text: 'They get '),
                  TextSpan(
                    text: 'Upto ₹200 OFF',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF282828),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: ' on their first purchase',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 116, 115, 115),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                _buildActionButton('Share Link', Icons.share, Colors.black, () {
                  // Share functionality
                }),
                const SizedBox(width: 12),
                _buildActionButton(
                  _copied ? 'COPIED!' : 'FITDAY20',
                  _copied ? Icons.check : Icons.copy,
                  Colors.black,
                  _copyReferralCode,
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildRewardsSection(context),
            const SizedBox(height: 50),
            const Text(
              'How it works:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ...[
              'Share your referral code with friends',
              'They get Upto ₹200 OFF on their first purchase',
              'You earn a coupon when they subscribe',
              'Use your earned coupons on future purchases',
            ].map(_buildHowItWorksItem),
          ],
        ),
      ),
    );
  }

  Expanded _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: SizedBox(
        height: 54,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
         boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15), // lighter shadow
            spreadRadius: 1, // minimal spread
            blurRadius: 6, // soft blur
            offset: const Offset(0, 2), // slight vertical offset
          ),
        ],
      ),
      child: InkWell(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RewardsScreen()),
            ),
    child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons_update/gift.svg',
              height: 24, // optional size
              width: 24,
            ),
            const SizedBox(width: 14),
            const Text(
              'Rewards',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF282828),
              size: 17,
            ),
          ],
        ),

      ),
    );
  }


  Widget _buildHowItWorksItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1C1C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
