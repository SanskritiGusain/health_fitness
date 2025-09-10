import 'package:flutter/material.dart';
import 'package:test_app/chat/chat_start.dart';

class BodyFatScreen extends StatefulWidget {
  const BodyFatScreen({super.key});

  @override
  State<BodyFatScreen> createState() => _BodyFatScreenState();
}

class _BodyFatScreenState extends State<BodyFatScreen> {
  String selectedPeriod = 'Monthly';
  final List<String> periods = ['Weekly', 'Monthly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB),
        shadowColor: Colors.transparent,
        toolbarHeight: 80,
        title: const Text(
          'Body Fat',
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
      ),
      body: Column(
        children: [
          // Horizontal divider under AppBar
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          
          // Body Fat Percentage Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
width:double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '18.5%',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD93538),
                  ),
                ),
                const SizedBox(height: 0),
                const Text(
                  'Low',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF767780),
                  ),
                ),
                const SizedBox(height: 10),
               
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Analytics Header
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
                    SizedBox(height: 4),
                    Text(
                      'Track your body fat percentage changes\nover time',
                      style: TextStyle(
                        fontSize: 10,
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
                  itemBuilder: (context) => periods.map((period) {
                    return PopupMenuItem<String>(
                      value: period,
                      child: Text(period),
                    );
                  }).toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          
          const SizedBox(height: 16),
          
          // Chart Container
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
              painter: BodyFatChartPainter(),
              size: const Size(double.infinity, 280),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Information Card
         
          
           Padding(padding:EdgeInsets.symmetric(horizontal:14),
            child: const Text(
              'Body Fat Percentage (BFP) is the proportion of fat in your body compared to everything else (muscles, bones, water, organs). A healthy body fat level is important for energy storage, insulation, and overall health.',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9EA3A9),
                height: 1.4,
              ),
            ),)

          
         
        ],
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

class BodyFatChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const padding = EdgeInsets.only(left: 50, right: 40, top: 30, bottom: 50);
    final chartRect = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.left - padding.right,
      size.height - padding.top - padding.bottom,
    );

    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    _drawGridLines(canvas, chartRect);
    _drawChartLine(canvas, chartRect);
    _drawLabels(canvas, chartRect);
    _drawAxisLinesWithDots(canvas, chartRect);
  }

  void _drawGridLines(Canvas canvas, Rect chartRect) {
    final gridPaint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 6; i++) {
      final y = chartRect.top + (chartRect.height / 6) * i;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

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
      Offset(chartRect.left + chartRect.width * 0.1, chartRect.bottom - chartRect.height * 0.6),
      Offset(chartRect.left + chartRect.width * 0.9, chartRect.bottom - chartRect.height * 0.4),
    ];

    final linePaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(dataPoints[0], dataPoints[1], linePaint);

    final pointPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;

    for (final point in dataPoints) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  void _drawLabels(Canvas canvas, Rect chartRect) {
    final yLabels = ['17.5%', '18.0%', '18.5%', '19.0%', '19.5%', '20.0%', '20.5%'];
    for (int i = 0; i < yLabels.length; i++) {
      final y = chartRect.bottom - (chartRect.height / (yLabels.length - 1)) * i;
      final labelPainter = TextPainter(
        text: TextSpan(
          text: yLabels[i],
          style: const TextStyle(
            color: Color(0xFF9EA3A9),
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(chartRect.left - labelPainter.width - 8, y - 6));
    }

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
      labelPainter.paint(canvas, Offset(x - labelPainter.width / 2, chartRect.bottom + 10));
    }
  }

  void _drawAxisLinesWithDots(Canvas canvas, Rect chartRect) {
    final axisPaint = Paint()
      ..color = const Color(0xFF767780)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF767780)
      ..style = PaintingStyle.fill;

    final yAxisX = chartRect.left ;
    final xAxisY = chartRect.bottom ;

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
    canvas.drawCircle(Offset(yAxisX, chartRect.top), 3, dotPaint);          // Top of Y
    canvas.drawCircle(Offset(chartRect.right + 8, xAxisY), 3, dotPaint);    // End of X
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}