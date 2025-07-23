import 'package:flutter/material.dart';
import 'effort_graph.dart';
import 'motivation_input.dart';

class DesiredWeight extends StatefulWidget {
  const DesiredWeight({super.key});

  @override
  State<DesiredWeight> createState() => _DesiredWeightState();
}

class _DesiredWeightState extends State<DesiredWeight> {
  bool isKg = true; // true = kg, false = lbs
  int selectedDesiredWeightKg = 60;
  int selectedDesiredWeightLbs = 132;
  bool _isButtonEnabled = false;

  final List<int> kgValues = List.generate(171, (index) => index + 30); // 30–200
  final List<int> lbsValues = List.generate(271, (index) => index + 66); // 66–336

  late FixedExtentScrollController _controllerKg;
  late FixedExtentScrollController _controllerLbs;

  @override
  void initState() {
    super.initState();
    _controllerKg = FixedExtentScrollController(initialItem: selectedDesiredWeightKg - 30);
    _controllerLbs = FixedExtentScrollController(initialItem: selectedDesiredWeightLbs - 66);
  }

  @override
  void dispose() {
    _controllerKg.dispose();
    _controllerLbs.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    setState(() {
      isKg = !isKg;
      if (isKg) {
        selectedDesiredWeightKg = (selectedDesiredWeightLbs * 0.453592).round();
        selectedDesiredWeightKg = selectedDesiredWeightKg.clamp(30, 200);
        _controllerKg.animateToItem(
          selectedDesiredWeightKg - 30,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _isButtonEnabled = selectedDesiredWeightKg != 60;
      } else {
        selectedDesiredWeightLbs = (selectedDesiredWeightKg * 2.20462).round();
        selectedDesiredWeightLbs = selectedDesiredWeightLbs.clamp(66, 336);
        _controllerLbs.animateToItem(
          selectedDesiredWeightLbs - 66,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _isButtonEnabled = selectedDesiredWeightLbs != 132;
      }
    });
  }

  void _onNextPressed() {
    final weight = isKg ? selectedDesiredWeightKg : selectedDesiredWeightLbs;
    final unit = isKg ? "kg" : "lbs";
    print("Selected Weight: $weight $unit");

    Navigator.push(context, MaterialPageRoute(builder: (context) => EffortGraph()));
  }

  @override
  Widget build(BuildContext context) {
    final controller = isKg ? _controllerKg : _controllerLbs;
    final values = isKg ? kgValues : lbsValues;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 10.0),
              child: IconButton(
                icon: Image.asset(
                  'assets/icons/Group(2).png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MotivationInput(),
                        ),
                      );
                },
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.50,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFECEFEE),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0C0C0C)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "your desired weight?",
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 20,
                  height: 1.4,
                  color: Color(0xFF222326),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Toggle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'kg',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isKg ? const Color(0xFF0C0C0C) : const Color(0xFF9EA3A9),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _toggleUnit,
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
                      alignment: isKg ? Alignment.centerLeft : Alignment.centerRight,
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
                const SizedBox(width: 12),
                Text(
                  'lbs',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: !isKg ? const Color(0xFF0C0C0C) : const Color(0xFF9EA3A9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Weight Picker Section
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Selected value label
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: isKg ? '$selectedDesiredWeightKg' : '$selectedDesiredWeightLbs',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF222326),
                            ),
                          ),
                          TextSpan(
                            text: isKg ? ' kg' : ' lbs',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF222326),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Horizontal Ruler Picker
                    Container(
                      width: 360,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: 360,
                              height: 160,
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
                                        selectedDesiredWeightKg = kgValues[index];
                                        _isButtonEnabled = selectedDesiredWeightKg != 60;
                                      } else {
                                        selectedDesiredWeightLbs = lbsValues[index];
                                        _isButtonEnabled = selectedDesiredWeightLbs != 132;
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 16),
                                            SizedBox(
                                              width: 20,
                                              height: 60,
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Container(
                                                  width: 1.5,
                                                  height: isLong ? 60 : 35,
                                                  color: isLong
                                                      ? const Color(0xFF222326)
                                                      : const Color(0xFF9EA3A9),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            if (isLong)
                                              Container(
                                                width: 30,
                                                height: 20,
                                                alignment: Alignment.center,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    '$val',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF222326),
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

                          // Center indicator line
                          Positioned(
                            top: 35,
                            bottom: 55,
                            child: Container(
                              width: 3,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0C0C0C),
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Next Button
            Padding(
              padding: const EdgeInsets.only(bottom: 45, left: 16, right: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _onNextPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
                        ? const Color(0xFF0C0C0C)
                        : const Color(0xFF7F8180),
                    foregroundColor: const Color(0xFFFFFFFF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
