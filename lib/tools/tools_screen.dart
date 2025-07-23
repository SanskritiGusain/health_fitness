import 'package:flutter/material.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        title: const Text(
          'Tools',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222326),
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Calculator',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101010),
              ),
            ),
            const SizedBox(height: 12),
          Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    ToolCard(
      title: 'BMI',
      iconPath: 'assets/icons/bmi.png',
      onTap: () => Navigator.pushNamed(context, '/bmi'),
    ),
    ToolCard(
      title: 'BMR',
      iconPath: 'assets/icons/bmr.png',
      onTap: () => Navigator.pushNamed(context, '/bmr'),
    ),
    ToolCard(
      title: 'Body fat',
      iconPath: 'assets/icons/bodyfat.png',
      onTap: () => Navigator.pushNamed(context, '/bodyfat'),
    ),
    ToolCard(
      title: 'TDEE',
      iconPath: 'assets/icons/tdee.png',
      onTap: () => Navigator.pushNamed(context, '/tdee'),
    ),
  ],
),

            const SizedBox(height: 32),
            const Text(
              'Sync',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 12),
           Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    ToolCard(
      title: 'Health Connect',
      iconPath: 'assets/icons/health_fitness.png',
      isVertical: true,
      iconSize: 46,
   onTap: () {
  try {
    Navigator.pushNamed(context, '/health-connect-toggle');

  } catch (e, stack) {
    print('Navigation error: $e\n$stack');
  }
},

    ),
    ToolCard(
      title: 'Wearable Devices',
      iconPath: 'assets/icons/twemoji_watch.png',
      isVertical: true,
      iconSize: 40,
      onTap: () => Navigator.pushNamed(context, '/wearables'),
    ),
  ],
),

          ],
        ),
      ),
bottomNavigationBar: BottomNavigationBar(
  currentIndex: 4,
  selectedItemColor: Colors.black,
  unselectedItemColor: Colors.grey,
  type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.white,
  items: [
 BottomNavigationBarItem(
  icon: Image.asset(
    'assets/icons/ant-design_home-outlined.png', // <-- Your image path here
    width: 24,
    height: 24,
  ),
  label: 'Home',
),

    BottomNavigationBarItem(
    icon: Image.asset(
                    'assets/icons/plan.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'My Plan',
    ),
    BottomNavigationBarItem(
    icon: Image.asset(
                'assets/icons/tabler_message.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'Chat',
    ),
    BottomNavigationBarItem(
    icon:Image.asset(
                  'assets/icons/heroicons_trophy.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'Merits',
    ),
    BottomNavigationBarItem(
      icon:Image.asset(
                   'assets/icons/hugeicons_tools.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'Tools',
    ),
  ],
)

    );
  }
}

class ToolCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isVertical;
  final double iconSize;
  final VoidCallback? onTap; // <-- add this

  const ToolCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.isVertical = false,
    this.iconSize = 30,
    this.onTap, // <-- and this
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // <-- add this wrapper
      onTap: onTap,
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 44) / 2,
        height: isVertical ? 120 : 90,
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: isVertical
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconPath,
                      width: iconSize,
                      height: iconSize,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D0D0D),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Image.asset(
                        iconPath,
                        width: iconSize,
                        height: iconSize,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D0D0D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
