import 'package:flutter/material.dart';
import 'package:test_app/body_mertics/bmi_screen.dart';
import 'package:test_app/pages/height_input.dart';

import '../pages/location_select.dart';

class WeightInputPage extends StatefulWidget {
   final double height;
const WeightInputPage({super.key, required this.height});


  @override
  State<WeightInputPage> createState() => _WeightInputPageState();
}

class _WeightInputPageState extends State<WeightInputPage> {
  bool isKg = true;
  int selectedWeightKg = 60;
  int selectedWeightLbs = 132;
  bool _isButtonEnabled = false;

  final List<int> kgValues = List.generate(171, (index) => index + 30); // 30–200
  final List<int> lbsValues = List.generate(271, (index) => index + 66); // 66–336

  late FixedExtentScrollController _controllerKg;
  late FixedExtentScrollController _controllerLbs;

  @override
  void initState() {
    super.initState();
    _controllerKg = FixedExtentScrollController(initialItem: kgValues.indexOf(selectedWeightKg));
    _controllerLbs = FixedExtentScrollController(initialItem: lbsValues.indexOf(selectedWeightLbs));
  }

  @override
  void dispose() {
    _controllerKg.dispose();
    _controllerLbs.dispose();
    super.dispose();
  }
void _submit() {
  final double heightInMeters = widget.height / 100;
  final double weight = isKg ? selectedWeightKg.toDouble() : selectedWeightLbs / 2.20462;
  final double bmi = weight / (heightInMeters * heightInMeters);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BMIScreen(bmi: bmi),
    ),
  );
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
              padding: const EdgeInsets.only(bottom: 10.0),
              child: IconButton(
                icon: Image.asset(
                  'assets/icons/Group(2).png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HeightInputPage()),
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
                  color: const Color(0xFF0C0C0C),
                ),
              ),
            ),
            const SizedBox(height: 16),

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
                const Text('kg', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                const SizedBox(width: 8),
                const Text('lbs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF222326))),
              ],
            ),
            const SizedBox(height: 8),

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
                            text: isKg ? '$selectedWeightKg' : '$selectedWeightLbs',
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
                    const SizedBox(height: 24),

                    // Horizontal Ruler Picker
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 360,
                          height: 160,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                                                 boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Soft shadow
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
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
      selectedWeightKg = kgValues[index];
    } else {
      selectedWeightLbs = lbsValues[index];
    }
    _isButtonEnabled = true; // Enable after interaction
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
                                                width: 1,
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
                                              width: 25,
                                              height: 20,
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  '$val',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
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
                          child: Container(width: 2, color: const Color(0xFF0C0C0C)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Next Button
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 45),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
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
        ),
      ),
    );
  }
}
