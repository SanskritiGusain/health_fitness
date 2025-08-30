import 'package:flutter/material.dart';
import '../utils/circlular progressbar.dart';
class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text("Levels"),
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressCard(),
            const SizedBox(height: 24),
            const Text(
              "Levels",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildLevelGrid(),
          ],
        ),
      ),
    );
  }


  Widget _buildProgressCard({
    int currentLevel = 7,
    int currentXP = 2000,
    int goalXP = 3000,
  }) {
    double progress = currentXP / goalXP;

    return Container(
    //  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                          const WidgetSpan(
                            child: SizedBox(width: 6),
                          ), // <-- space
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


  Widget _buildLevelGrid() {
    final levels = [
      {
        "level": "1",
        "xp": "XP: 3000/3000",
        "status": "Completed",
       "badge": "assets/new_icons/level_icons.png"
      },
      {
        "level": "2",
        "xp": "XP: 3000/3000",
        "status": "Completed",
       "badge": "assets/new_icons/level_icons.png"
      },
      {
        "level": "3",
        "xp": "XP: 3000/3000",
        "status": "Completed",
      "badge": "assets/new_icons/level_icons.png"
      },
      {
        "level": "4",
      "xp": "XP: 3000/3000",
        "status": "Completed",
       "badge": "assets/new_icons/level_icons.png"
      },
      {
        "level": "5",
        "xp": "XP: 3000/3000",
        "status": "Completed",
      "badge": "assets/new_icons/level_icons.png"
      },
      {
        "level": "6",
         "xp": "XP: 3000/3000",
        "status": "Completed",
      "badge": "assets/new_icons/level_icons.png"
      },
      {
        "level": "7",
     "xp": "XP: 3000/3000",
        "status": "Started",
        "badge": "assets/new_icons/level_icons.png"
      },
      {
        "level": "8",
       "xp": "XP: 3000/3000",
        "status": "Not Started",
     "badge": "assets/new_icons/level_icons.png"
      },
      {
        "level": "9",
        "xp": "XP: 3000/3000",
        "status": "Not Started",
        "badge": "assets/new_icons/level_icons.png"
      },
    ];

  return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cards per row
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // DO NOT set childAspectRatio to let height depend on content
      ),
      itemBuilder: (context, index) {
        final level = levels[index];
        final status = level['status'] as String;

        Color textColor;
        if (status == "Completed") {
          textColor = const Color.fromARGB(255, 128, 115, 7);
        } else if (status == "Started") {
          textColor = Colors.green;
        } else {
          textColor = Colors.grey;
        }

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // shrink height to content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(level['badge']!, height: 40),
              const SizedBox(height: 6),
              Text(
                "Level ${level['level']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(level['xp']!, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                level['status']!,
                style: TextStyle(fontSize: 12, color: textColor),
              ),
            ],
          ),
        );
      },
    );


  }
}
