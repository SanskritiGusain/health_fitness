import 'package:flutter/material.dart';

// Enum for different body composition metrics
enum BodyCompositionType { bodyFat, visceralFat, muscleMass }

// Configuration for each body composition type
class BodyCompositionConfig {
  final String title;
  final String value;
  final String status;
  final Color valueColor;
  final String unit;
  final String description;
  final List<String> yAxisLabels;
  final List<double> chartDataPoints; // Y positions as percentages (0.0 to 1.0)
  final String buttonText;

  BodyCompositionConfig({
    required this.title,
    required this.value,
    required this.status,
    required this.valueColor,
    required this.unit,
    required this.description,
    required this.yAxisLabels,
    required this.chartDataPoints,
    required this.buttonText,
  });
}

class BodyCompositionScreen extends StatefulWidget {
  final BodyCompositionType type;

  const BodyCompositionScreen({super.key, required this.type});

  @override
  State<BodyCompositionScreen> createState() => _BodyCompositionScreenState();
}

class _BodyCompositionScreenState extends State<BodyCompositionScreen> {
  String selectedPeriod = 'Monthly';
  final List<String> periods = ['Weekly', 'Monthly', 'Yearly'];

  // Configuration for different body composition types
  final Map<BodyCompositionType, BodyCompositionConfig> configs = {
    BodyCompositionType.bodyFat: BodyCompositionConfig(
      title: 'Body fat',
      value: '18.5',
      status: 'Low',
      valueColor: const Color(0xFFE74C3C),
      unit: '%',
      description:
          'Body Fat Percentage (BFP) is the proportion of fat in your body compared to everything else (muscles, bones, water, organs). A healthy body fat level is important for energy storage, insulation, and overall health.',
      yAxisLabels: [
        '17.5%',
        '18.0%',
        '18.5%',
        '19.0%',
        '19.5%',
        '20.0%',
        '20.5%',
      ],
      chartDataPoints: [0.6, 0.4], // Start high, end lower
      buttonText: 'Ask Health AI',
    ),
    BodyCompositionType.visceralFat: BodyCompositionConfig(
      title: 'Visceral fat',
      value: '18.2',

      status: 'Normal',
      valueColor: const Color(0xFF4CAF50),
      unit: '%',
      description:
          'Visceral fat is the fat that surrounds your internal organs. Unlike subcutaneous fat, visceral fat can affect organ function and is linked to various health risks when levels are too high.',
      yAxisLabels: ['40%', '41%', '42%', '43%', '44%', '45%', '46%'],
      chartDataPoints: [0.3, 0.5], // Start lower, increase slightly
      buttonText: 'Ask Health AI',
    ),
    BodyCompositionType.muscleMass: BodyCompositionConfig(
      title: 'Muscle mass',
      value: '42.8',
      status: 'Good',
      valueColor: const Color(0xFF2196F3),
      unit: '%',
      description:
          'Muscle mass represents the total weight of muscle tissue in your body. Maintaining adequate muscle mass is crucial for metabolism, strength, bone health, and overall physical function.',
      yAxisLabels: ['40%', '41%', '42%', '43%', '44%', '45%', '46%'],
      chartDataPoints: [0.2, 0.7], // Start low, increase significantly
      buttonText: 'Ask Health AI',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final config = configs[widget.type]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB),
        shadowColor: Colors.transparent,
        toolbarHeight: 80,
        title: Text(
          config.title,
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
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Horizontal divider under AppBar
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 30),

          // Value Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(38),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '${config.value}${config.unit}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: config.valueColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  config.status,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF767780),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Analytics Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    Text(
                      'Track your ${config.title.toLowerCase()} changes\nover time',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9EA3A9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  initialValue: selectedPeriod,
                  onSelected: (value) {
                    setState(() {
                      selectedPeriod = value;
                    });
                  },
                  itemBuilder:
                      (context) =>
                          periods.map((period) {
                            return PopupMenuItem<String>(
                              value: period,
                              child: Text(period),
                            );
                          }).toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFDDE5F0)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedPeriod,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF222326),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: Color(0xFF767780),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Chart Container
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 340,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomPaint(
              painter: BodyCompositionChartPainter(
                yAxisLabels: config.yAxisLabels,
                chartDataPoints: config.chartDataPoints,
              ),
              size: const Size(double.infinity, 280),
            ),
          ),
          const SizedBox(height: 24),

          // Information Card with button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  config.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9EA3A9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 46,
        child: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Add Ask Luna API here
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

