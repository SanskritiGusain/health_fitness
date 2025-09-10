import 'package:flutter/material.dart';
import 'package:test_app/api/api_service.dart';
import 'package:test_app/chat/chat_start.dart';

// Make sure this import path is correct

class BodyHeightScreen extends StatefulWidget {
  const BodyHeightScreen({super.key});

  @override
  State<BodyHeightScreen> createState() => _BodyHeightScreenState();
}

class _BodyHeightScreenState extends State<BodyHeightScreen> {
  bool isCm = true;
  int selectedHeightCm = 165;
  int selectedHeightInch = 165;
  bool _isLoadingData = true;
  bool _isButtonEnabled = true;
    double _currentHeight = 0.0;
  final List<int> cmValues = List.generate(
    200,
    (index) => index + 20,
  ); // 50 - 200
  final List<int> inchValues = List.generate(
    151,
    (index) => index + 20,
  ); // 20 - 79

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
  }

  @override
  void dispose() {
    _controllerCm.dispose();
    _controllerIn.dispose();
    super.dispose();
  }
  
  Future<void> _updateHeight(double newWeightKg) async {
    if (!mounted) return;

    try {
      setState(() {
        _isButtonEnabled = false;
      });

      final body = {"current_weight": newWeightKg}; // keep it here

      await ApiService.putRequest("user/", body);

      setState(() {
        _currentHeight = newWeightKg; // ✅ see next fix
        _isButtonEnabled = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Weight updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Reload weight data after successful update
     
    } catch (e) {
      setState(() {
        _isButtonEnabled = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Failed to update weight: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final controller = isCm ? _controllerCm : _controllerIn;
    final values = isCm ? cmValues : inchValues;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB), // ADD THIS
        shadowColor: Colors.transparent, // ADD THIS
        toolbarHeight: 70,
        title: const Text(
          'Height',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222326),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF222326),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Horizontal divider under AppBar
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 25),

          // Toggle switch
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'cm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => isCm = !isCm),
                child: Container(
                  width: 41,
                  height: 23,
                  padding: const EdgeInsets.all(2),
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
                        color: Color(0xFFFFFFFF),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222326),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),

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

                  const SizedBox(width: 8),

                  // Picker with ruler
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 180,
                        height: 500,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.1,
                              ), // Soft shadow
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
                          height: 510,
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
                                          height: isLong ? 1 : 1,
                                          color:
                                              isLong
                                                  ? Color(0xFF222326)
                                                  : Color(0xFF9EA3A9),
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
                        child: Container(height: 2, color: Color(0xFF0C0C0C)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // background for navbar
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, -2), // shadow upwards
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // 🔹 padding from all sides
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
               onPressed:
                    _isButtonEnabled
                        ? () async {
                          // Convert to cm if currently in inches
                          final double updatedHeightCm =
                              isCm
                                  ? selectedHeightCm.toDouble()
                                  : selectedHeightInch * 2.54;

                          await _updateHeight(updatedHeightCm);

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        }
                        : null,

                child: const Text(
                  "Update",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ),
       floatingActionButton: SizedBox(
        height: 46,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
          backgroundColor: const Color.fromARGB(255, 170, 207, 171),
          label: const Text(
            "Ask Luna",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          icon: Image.asset("assets/icons/ai.png", height: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          extendedPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}