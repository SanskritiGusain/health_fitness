import 'package:flutter/material.dart';

import 'package:test_app/pages/location_select.dart';

import '../pages/weight_input.dart'; // Make sure this import path is correct

class HeightInputPage extends StatefulWidget {
  const HeightInputPage({super.key});

  @override
  State<HeightInputPage> createState() => _HeightInputPageState();
}

class _HeightInputPageState extends State<HeightInputPage> {
  bool isCm = true;
  int selectedHeightCm = 165;
  int selectedHeightInch = 165;
  bool _isButtonEnabled = false;

  final List<int> cmValues = List.generate(200, (index) => index + 20); // 50 - 200
  final List<int> inchValues = List.generate(151, (index) => index + 20); // 20 - 79

  late FixedExtentScrollController _controllerCm;
  late FixedExtentScrollController _controllerIn;

  @override
  void initState() {
    super.initState();
    _controllerCm = FixedExtentScrollController(initialItem: selectedHeightCm - 50);
    _controllerIn = FixedExtentScrollController(initialItem: selectedHeightInch - 20);
  }

  @override
  void dispose() {
    _controllerCm.dispose();
    _controllerIn.dispose();
    super.dispose();
  }

    void _submit() {
 Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WeightInputPage(
      height: isCm ? selectedHeightCm.toDouble() : selectedHeightInch * 2.54,
    ),
  ),
);

  }

  @override
  Widget build(BuildContext context) {
    final controller = isCm ? _controllerCm : _controllerIn;
    final values = isCm ? cmValues : inchValues;

    return Scaffold(
      backgroundColor: Color(0xFFF8FBFB),
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
        MaterialPageRoute(builder: (context) => LocationSelectionPage()),
      );/// Go back to previous screen
                },
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.35,
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
                "Height",
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
                const Text('cm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => isCm = !isCm),
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
                      alignment: isCm ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF)
,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('in', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Color(0xFF222326))),
              ],
            ),
            const SizedBox(height: 4),

            // Height Picker Section
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Selected value label
                   Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: isCm ? '$selectedHeightCm' : '$selectedHeightInch',
        style: const TextStyle(
          fontSize: 20, // Big value
          fontWeight: FontWeight.w600,
          color: Color(0xFF222326),
        ),
      ),
      TextSpan(
        text: isCm ? ' cm' : ' in',
        style: const TextStyle(
          fontSize: 14, // Smaller unit
          fontWeight: FontWeight.w400,
          color: Color(0xFF222326),
        ),
      ),
    ],
  ),
),

                    const SizedBox(width: 24),

                    // Picker with ruler
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 420,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                                   boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Soft shadow
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 180,
                            height: 400,
                            child: ListWheelScrollView.useDelegate(
                              controller: controller,
                              itemExtent: 20,
                              diameterRatio: 100,
                              physics: const FixedExtentScrollPhysics(),
                           onSelectedItemChanged: (index) {
  setState(() {
    if (isCm) {
      selectedHeightCm = cmValues[index];
      _isButtonEnabled = selectedHeightCm != 165;
    } else {
      selectedHeightInch = inchValues[index];
      _isButtonEnabled = selectedHeightInch != 165;
    }
  });
},

                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: values.length,
                                builder: (context, index) {
                                  final val = values[index];
                                  final isLong = val % 5 == 0;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 16),
                                      SizedBox(
                                        width: 60,
                                        height: 20,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: isLong ? 60 : 35,
                                            height: isLong ? 1 : 1,
                                            color: isLong ? Color(0xFF222326):Color(0xFF9EA3A9),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      if (isLong)
                                        Text('$val', style: const TextStyle(fontSize: 14)),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 45,
                          right: 65,
                          child: Container(height: 2, color: Color(0xFF0C0C0C)),
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
