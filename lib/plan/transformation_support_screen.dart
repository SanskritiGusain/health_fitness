import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/plan/fitness_wellness.dart';

class TransformationSupportScreen extends StatefulWidget {
  const TransformationSupportScreen({Key? key}) : super(key: key);

  @override
  State<TransformationSupportScreen> createState() =>
      _TransformationSupportScreenState();
}

class _TransformationSupportScreenState
    extends State<TransformationSupportScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              _buildTickIcon(),
              const SizedBox(height: 30),
              _buildMainText(),
              const SizedBox(height: 15),
              const SizedBox(height: 30),
              _buildCoachImage(),
              const Spacer(),
              _buildContinueButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTickIcon() {
    return Image.asset(
      'assets/icons/plan_tick.png',
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }

  Widget _buildMainText() {
    return const Text(
      "Plan activated! We're excited to support your transformation",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2C3E50),
        height: 1.2,
      ),
    );
  }

  Widget _buildCoachImage() {
    return Image.asset(
      'assets/images/coaches.jpg',
      width: 320,
      height: 210,
      fit: BoxFit.contain,
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          // Navigator.push(
          //           // context,
          //           // MaterialPageRoute(
          //           //   builder: (context) => FitnessWellnessScreen(
                        
          //           //   ),
          //           // ),
          //         ); // Handle continue action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Go to Home',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