class BodyCompositionChartPainter extends CustomPainter {
  final List<String> yAxisLabels;
  final List<double> chartDataPoints;

  BodyCompositionChartPainter({
    required this.yAxisLabels,
    required this.chartDataPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padding = EdgeInsets.only(left: 50, right: 40, top: 30, bottom: 50);
    final chartRect = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.left - padding.right,
      size.height - padding.top - padding.bottom,
    );

    final bgPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    _drawGridLines(canvas, chartRect);
    _drawChartLine(canvas, chartRect);
    _drawLabels(canvas, chartRect);
    _drawAxisLinesWithDots(canvas, chartRect);
  }

  void _drawGridLines(Canvas canvas, Rect chartRect) {
    final gridPaint =
        Paint()
          ..color = const Color(0xFFF0F0F0)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines
    for (int i = 0; i <= 6; i++) {
      final y = chartRect.top + (chartRect.height / 6) * i;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    // Draw vertical grid lines
    for (int i = 0; i <= 4; i++) {
      final x = chartRect.left + (chartRect.width / 4) * i;
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }
  }

  void _drawChartLine(Canvas canvas, Rect chartRect) {
    final dataPoints = [
      Offset(
        chartRect.left + chartRect.width * 0.1,
        chartRect.bottom - chartRect.height * chartDataPoints[0],
      ),
      Offset(
        chartRect.left + chartRect.width * 0.9,
        chartRect.bottom - chartRect.height * chartDataPoints[1],
      ),
    ];

    final linePaint =
        Paint()
          ..color = const Color(0xFF2196F3)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
    canvas.drawLine(dataPoints[0], dataPoints[1], linePaint);

    final pointPaint =
        Paint()
          ..color = const Color(0xFF2196F3)
          ..style = PaintingStyle.fill;
    for (final point in dataPoints) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  void _drawLabels(Canvas canvas, Rect chartRect) {
    // Draw Y-axis labels
    for (int i = 0; i < yAxisLabels.length; i++) {
      final y =
          chartRect.bottom - (chartRect.height / (yAxisLabels.length - 1)) * i;
      final labelPainter = TextPainter(
        text: TextSpan(
          text: yAxisLabels[i],
          style: const TextStyle(
            color: Color(0xFF9EA3A9),
            fontSize: 11,
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
    final xLabels = ['04 Mar', '04 Apr'];
    final xPositions = [0.1, 0.9];
    for (int i = 0; i < xLabels.length; i++) {
      final x = chartRect.left + chartRect.width * xPositions[i];
      final labelPainter = TextPainter(
        text: TextSpan(
          text: xLabels[i],
          style: const TextStyle(
            color: Color(0xFF9EA3A9),
            fontSize: 11,
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

  void _drawAxisLinesWithDots(Canvas canvas, Rect chartRect) {
    final axisPaint =
        Paint()
          ..color = const Color(0xFF767780)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    final dotPaint =
        Paint()
          ..color = const Color(0xFF767780)
          ..style = PaintingStyle.fill;

    final yAxisX = chartRect.left;
    final xAxisY = chartRect.bottom;

    // Draw extended L-shaped axes
    canvas.drawLine(
      Offset(yAxisX, chartRect.top),
      Offset(yAxisX, xAxisY),
      axisPaint,
    );
    canvas.drawLine(
      Offset(yAxisX, xAxisY),
      Offset(chartRect.right + 8, xAxisY),
      axisPaint,
    );

    // Outer dots
    canvas.drawCircle(Offset(yAxisX, chartRect.top), 3, dotPaint); // Top of Y
    canvas.drawCircle(
      Offset(chartRect.right + 8, xAxisY),
      3,
      dotPaint,
    ); // End of X
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}