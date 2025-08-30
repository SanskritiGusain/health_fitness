import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:test_app/theme/app_theme.dart'; // Import for theme extension access
import 'package:test_app/utils/custom_app_bars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/utils/custom_bottom_nav.dart';

class SleepTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBars.simpleAppBar(context, "Sleep"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Goal Section
                    Padding(
                      // padding: EdgeInsets.symmetric(horizontal: 14),
                      padding: EdgeInsetsGeometry.fromLTRB(14, 28, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Today's Goal",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              // inside SleepTrackerScreen build → Replace the "Add manually" Row with GestureDetector
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return _buildSleepTimeBottomSheet(
                                            context,
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.purple,
                                          size: 18,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Add manually',
                                          style: TextStyle(
                                            color: Colors.purple,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Container(
                            height: 100,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center, // 👈 Align items center
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center, // 👈 Center vertically
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Goal:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        '8hr',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Completed:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        '7hr',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final w = constraints.maxWidth;
                                      final h = constraints.maxHeight;

                                      // make the curve 45% wider than the column
                                      final bgWidth = w * 1.45;
                                      // push part of it outside to the right so the curve looks “fatter”
                                      final rightOverflow =
                                          (bgWidth - w) * 0.60;

                                      return Stack(
                                        clipBehavior:
                                            Clip.none, // allow the SVG to bleed outside
                                        children: [
                                          // Bigger curve in the background
                                          Positioned(
                                            top: 0,
                                            bottom: 0,
                                            right:
                                                -rightOverflow, // shift to the right
                                            child: SizedBox(
                                              width: bgWidth,
                                              height: h,
                                              child: SvgPicture.asset(
                                                'assets/icons/curve.svg',
                                                fit:
                                                    BoxFit
                                                        .cover, // keeps proportions, fills nicely
                                                alignment:
                                                    Alignment.centerRight,
                                              ),
                                            ),
                                          ),

                                          // Girl on top (adjust these numbers to taste)
                                          Positioned(
                                            right: -2,
                                            top: 8,
                                            child: SvgPicture.asset(
                                              'assets/icons/sleeping_girl.svg',
                                              height: 78,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Sleep Stages Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sleep stages',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Breakdown of your sleep cycle',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 32),

                          // Circular Chart
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Circular Chart
                                Center(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    child: CustomPaint(
                                      painter: SleepChartPainter(),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 32),

                                // Legend
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildLegendItem(
                                          color: Colors.green,
                                          title: 'Deep',
                                          percentage: '24%',
                                        ),
                                        _buildLegendItem(
                                          color: Colors.blue,
                                          title: 'Light',
                                          percentage: '46%',
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildLegendItem(
                                          color: Colors.orange,
                                          title: 'REM',
                                          percentage: '24%',
                                        ),
                                        _buildLegendItem(
                                          color: Colors.pink,
                                          title: 'Awake',
                                          percentage: '20%',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: CustomNavBar(
        currentIndex: 3, // example
        onTap: (index) {
          // handle navigation
        },
      ),
    );
  }

Widget _buildSleepTimeBottomSheet(BuildContext context) {
    TimeOfDay? bedTime;
    TimeOfDay? wakeupTime;

    Future<void> _pickTime(BuildContext context, bool isBedTime) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        if (isBedTime) {
          bedTime = picked;
        } else {
          wakeupTime = picked;
        }
        // refresh bottom sheet
        (context as Element).markNeedsBuild();
      }
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  Text(
                    "Sleep Time",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),

                  // Bed Time
                  Text("Bed Time"),
                  SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text:
                          bedTime != null
                              ? bedTime!.format(context)
                              : "09:30 pm",
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: bedTime ?? TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => bedTime = picked);
                          }
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Wakeup Time
                  Text("Wakeup Time"),
                  SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text:
                          wakeupTime != null
                              ? wakeupTime!.format(context)
                              : "07:30 am",
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: wakeupTime ?? TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => wakeupTime = picked);
                          }
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Add button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "bedTime": bedTime?.format(context),
                        "wakeupTime": wakeupTime?.format(context),
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Add"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildLegendItem({
    required Color color,
    required String title,
    required String percentage,
  }) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              percentage,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}

class SleepChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final strokeWidth = 20.0;
    final gap = 0.25; // ~3 degrees gap
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
    // Background circle
    paint.color = Colors.grey[200]!;
    canvas.drawCircle(center, radius, paint);
    // Sleep stage angles
    final deepSleepAngle = 2 * math.pi * 0.24;
    final lightSleepAngle = 2 * math.pi * 0.46;
    final remSleepAngle = 2 * math.pi * 0.24;
    final awakeAngle = 2 * math.pi * 0.06;
    double startAngle = -math.pi / 2; // Start from top
    // Deep Sleep (Green)
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      deepSleepAngle - gap,
      false,
      paint,
    );
    startAngle += deepSleepAngle;
    // Light Sleep (Blue)
    paint.color = Colors.blue;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + gap,
      lightSleepAngle - gap,
      false,
      paint,
    );
    startAngle += lightSleepAngle;
    // REM Sleep (Orange)
    paint.color = Colors.orange;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + gap,
      remSleepAngle - gap,
      false,
      paint,
    );
    startAngle += remSleepAngle;
    // Awake (Pink)
    paint.color = Colors.pink;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + gap,
      awakeAngle - gap,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
