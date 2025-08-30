import 'package:flutter/material.dart';

// In each of your measurement screen files
// Enum for different body parts
enum BodyPart { neck, chest, arms, waist, thighs, hips }

// Data model for body measurements
class BodyMeasurement {
  final BodyPart part;
  final int valueCm;
  final double valueIn;
  final DateTime date;

  BodyMeasurement({
    required this.part,
    required this.valueCm,
    required this.valueIn,
    required this.date,
  });
}

class BodyMeasurementScreen extends StatefulWidget {
  final BodyPart bodyPart;
  final BodyMeasurement? existingMeasurement;

  const BodyMeasurementScreen({
    super.key,
    required this.bodyPart,
    this.existingMeasurement,
  });

  @override
  State<BodyMeasurementScreen> createState() => _BodyMeasurementScreenState();
}

class _BodyMeasurementScreenState extends State<BodyMeasurementScreen> {
  bool isCm = true;
  int selectedValueCm = 35;
  double selectedValueIn = 13.8;

  final Map<BodyPart, Map<String, dynamic>> bodyPartConfig = {
    BodyPart.neck: {
      'name': 'Neck',
      'cm': List.generate(21, (index) => index + 30), // 30-50 cm
      'in': List.generate(81, (index) => (index + 118) / 10), // 11.8-19.8 in
      'defaultCm': 35,
      'defaultIn': 13.8,
    },
    BodyPart.chest: {
      'name': 'Chest',
      'cm': List.generate(61, (index) => index + 70), // 70-130 cm
      'in': List.generate(121, (index) => (index + 276) / 10), // 27.6-39.6 in
      'defaultCm': 90,
      'defaultIn': 35.4,
    },
    BodyPart.arms: {
      'name': 'Arms',
      'cm': List.generate(31, (index) => index + 20), // 20-50 cm
      'in': List.generate(121, (index) => (index + 79) / 10), // 7.9-19.9 in
      'defaultCm': 30,
      'defaultIn': 11.8,
    },
    BodyPart.waist: {
      'name': 'Waist',
      'cm': List.generate(61, (index) => index + 60), // 60-120 cm
      'in': List.generate(121, (index) => (index + 236) / 10), // 23.6-35.6 in
      'defaultCm': 80,
      'defaultIn': 31.5,
    },
    BodyPart.thighs: {
      'name': 'Thighs',
      'cm': List.generate(41, (index) => index + 40), // 40-80 cm
      'in': List.generate(121, (index) => (index + 157) / 10), // 15.7-27.7 in
      'defaultCm': 55,
      'defaultIn': 21.7,
    },
    BodyPart.hips: {
      'name': 'Hips',
      'cm': List.generate(61, (index) => index + 70), // 70-130 cm
      'in': List.generate(121, (index) => (index + 276) / 10), // 27.6-39.6 in
      'defaultCm': 90,
      'defaultIn': 35.4,
    },
  };

  late FixedExtentScrollController _controllerCm;
  late FixedExtentScrollController _controllerIn;

  @override
  void initState() {
    super.initState();

    final config = bodyPartConfig[widget.bodyPart]!;

    // Initialize with existing measurement or default values
    if (widget.existingMeasurement != null) {
      selectedValueCm = widget.existingMeasurement!.valueCm;
      selectedValueIn = widget.existingMeasurement!.valueIn;
    } else {
      selectedValueCm = config['defaultCm'];
      selectedValueIn = config['defaultIn'];
    }

    final cmValues = config['cm'] as List<int>;
    final inValues = config['in'] as List<double>;

    // Find initial indices with better logic for inches
    int cmIndex = cmValues.indexOf(selectedValueCm);
    if (cmIndex == -1) cmIndex = cmValues.length ~/ 2;

    int inIndex = inValues.indexWhere(
      (val) => (val - selectedValueIn).abs() < 0.05,
    );
    if (inIndex == -1) inIndex = inValues.length ~/ 2;

    _controllerCm = FixedExtentScrollController(initialItem: cmIndex);
    _controllerIn = FixedExtentScrollController(initialItem: inIndex);
  }

