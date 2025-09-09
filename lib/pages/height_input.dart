// lib/pages/height_input.dart
import 'package:flutter/material.dart';
import 'package:test_app/pages/location_select.dart';
import 'package:test_app/pages/weight_input.dart';
import 'package:test_app/utils/persistent_data.dart';

class HeightInputPage extends StatefulWidget {
  const HeightInputPage({super.key});

  @override
  State<HeightInputPage> createState() => _HeightInputPageState();
}

class _HeightInputPageState extends State<HeightInputPage> {
  bool isCm = true;
  int selectedHeightCm = 165;
  int selectedHeightInch = 65;
  bool _isButtonEnabled = true;

  final List<int> cmValues = List.generate(200, (index) => index + 50);
  final List<int> inchValues = List.generate(151, (index) => index + 20);

  late FixedExtentScrollController _controllerCm;
  late FixedExtentScrollController _controllerIn;

  @override
  void initState() {
    super.initState();
    _controllerCm = FixedExtentScrollController(
      initialItem: selectedHeightCm - 50,
    );
    _controllerIn = FixedExtentScrollController(
      initialItem: selectedHeightInch - 20,
    );
    _loadSavedHeight();
  }

  @override
  void dispose() {
    _controllerCm.dispose();
    _controllerIn.dispose();
    super.dispose();
  }

  Future<void> _loadSavedHeight() async {
    final savedHeight = await PersistentData.getHeight();

    if (savedHeight != null) {
      setState(() {
        selectedHeightCm = savedHeight.round();
        selectedHeightInch = (savedHeight / 2.54).round();

        // Move pickers to correct position
        _controllerCm.jumpToItem(selectedHeightCm - 50);
        _controllerIn.jumpToItem(selectedHeightInch - 20);
      });
    }
  }

  void _submit() async {
    final heightInCm =
        isCm ? selectedHeightCm.toDouble() : selectedHeightInch * 2.54;

    // Save height using utility class
    await PersistentData.saveHeight(heightInCm);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeightInputPage(height: heightInCm),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = isCm ? _controllerCm : _controllerIn;
    final values = isCm ? cmValues : inchValues;

    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button and Progress bar
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 28, right: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/Group(2).png',
                      width: screenWidth * 0.06,
                      height: screenWidth * 0.06,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationSelectionPage(),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.45,
                        minHeight: 6,
                        backgroundColor: Color(0xFFECEFEE),
                        color: Color(0xFF0C0C0C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: const Text(
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
            SizedBox(height: screenHeight * 0.015),

            // Toggle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'cm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => isCm = !isCm),
                  child: Container(
                    width: screenWidth * 0.12,
                    height: 28,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C0C0C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment:
                          isCm ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'in',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222326),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),

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
                            text:
                                isCm
                                    ? '$selectedHeightCm'
                                    : '$selectedHeightInch',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF222326),
                            ),
                          ),
                          TextSpan(
                            text: isCm ? ' cm' : ' in',
                            style: const TextStyle(
                              fontSize: 14,
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
                          width: screenWidth * 0.45,
                          height: screenHeight * 0.52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: screenWidth * 0.45,
                            height: screenHeight * 0.48,
                            child: ListWheelScrollView.useDelegate(
                              controller: controller,
                              itemExtent: 20,
                              diameterRatio: 100,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  if (isCm) {
                                    selectedHeightCm = cmValues[index];
                                  } else {
                                    selectedHeightInch = inchValues[index];
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
                                            height: 1,
                                            color:
                                                isLong
                                                    ? const Color(0xFF222326)
                                                    : const Color(0xFF9EA3A9),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      if (isLong)
                                        Text(
                                          '$val',
                                          style: const TextStyle(fontSize: 14),
                                        ),
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
                          child: Container(
                            height: 2,
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
              padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                bottom: screenHeight * 0.05,
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
                      color: Colors.white,
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
