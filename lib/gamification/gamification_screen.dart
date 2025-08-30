import 'package:flutter/material.dart';

import 'package:test_app/gamification/levels_screen.dart';
import 'package:test_app/gamification/rewards_screen.dart';


import '../utils/circlular progressbar.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen> {
  DateTime selectedDate = DateTime.now();

  String get displayDateText {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (selected == today) {
      return "Today";
    } else if (selected == today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    } else if (selected == today.add(const Duration(days: 1))) {
      return "Tomorrow";
    } else {
      return "${selected.day.toString().padLeft(2, '0')} ${_getMonthName(selected.month)}";
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _navigateToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _navigateToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: _buildBottomNavBar(context),
   appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: const Text(
          'Achievements',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
       // optional: centers the title
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
      
            const SizedBox(height: 20),
       
            _buildLevelProgress(),
            const SizedBox(height: 30),
            _buildMilestoneBoard(),
          ],
        ),
      ),
    );
  }

  

  
 Widget _buildLevelProgress({
    int currentLevel = 7,
    int currentXP = 2000,
    int goalXP = 3000,
  }) {
    double progress = currentXP / goalXP;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Level Progress',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Circular Progress Indicator
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
 
                    // Progress circle
                         RoundedCircularProgress(
                      progress: progress,
                      remainingText: 'Level $currentLevel',
                      strokeWidth: 11,
                      progressColor: Colors.orange,
                      backgroundColor: Colors.grey.shade300,
                    ),
                    // Level text in center
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          
"assets/icons/level_icon.png",
height: 24,
width: 24,
                        ),
                        Text(
                          'Level: $currentLevel',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 32),

              // XP Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Goal: ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '${goalXP.toString()} XP',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                             
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  RichText(
  text: TextSpan(
    style: const TextStyle(fontSize: 16),
    children: [
      TextSpan(
        text: 'Earned:',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
      const WidgetSpan(child: SizedBox(width: 6)), // <-- space
      TextSpan(
        text: '${currentXP.toString()} XP',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
),

                    const SizedBox(height: 8),
                    // Progress bar (optional - can remove if you only want circular)
                    
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneBoard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Milestone Board',
            style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),
          ),
          const SizedBox(height: 16),
          _buildMilestoneCard(
            imagePath: 'assets/icons/points_icon.png',
            title: 'Points',
            tracking:'Today: +600p',
            goal: 'Goal: 1200',
            buttonText: 'View Points',
            destination: GamificationScreen(),
          ),
          const SizedBox(height: 12),
          _buildMilestoneCard(
            imagePath: 'assets/icons/level_icon.png',
            title: 'Levels',
            tracking: 'Completed: 6',
            goal:"Total: 12",
            buttonText: 'View Levels',
            destination: LevelsScreen(),
          ),
          const SizedBox(height: 12),
          _buildMilestoneCard(
            imagePath: 'assets/icons/streak.png',
            title: 'Streak',
          
             tracking: 'Current: 6 days',
            goal: "Best: 12 days",
            buttonText: 'View Streak',
              destination: RewardsScreen(),
          ),
        ],
      ),
    );
  }
Widget _buildMilestoneCard({
    required String imagePath,
    required String title,
    required String tracking,
    required String goal,
    required String buttonText,
    required Widget destination, // new parameter
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(imagePath, width: 30, height: 30),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tracking,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  goal,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }



  // Widget _buildBottomNavBar(BuildContext context) {
  //   return CustomBottomNav(
  //     currentIndex: 3,
  //     onTap: (index) {
  //       if (index == 3) return;

  //       switch (index) {
  //         case 0:
  //           // Navigator.push(
  //           //   context,
  //           //   MaterialPageRoute(builder: (context) => FitnessWellnessScreen()),
  //           // );
  //           break;
  //         case 1:
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => HealthDashboardScreen()),
  //           );
  //           break;
  //         case 2:
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => ChatWelcomeScreen()),
  //           );
  //           break;
  //         case 4:
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => ToolsScreen()),
  //           );
  //           break;
  //       }
  //     },
  //   );
  // }
}
