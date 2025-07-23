import 'package:flutter/material.dart';

class HealthConnectIntroScreen extends StatelessWidget {
  const HealthConnectIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Health Connect',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image.asset(
              'assets/icons/health_fitness.png',
              width: 108,
              height: 108,
            ),
            const SizedBox(height: 14),
            const Text(
              'Sync with Health Connect',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF222326),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Seamlessly integrate with Health Connect to automatically import your fitness and wellness data — keeping your records accurate, up-to-date, and all in one place',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF222326),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 40),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFFFFFFF),
                          foregroundColor: const Color(0xFF0C0C0C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF0C0C0C),
                            width: 1.5,
                          ),
                        ),
                        child: const Text('Not now'),
                      ),
                    ),
                    const SizedBox(width: 25),
                    SizedBox(
                      width: 140,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  const Color(0xFF0C0C0C),
                          foregroundColor: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Turn on'),
                      ),
                    ),
                  ],
                ),
              ),
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
