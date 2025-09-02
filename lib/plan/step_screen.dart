import 'package:flutter/material.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({Key? key}) : super(key: key);

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  String selectedPeriod = 'Weekly';
  int currentSteps = 9000;
  final int goalSteps = 10000;
  final String duration = "3 hrs";
  final String distance = "6.1 km";
  final String calories = "548 kcal";

  // Chart data
  final Map<String, List<double>> chartData = {
    'Weekly': [1500, 2300, 3500, 2100, 4200, 2800, 3200],
    'Monthly': [2500, 2800, 2900, 2400, 3100, 2600, 2900, 3200, 2700, 3800, 3500, 4000],
  };

  final Map<String, List<String>> chartLabels = {
    'Weekly': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    'Monthly': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
  };

  void _showAddStepsModal() {
    String inputSteps = '';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              "Add Steps Manually",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Steps Count",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter steps count",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (value) => inputSteps = value,
            ),
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final steps = int.tryParse(inputSteps) ?? 0;
                  setState(() {
                    currentSteps += steps;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Add Steps",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final data = chartData[selectedPeriod] ?? [];
    final labels = chartLabels[selectedPeriod] ?? [];
    
    if (data.isEmpty) return const SizedBox(height: 200);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      child: CustomPaint(
        size: const Size(double.infinity, 180),
        painter: SimpleLineChartPainter(
          data: data,
          labels: labels,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: const Text(
          "Steps",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
       
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Goal",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showAddStepsModal,
                    child: Row(
                      children: [
  const Icon(
                            Icons.add,
                            color: Color(0xFFFFA500),
                            size: 16,
                          ),
                        const SizedBox(width: 8),
                        const Text(
                          'Add manually',
                          style: TextStyle(
                            color: Color(0xFFFFA500),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Main Goal Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Goal Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Goal:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              goalSteps.toString(),
                              style: const TextStyle(

                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),

                              
                              Text(
                                'Steps',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                     
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Completed Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Completed:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currentSteps.toString(),
                              style: const TextStyle(
                                
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),

                      Text(
                                'Steps',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                        
                          ],
                        ),
                       
                        // Trophy
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _buildStatsCard('Duration', duration)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatsCard('Distance', distance)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatsCard('Calories', calories)),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Chart Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Chart Header with Dropdown
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          
                          ),
                          child: DropdownButton<String>(
                            value: selectedPeriod,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            items: ['Weekly', 'Monthly'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedPeriod = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Chart
                  _buildChart(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class SimpleLineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;

  SimpleLineChartPainter({
    required this.data,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final linePaint = Paint()
      ..color = const Color(0xFFFFA500)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0xFFFFA500).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final pointPaint = Paint()
      ..color = const Color(0xFFFFA500)
      ..style = PaintingStyle.fill;

    final axisPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    
    final chartHeight = size.height - 40; // Space for labels
    final chartWidth = size.width - 60;   // Space for Y-axis
    final stepX = chartWidth / (data.length - 1);
    final chartStartX = 50.0;
    final chartStartY = 10.0;
    final chartEndY = chartStartY + chartHeight;

    // Draw Y-axis line
    canvas.drawLine(
      Offset(chartStartX, chartStartY), 
      Offset(chartStartX, chartEndY), 
      axisPaint
    );

    // Draw X-axis line
    canvas.drawLine(
      Offset(chartStartX, chartEndY), 
      Offset(chartStartX + chartWidth, chartEndY), 
      axisPaint
    );

    // Draw horizontal grid lines and Y-axis labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= 4; i++) {
      final value = (maxValue / 4 * (4 - i)).toInt();
      final y = (chartHeight / 4) * i + chartStartY;

      // Draw grid line
      if (i > 0) { // Skip the top line
        canvas.drawLine(
          Offset(chartStartX, y),
          Offset(chartStartX + chartWidth, y),
          gridPaint,
        );
      }

      // Y-axis labels
      textPainter.text = TextSpan(
        text: '${value ~/ 1000}k',
        style: const TextStyle(
          fontSize: 10,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }

    // Draw vertical grid lines
    for (int i = 0; i < data.length; i++) {
      final x = chartStartX + i * stepX;
      if (i > 0) { // Skip the first line (Y-axis)
        canvas.drawLine(
          Offset(x, chartStartY),
          Offset(x, chartEndY),
          gridPaint,
        );
      }
    }

    // Create data path
    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = chartStartX + i * stepX;
      final normalizedValue = (data[i] - minValue) / (maxValue - minValue);
      final y = chartStartY + chartHeight * (1 - normalizedValue);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartEndY);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw data points
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
      canvas.drawCircle(
        Offset(x, y), 
        4, 
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
      );
    }

    // Complete fill path
    fillPath.lineTo(chartStartX + (data.length - 1) * stepX, chartEndY);
    fillPath.close();

    // Draw fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // X-axis labels
    for (int i = 0; i < labels.length && i < data.length; i++) {
      final x = chartStartX + i * stepX;
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          fontSize: 10,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 15),
      );
    }

    // Add "Steps" label in center of chart
   
    textPainter.layout();
    
    // Position in center of chart area
    final centerX = chartStartX + chartWidth / 2;
    final centerY = chartStartY + chartHeight / 2;
    
    // Draw background for label
    final labelPadding = 8.0;
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 30),
        width: textPainter.width + labelPadding * 2,
        height: textPainter.height + labelPadding,
      ),
      const Radius.circular(12),
    );
    
    canvas.drawRRect(
      labelRect,
      Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..style = PaintingStyle.fill,
    );
    
    canvas.drawRRect(
      labelRect,
      Paint()
        ..color = const Color(0xFFFFA500).withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        centerY - 30 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}