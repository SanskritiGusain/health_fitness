import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/ant-design_home-outlined.png',
            width: 24,
            height: 24,
            color: currentIndex == 0 ? Colors.black : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/plan.png',
            width: 24,
            height: 24,
            color: currentIndex == 1 ? Colors.black : Colors.grey,
          ),
          label: 'My Plan',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/tabler_message.png',
            width: 24,
            height: 24,
            color: currentIndex == 2 ? Colors.black : Colors.grey,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/heroicons_trophy.png',
            width: 24,
            height: 24,
            color: currentIndex == 3 ? Colors.black : Colors.grey,
          ),
          label: 'Merits',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/tools_icon.png',
            width: 24,
            height: 24,
            color: currentIndex == 4 ? Colors.black : Colors.grey,
          ),
          label: 'Tools',
        ),
      ],
    );
  }
}