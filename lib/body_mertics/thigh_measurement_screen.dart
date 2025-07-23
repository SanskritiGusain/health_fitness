import 'package:flutter/material.dart';

class ThighMeasurementScreen extends StatefulWidget {
  const ThighMeasurementScreen({super.key});

  @override
  State<ThighMeasurementScreen> createState() => _ThighMeasurementScreenState();
}

class _ThighMeasurementScreenState extends State<ThighMeasurementScreen> {
  bool isCm = true; // true = cm, false = in
  int selectedThighCm = 35;
  double selectedThighIn = 13.8;

  final List<int> cmValues = List.generate(21, (index) => index + 30); // 30–50 cm
  final List<double> inValues = List.generate(81, (index) => (index + 118) / 10); // 11.8–19.8 in

  late FixedExtentScrollController _controllerCm;
  late FixedExtentScrollController _controllerIn;

  @override
  void initState() {
    super.initState();
    _controllerCm = FixedExtentScrollController(initialItem: selectedThighCm - 30);
    _controllerIn = FixedExtentScrollController(initialItem: ((selectedThighIn * 10).round() - 118));
  }

  @override
  void dispose() {
    _controllerCm.dispose();
    _controllerIn.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    setState(() {
      isCm = !isCm;
      if (isCm) {
        // Convert inches to cm
        selectedThighCm = (selectedThighIn * 2.54).round();
        selectedThighCm = selectedThighCm.clamp(30, 50);
        _controllerCm.animateToItem(
          selectedThighCm - 30,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Convert cm to inches
        selectedThighIn = ( selectedThighCm / 2.54);
      selectedThighIn =  selectedThighIn.clamp(11.8, 19.8);
        _controllerIn.animateToItem(
          (( selectedThighIn * 10).round() - 118),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controllerCm = _controllerCm;
    final controllerIn = _controllerIn;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
     appBar: AppBar(
  elevation: 0,
  backgroundColor: const Color(0xFFF8FBFB),
  surfaceTintColor: const Color(0xFFF8FBFB),
  shadowColor: Colors.transparent,
  toolbarHeight: 80,
  title: const Text(
    'Thigh Measurement',
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
    const SizedBox(height: 20),

          
          // Toggle switch
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'cm',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCm ? const Color(0xFF0C0C0C) : const Color(0xFF9EA3A9),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _toggleUnit,
                child: Container(
                  width: 44,
                  height: 24,
                  padding: const EdgeInsets.all(1),
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
                        color: Color(0xFFFFFFFF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'in',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: !isCm ? const Color(0xFF0C0C0C) : const Color(0xFF9EA3A9),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 25),
          
          // Selected neck measurement display
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: isCm ? '$selectedThighCm' : '${selectedThighIn.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222326),
                  ),
                ),
                TextSpan(
                  text: isCm ? ' cm' : ' in',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF767780),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 25),
          
          // Horizontal Ruler Picker
          Container(
            width: MediaQuery.of(context).size.width - 32,
            height: 132,
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
                    width: MediaQuery.of(context).size.width - 32,
                    height: 132,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: ListWheelScrollView.useDelegate(
                        controller: isCm ? controllerCm : controllerIn,
                        itemExtent: 25,
                        diameterRatio: 100,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            if (isCm) {
                              selectedThighCm = cmValues[index];
                            } else {
                              selectedThighIn = inValues[index];
                            }
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: isCm ? cmValues.length : inValues.length,
                          builder: (context, index) {
                            if (isCm) {
                              final val = cmValues[index];
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
                            } else {
                              final val = inValues[index];
                              final isLong = (val * 10).round() % 5 == 0;
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
                                            '${val.toStringAsFixed(1)}',
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
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Center indicator line
                Positioned(
                  top: 15,
                  bottom: 35,
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
          
          const SizedBox(height: 40),
          
          // Analytics Header (no card)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analytics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222326),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Track thigh measurement progress',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9EA3A9),
                      ),
                    ),
                    Text(
                      'with analytics-driven graphs',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9EA3A9),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDDE5F0)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Handle dropdown action
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Weekly',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF222326),
                          ),
                        ),
                        SizedBox(width: 0),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 22,
                          color: Color(0xFF767780),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Chart Card (only the chart has a card)
          Container(
            width: double.infinity,
            height: 290,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: NeckChartPainter(isCm: isCm),
                size: const Size(double.infinity, 200),
              ),
            ),
          ),
          
         
        ],
      ),
    );
  }
}

class NeckChartPainter extends CustomPainter {
  final bool isCm;
  
  NeckChartPainter({required this.isCm});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2196F3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Grid lines paint
    final gridPaint = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Minor grid lines paint (for intermediate lines)
    final minorGridPaint = Paint()
      ..color = const Color(0xFFE8E8E8).withOpacity(0.5)
      ..strokeWidth = 0.3
      ..style = PaintingStyle.stroke;

    // Dotted line paint for average
    final dottedPaint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Background
    final bgPaint = Paint()
      ..color = const Color(0xFFFAFAFA)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Chart area with padding
    final chartPadding = EdgeInsets.only(left: 50, right: 30, top: 20, bottom: 40);
    final chartRect = Rect.fromLTWH(
      chartPadding.left,
      chartPadding.top,
      size.width - chartPadding.left - chartPadding.right,
      size.height - chartPadding.top - chartPadding.bottom,
    );