  String _getBodyPartName() {
    return bodyPartConfig[widget.bodyPart]!['name'] as String;
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
      final config = bodyPartConfig[widget.bodyPart]!;
      final cmValues = config['cm'] as List<int>;
      final inValues = config['in'] as List<double>;

      if (isCm) {
        // Convert inches to cm
        selectedValueCm = (selectedValueIn * 2.54).round();
        selectedValueCm = selectedValueCm.clamp(cmValues.first, cmValues.last);
        final newIndex = cmValues.indexOf(selectedValueCm);
        if (newIndex != -1) {
          _controllerCm.animateToItem(
            newIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        // Convert cm to inches
        selectedValueIn = (selectedValueCm / 2.54);
        selectedValueIn = selectedValueIn.clamp(inValues.first, inValues.last);
        final newIndex = inValues.indexWhere(
          (val) => (val - selectedValueIn).abs() < 0.05,
        );
        if (newIndex != -1) {
          _controllerIn.animateToItem(
            newIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Widget _buildRulerItem(int index, List<int> cmValues, List<double> inValues) {
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
                  color:
                      isLong
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
                  color:
                      isLong
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
  }

  @override
  Widget build(BuildContext context) {
    final config = bodyPartConfig[widget.bodyPart]!;
    final cmValues = config['cm'] as List<int>;
    final inValues = config['in'] as List<double>;

    final controllerCm = _controllerCm;
    final controllerIn = _controllerIn;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB),
        shadowColor: Colors.transparent,
        toolbarHeight: 70,
        title: Text(
          '${_getBodyPartName()} Measurement',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222326),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF222326),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Container(height: 1, color: Colors.grey.shade300),
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
                      color:
                          isCm
                              ? const Color(0xFF0C0C0C)
                              : const Color(0xFF9EA3A9),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _toggleUnit,
                    child: Container(
                      width: 42,
                      height: 22,
                      padding: const EdgeInsets.all(1),
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
                  const SizedBox(width: 12),
                  Text(
                    'in',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          !isCm
                              ? const Color(0xFF0C0C0C)
                              : const Color(0xFF9EA3A9),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Selected measurement display
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          isCm
                              ? '$selectedValueCm'
                              : '${selectedValueIn.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 20,
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
                        height: 172,
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
                                  selectedValueCm = cmValues[index];
                                } else {
                                  selectedValueIn = inValues[index];
                                }
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount:
                                  isCm ? cmValues.length : inValues.length,
                              builder: (context, index) {
                                return _buildRulerItem(
                                  index,
                                  cmValues,
                                  inValues,
                                );
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

              const SizedBox(height: 22),

              // Analytics Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Analytics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF222326),
                          ),
                        ),

                        const SizedBox(height: 12),
                        const Text(
                          'Track measurement progress',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF9EA3A9),
                          ),
                        ),
                        const Text(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
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

              const SizedBox(height: 26),

              // Chart Card
              Container(
                width: double.infinity,
                height: 320,
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
                    painter: BodyChartPainter(
                      isCm: isCm,
                      bodyPart: widget.bodyPart,
                    ),
                    size: const Size(double.infinity, 200),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Color(0xFFF8FBFB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // Save the measurement
                  final measurement = BodyMeasurement(
                    part: widget.bodyPart,
                    valueCm: selectedValueCm,
                    valueIn: selectedValueIn,
                    date: DateTime.now(),
                  );

                  // Return to previous screen with the measurement
                  Navigator.pop(context, measurement);
                },
                child: Text(
                  widget.existingMeasurement != null ? "Update" : "Add",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BodyChartPainter extends CustomPainter {
  final bool isCm;
  final BodyPart bodyPart;

  BodyChartPainter({required this.isCm, required this.bodyPart});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF2196F3)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final gridPaint =
        Paint()
          ..color = const Color(0xFFE8E8E8)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke;

    final minorGridPaint =
        Paint()
          ..color = const Color(0xFFE8E8E8).withOpacity(0.5)
          ..strokeWidth = 0.3
          ..style = PaintingStyle.stroke;

    final dottedPaint =
        Paint()
          ..color = const Color(0xFF9E9E9E)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    final bgPaint =
        Paint()
          ..color = const Color(0xFFFAFAFA)
          ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final chartPadding = EdgeInsets.only(
      left: 50,
      right: 30,
      top: 20,
      bottom: 40,
    );
    final chartRect = Rect.fromLTWH(
      chartPadding.left,
      chartPadding.top,
      size.width - chartPadding.left - chartPadding.right,
      size.height - chartPadding.top - chartPadding.bottom,
    );

    // Draw horizontal grid lines
    const horizontalGridLines = 5;
    for (int i = 0; i <= horizontalGridLines; i++) {
      final y = chartRect.top + (chartRect.height / horizontalGridLines) * i;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    // Draw vertical grid lines
    const verticalGridLines = 5;
    for (int i = 0; i <= verticalGridLines; i++) {
      final x = chartRect.left + (chartRect.width / verticalGridLines) * i;
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }

    // Draw L-shaped axis lines
    final axisPaint =
        Paint()
          ..color = const Color(0xFF767780)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    final axisDotPaint =
        Paint()
          ..color = const Color(0xFF767780)
          ..style = PaintingStyle.fill;

    // Y-axis line
    canvas.drawLine(
      Offset(chartRect.left, chartRect.top),
      Offset(chartRect.left, chartRect.bottom),
      axisPaint,
    );

    // X-axis line
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      axisPaint,
    );

    // Draw dots at the top ends of both axes
    canvas.drawCircle(Offset(chartRect.left, chartRect.top), 3, axisDotPaint);
    canvas.drawCircle(
      Offset(chartRect.right, chartRect.bottom),
      3,
      axisDotPaint,
    );

    // Draw intermediate vertical lines
    for (int i = 0; i < verticalGridLines; i++) {
      final startX = chartRect.left + (chartRect.width / verticalGridLines) * i;
      final endX =
          chartRect.left + (chartRect.width / verticalGridLines) * (i + 1);
      final segmentWidth = endX - startX;

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
      Offset(
        chartRect.left + chartRect.width * 0.05,
        chartRect.bottom - chartRect.height * 0.2,
      ),
      Offset(
        chartRect.left + chartRect.width * 0.15,
        chartRect.bottom - chartRect.height * 0.3,
      ),
      Offset(
        chartRect.left + chartRect.width * 0.25,
        chartRect.bottom - chartRect.height * 0.25,
      ),
      Offset(
        chartRect.left + chartRect.width * 0.35,
        chartRect.bottom - chartRect.height * 0.4,
      ),
      Offset(
        chartRect.left + chartRect.width * 0.45,
        chartRect.bottom - chartRect.height * 0.5,
      ),
      Offset(
        chartRect.left + chartRect.width * 0.55,
        chartRect.bottom - chartRect.height * 0.45,
      ),
      Offset(
        chartRect.left + chartRect.width * 0.65,
        chartRect.bottom - chartRect.height * 0.6,
      ),
      Offset(
        chartRect.left + chartRect.width * 0.75,
        chartRect.bottom - chartRect.height * 0.55,
      ),
      Offset(
        chartRect.left + chartRect.width * 0.85,
        chartRect.bottom - chartRect.height * 0.7,
      ),
      Offset(
        chartRect.left + chartRect.width * 0.95,
        chartRect.bottom - chartRect.height * 0.8,
      ),
    ];

    // Draw the line chart
    final path = Path();
    path.moveTo(dataPoints[0].dx, dataPoints[0].dy);
    for (int i = 1; i < dataPoints.length; i++) {
      path.lineTo(dataPoints[i].dx, dataPoints[i].dy);
    }
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint =
        Paint()
          ..color = const Color(0xFF2196F3)
          ..style = PaintingStyle.fill;

    for (final point in dataPoints) {
      canvas.drawCircle(point, 3, pointPaint);
    }

    // Draw average line (dotted)
    final averageY = chartRect.bottom - chartRect.height * 0.5;
    _drawDottedLine(
      canvas,
      Offset(chartRect.left, averageY),
      Offset(chartRect.right, averageY),
      dottedPaint,
    );

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

    // Get appropriate Y-axis labels based on body part
    List<String> yLabels;
    switch (bodyPart) {
      case BodyPart.neck:
        yLabels =
            isCm
                ? ['32', '34', '36', '38', '40']
                : ['12.6', '13.4', '14.2', '15.0', '15.7'];
        break;
      case BodyPart.chest:
        yLabels =
            isCm
                ? ['80', '90', '100', '110', '120']
                : ['31.5', '35.4', '39.4', '43.3', '47.2'];
        break;
      case BodyPart.arms:
        yLabels =
            isCm
                ? ['25', '30', '35', '40', '45']
                : ['9.8', '11.8', '13.8', '15.7', '17.7'];
        break;
      case BodyPart.waist:
        yLabels =
            isCm
                ? ['70', '80', '90', '100', '110']
                : ['27.6', '31.5', '35.4', '39.4', '43.3'];
        break;
      case BodyPart.thighs:
        yLabels =
            isCm
                ? ['45', '50', '55', '60', '65']
                : ['17.7', '19.7', '21.7', '23.6', '25.6'];
        break;
      case BodyPart.hips:
        yLabels =
            isCm
                ? ['80', '90', '100', '110', '120']
                : ['31.5', '35.4', '39.4', '43.3', '47.2'];
        break;
    }

    // Draw Y-axis labels
    for (int i = 0; i < yLabels.length; i++) {
      final y =
          chartRect.bottom - (chartRect.height / (yLabels.length - 1)) * i;
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
      labelPainter.paint(
        canvas,
        Offset(chartRect.left - labelPainter.width - 8, y - 6),
      );
    }

    // Draw X-axis labels
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
      labelPainter.paint(
        canvas,
        Offset(x - labelPainter.width / 2, chartRect.bottom + 10),
      );
    }
  }

  void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5;
    const dashSpace = 3;
    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startOffset =
          start + (end - start) * (i * (dashWidth + dashSpace) / distance);
      final endOffset =
          start +
          (end - start) *
              ((i * (dashWidth + dashSpace) + dashWidth) / distance);
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Example usage from another screen:
/*
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BodyMeasurementScreen(
          bodyPart: BodyPart.chest,
          existingMeasurement: existingChestMeasurement, // optional
        ),
      ),
    ).then((measurement) {
      if (measurement != null) {
        // Save the measurement
        print('Saved measurement: ${measurement.valueCm} cm');
      }
    });
  },
  child: Text('Measure Chest'),
),
*/
