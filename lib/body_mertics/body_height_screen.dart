import 'package:flutter/material.dart';

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
  toolbarHeight: 80,
  title: const Text(
    'Body Weight',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF222326),
    ),
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Color(0xFF222326)),
    onPressed: () => Navigator.pop(context),
  ),
  actions: [
    TextButton(
      onPressed: () {
        // Handle update action
      },
      child: const Text(
        'Update',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3C8F7C),
        ),
      ),
    ),
  ],
),
      body: Column(
        children: [
           // Horizontal divider under AppBar
    Container(
      height: 1,
      color: Colors.grey.shade300,
    ),
    const SizedBox(height: 25),

            // Toggle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('cm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => isCm = !isCm),
                  child: Container(
                    width: 44,
                    height: 24,
                    padding: const EdgeInsets.all(2),
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
                const Text('in', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Color(0xFF222326))),
              ],
            ),
            const SizedBox(height: 8),

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
                          height: 530,
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

          ],
        ),
   
    );
  }
}