    // Draw horizontal grid lines (5 major lines)
    const horizontalGridLines = 5;
    for (int i = 0; i <= horizontalGridLines; i++) {
      final y = chartRect.top + (chartRect.height / horizontalGridLines) * i;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    // Draw vertical grid lines (5 major lines)
    const verticalGridLines = 5;
    for (int i = 0; i <= verticalGridLines; i++) {
      final x = chartRect.left + (chartRect.width / verticalGridLines) * i;
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }

    // Draw L-shaped axis lines (X and Y axis)
    final axisPaint = Paint()
      ..color = const Color(0xFF767780)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Axis dots paint
    final axisDotPaint = Paint()
      ..color = const Color(0xFF767780)
      ..style = PaintingStyle.fill;

    // Y-axis line (left side)
    canvas.drawLine(
      Offset(chartRect.left, chartRect.top),
      Offset(chartRect.left, chartRect.bottom),
      axisPaint,
    );

    // X-axis line (bottom)
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      axisPaint,
    );

    // Draw dots at the top ends of both axes
    // Dot at top of Y-axis
    canvas.drawCircle(
      Offset(chartRect.left, chartRect.top),
      3,
      axisDotPaint,
    );

    // Dot at right end of X-axis
    canvas.drawCircle(
      Offset(chartRect.right, chartRect.bottom),
      3,
      axisDotPaint,
    );

    // Draw 4 intermediate vertical lines between each major grid line
    for (int i = 0; i < verticalGridLines; i++) {
      final startX = chartRect.left + (chartRect.width / verticalGridLines) * i;
      final endX = chartRect.left + (chartRect.width / verticalGridLines) * (i + 1);
      final segmentWidth = endX - startX;
      
      // Draw 4 intermediate lines
      for (int j = 1; j <= 4; j++) {
        final x = startX + (segmentWidth / 5) * j;
        canvas.drawLine(
          Offset(x, chartRect.top),
          Offset(x, chartRect.bottom),
          minorGridPaint,
        );
      }
    }

    // Sample data points for the chart
    final dataPoints = [
      Offset(chartRect.left + chartRect.width * 0.05, chartRect.bottom - chartRect.height * 0.2),  // Jan
      Offset(chartRect.left + chartRect.width * 0.15, chartRect.bottom - chartRect.height * 0.3),  // Feb
      Offset(chartRect.left + chartRect.width * 0.25, chartRect.bottom - chartRect.height * 0.25), // Mar
      Offset(chartRect.left + chartRect.width * 0.35, chartRect.bottom - chartRect.height * 0.4),  // Apr
      Offset(chartRect.left + chartRect.width * 0.45, chartRect.bottom - chartRect.height * 0.5),  // May
      Offset(chartRect.left + chartRect.width * 0.55, chartRect.bottom - chartRect.height * 0.45), // Jun
      Offset(chartRect.left + chartRect.width * 0.65, chartRect.bottom - chartRect.height * 0.6),  // Jul
      Offset(chartRect.left + chartRect.width * 0.75, chartRect.bottom - chartRect.height * 0.55), // Aug
      Offset(chartRect.left + chartRect.width * 0.85, chartRect.bottom - chartRect.height * 0.7),  // Sep
      Offset(chartRect.left + chartRect.width * 0.95, chartRect.bottom - chartRect.height * 0.8),  // Oct
    ];

    // Draw the line chart connecting all points
    final path = Path();
    path.moveTo(dataPoints[0].dx, dataPoints[0].dy);
    for (int i = 1; i < dataPoints.length; i++) {
      path.lineTo(dataPoints[i].dx, dataPoints[i].dy);
    }
    canvas.drawPath(path, paint);
    
    // Draw points
    final pointPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;
    
    for (final point in dataPoints) {
      canvas.drawCircle(point, 3, pointPaint);
    }

    // Draw average line (dotted)
    final averageY = chartRect.bottom - chartRect.height * 0.5;
    _drawDottedLine(canvas, Offset(chartRect.left, averageY), Offset(chartRect.right, averageY), dottedPaint);

    // Draw "Avg." text
    final avgTextPainter = TextPainter(
      text: const TextSpan(
        text: 'Avg.',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    avgTextPainter.layout();
    avgTextPainter.paint(canvas, Offset(chartRect.right + 5, averageY - 8));

    // Draw Y-axis labels (5 values)
    final yLabels = isCm ? ['32', '34', '36', '38', '40'] : ['12.6', '13.4', '14.2', '15.0', '15.7'];
    for (int i = 0; i < yLabels.length; i++) {
      final y = chartRect.bottom - (chartRect.height / (yLabels.length - 1)) * i;
      final labelPainter = TextPainter(
        text: TextSpan(
          text: yLabels[i],
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(chartRect.left - labelPainter.width - 8, y - 6));
    }

    // Draw X-axis labels (5 main labels)
    final xLabels = ['Jan', 'Mar', 'May', 'Jul', 'Sep'];
    for (int i = 0; i < xLabels.length; i++) {
      final x = chartRect.left + (chartRect.width / (xLabels.length - 1)) * i;
      final labelPainter = TextPainter(
        text: TextSpan(
          text: xLabels[i],
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(x - labelPainter.width / 2, chartRect.bottom + 10));
    }
  }

  void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5;
    const dashSpace = 3;
    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startOffset = start + (end - start) * (i * (dashWidth + dashSpace) / distance);
      final endOffset = start + (end - start) * ((i * (dashWidth + dashSpace) + dashWidth) / distance);
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}