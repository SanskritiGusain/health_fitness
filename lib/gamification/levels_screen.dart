import 'package:flutter/material.dart';

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
        title: const Text(""),
        actions: [
          Row(
            children: const [
              Text("Today", style: TextStyle(color: Colors.black)),
              Icon(Icons.keyboard_arrow_down, color: Colors.black),
              SizedBox(width: 16),
            ],
          )
        ],
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

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Level Progress", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text("Level 7", style: TextStyle(fontWeight: FontWeight.w600)),
              Spacer(),
              Text("3,340 / 4,000 XP", style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.835,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color(0xFF2F80ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Positioned(
                left: 4,
                top: -18,
                child: Image.asset(
                  'assets/icons/points_icon.png', // 👈 Use your own image
                  height: 32,
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
        "status": "In Progress",
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
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final level = levels[index];
        final status = level['status'] as String;

        Color textColor;
        if (status == "Completed") {
          textColor = Colors.green;
        } else if (status == "In Progress") {
          textColor = Colors.orange;
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Level ${level['level']}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                level['xp']!,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 6),
              Image.asset(
                level['badge']!,
                height: 40,
              ),
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
