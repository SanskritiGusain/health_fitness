import 'package:flutter/material.dart';

class BodyWeightScreen extends StatefulWidget {
  const BodyWeightScreen({super.key});

  @override
  State<BodyWeightScreen> createState() => _BodyWeightScreenState();
}

class _BodyWeightScreenState extends State<BodyWeightScreen> {
  bool isKg = true; // true = kg, false = lbs
  int selectedWeightKg = 55;
  int selectedWeightLbs = 121;
  String selectedTimeFrame = 'Weekly'; // Add this for dropdown

  final List<int> kgValues = List.generate(171, (index) => index + 30); // 30–200
  final List<int> lbsValues = List.generate(271, (index) => index + 66); // 66–336

  late FixedExtentScrollController _controllerKg;
  late FixedExtentScrollController _controllerLbs;

  @override
  void initState() {
    super.initState();
    _controllerKg = FixedExtentScrollController(initialItem: selectedWeightKg - 30);
    _controllerLbs = FixedExtentScrollController(initialItem: selectedWeightLbs - 66);
  }

  @override
  void dispose() {
    _controllerKg.dispose();
    _controllerLbs.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    setState(() {
      isKg = !isKg;
      if (isKg) {
        selectedWeightKg = (selectedWeightLbs * 0.453592).round();
        selectedWeightKg = selectedWeightKg.clamp(30, 200);
        _controllerKg.animateToItem(
          selectedWeightKg - 30,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        selectedWeightLbs = (selectedWeightKg * 2.20462).round();
        selectedWeightLbs = selectedWeightLbs.clamp(66, 336);
        _controllerLbs.animateToItem(
          selectedWeightLbs - 66,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = isKg ? _controllerKg : _controllerLbs;
    final values = isKg ? kgValues : lbsValues;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB),
        shadowColor: Colors.transparent,
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
          const SizedBox(height: 20),

          // Toggle switch
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'kg',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isKg ? const Color(0xFF0C0C0C) : const Color(0xFF9EA3A9),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _toggleUnit,
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
                    alignment: isKg ? Alignment.centerLeft : Alignment.centerRight,
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
                'lbs',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: !isKg ? const Color(0xFF0C0C0C) : const Color(0xFF9EA3A9),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 25),
          
          // Selected weight display
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: isKg ? '$selectedWeightKg' : '$selectedWeightLbs',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222326),
                  ),
                ),
                TextSpan(
                  text: isKg ? ' kg' : ' lbs',
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
                        controller: controller,
                        itemExtent: 25,
                        diameterRatio: 100,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            if (isKg) {
                              selectedWeightKg = kgValues[index];
                            } else {
                              selectedWeightLbs = lbsValues[index];
                            }
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: values.length,
                          builder: (context, index) {
                            final val = values[index];
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
          
          // Analytics Header with custom dropdown
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
                      'Track weight progress with analytics',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9EA3A9),
                      ),
                    ),
                    Text(
                      '-driven graphs',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9EA3A9),
                      ),
                    ),
                  ],
                ),
                // Custom styled dropdown
              StyledDropdownButton(
                  value: selectedTimeFrame,
                  items: const ['Weekly', 'Monthly', 'Quarterly', 'Yearly'],
                  buttonColor: const Color(0xFFF8FBFB),
                  
                  textColor: Color(0xFF222326),
        
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedTimeFrame = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 5,width: 15,),
          
          // Chart Card
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
                painter: WeightChartPainter(isKg: isKg, timeFrame: selectedTimeFrame),
                size: const Size(double.infinity, 200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Styled Dropdown Button
class StyledDropdownButton extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color? buttonColor;
  final Color? textColor;

  const StyledDropdownButton({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<StyledDropdownButton> createState() => _StyledDropdownButtonState();
}

class _StyledDropdownButtonState extends State<StyledDropdownButton> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4.0),
          child: Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items.map((item) {
                  return _buildDropdownItem(item);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String item) {
    final isSelected = item == widget.value;
    
    return InkWell(
      onTap: () {
        widget.onChanged(item);
        _closeDropdown();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F5F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          item,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: const Color(0xFF222326),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.buttonColor ?? const Color(0xFFF8FBFB),
            borderRadius: BorderRadius.circular(6),
          
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor ?? Color(0xFF222326),
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20,
                color: widget.textColor ?? Color(0xFF808080),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Your existing WeightChartPainter class remains the same
class WeightChartPainter extends CustomPainter {
  final bool isKg;
  final String timeFrame;
  
  WeightChartPainter({required this.isKg, required this.timeFrame});

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
    final yLabels = isKg ? ['52.0', '53.0', '54.0', '55.0', '56.0'] : ['114', '117', '119', '121', '123'];
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

    // Draw X-axis labels based on timeFrame
    final xLabels = timeFrame == 'Weekly' 
        ? ['Jan', 'Mar', 'May', 'Jul', 'Sep']
        : timeFrame == 'Monthly'
            ? ['Q1', 'Q2', 'Q3', 'Q4', 'Q5']
            : timeFrame == 'Quarterly'
                ? ['2023', '2024', '2025', '2026', '2027']
                : ['1Y', '2Y', '3Y', '4Y', '5Y'];
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