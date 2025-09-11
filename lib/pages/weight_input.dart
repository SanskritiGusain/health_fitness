import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/api/api_service.dart';
import 'package:test_app/pages/gif_splash_page.dart';
import 'package:test_app/pages/height_input.dart';
import 'package:test_app/shared_preferences.dart' as userApi;

class WeightInputPage extends StatefulWidget {
 
  const WeightInputPage({super.key});

  @override
  State<WeightInputPage> createState() => _WeightInputPageState();
}

class _WeightInputPageState extends State<WeightInputPage> {
  bool isKg = true;
  int selectedWeightKg = 60;
  int selectedWeightLbs = 132;
  bool _isButtonEnabled = true;

  final List<int> kgValues = List.generate(
    171,
    (index) => index + 30,
  ); // 30–200
  final List<int> lbsValues = List.generate(
    271,
    (index) => index + 66,
  ); // 66–336

  late FixedExtentScrollController _controllerKg;
  late FixedExtentScrollController _controllerLbs;

  @override
  void initState() {
    super.initState();
    _controllerKg = FixedExtentScrollController(
      initialItem: kgValues.indexOf(selectedWeightKg),
    );
    _controllerLbs = FixedExtentScrollController(
      initialItem: lbsValues.indexOf(selectedWeightLbs),
    );
    _loadSavedWeight();
  }

  @override
  void dispose() {
    _controllerKg.dispose();
    _controllerLbs.dispose();
    super.dispose();
  }

  Future<void> _loadSavedWeight() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWeight = prefs.getDouble("user_weight"); // always stored in kg

    if (savedWeight != null) {
      setState(() {
        selectedWeightKg = savedWeight.round();
        selectedWeightLbs = (savedWeight * 2.20462).round();

        // update scroll positions
        _controllerKg.jumpToItem(kgValues.indexOf(selectedWeightKg));
        _controllerLbs.jumpToItem(lbsValues.indexOf(selectedWeightLbs));
      });
    }
  }

  Future<void> _saveWeight(double weightKg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("user_weight", weightKg);
  }

  void _submit() async {
    setState(() => _isButtonEnabled = false);

    try {
      final double weightKg =
          isKg ? selectedWeightKg.toDouble() : selectedWeightLbs / 2.20462;

      // Save weight locally
      await userApi.PersistentData.saveWeight(weightKg);

      // Get first-phase user data from shared preferences
      final body = await userApi.PersistentData.getFirstPhaseUserData();

      // 🖥️ Debug log
      print("📤 API  first api Request Body (user/): $body");
      // Send API call using the generic PUT method
      final response = await ApiService.putRequest("user/", body);

      print("✅ Data sent successfully: $response");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data sent successfully!")));

      // Navigate to GifSplashPage after successful API call
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GifSplashPage()),
        );
      }
    } catch (e) {
      print("🔥 Exception in submit: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to send data.")));
    } finally {
      setState(() => _isButtonEnabled = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final controller = isKg ? _controllerKg : _controllerLbs;
    final values = isKg ? kgValues : lbsValues;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and Progress bar in same row
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 28, right: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/Group(2).png',
                          width: 24,
                          height: 24,
                        ),
                     onPressed: () {
  // Navigator.pushReplacement(
  //   context,
  //   MaterialPageRoute(builder: (_) => const HeightInputPage()),
  // );

  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const HeightInputPage()),
  (Route<dynamic> route) => false,
);

}

                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 0.50,
                            minHeight: 6,
                            backgroundColor: Color(0xFFECEFEE),
                            color: Color(0xFF0C0C0C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Weight",
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 20,
                      height: 2.8,
                      color: Color(0xFF222326),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Toggle switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'kg',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => isKg = !isKg),
                      child: Container(
                        width: 48,
                        height: 28,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C0C0C),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment:
                              isKg
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'lbs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Weight Picker Section
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    isKg
                                        ? '$selectedWeightKg'
                                        : '$selectedWeightLbs',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF222326),
                                ),
                              ),
                              TextSpan(
                                text: isKg ? ' kg' : ' lbs',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF222326),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Scroll Picker
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.18,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.18,
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: controller,
                                    itemExtent: 25,
                                    diameterRatio: 100,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        if (isKg) {
                                          selectedWeightKg = kgValues[index];
                                        } else {
                                          selectedWeightLbs = lbsValues[index];
                                        }
                                      });
                                    },
                                    childDelegate: ListWheelChildBuilderDelegate(
                                      childCount: values.length,
                                      builder: (context, index) {
                                        final val = values[index];
                                        final isLong = val % 5 == 0;
                                        return RotatedBox(
                                          quarterTurns: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 16),
                                              SizedBox(
                                                width: 20,
                                                height: 60,
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                    width: 1,
                                                    height: isLong ? 60 : 35,
                                                    color:
                                                        isLong
                                                            ? const Color(
                                                              0xFF222326,
                                                            )
                                                            : const Color(
                                                              0xFF9EA3A9,
                                                            ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              if (isLong)
                                                Container(
                                                  width: 25,
                                                  height: 20,
                                                  alignment: Alignment.center,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      '$val',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight
                                                                .w400, // Consistent font weight
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 35,
                              bottom: 55,
                              child: Container(
                                width: 2,
                                color: const Color(0xFF0C0C0C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Next Button
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 45,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isButtonEnabled
                                ? const Color(0xFF0C0C0C)
                                : const Color(0xFF7F8180),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 15,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
