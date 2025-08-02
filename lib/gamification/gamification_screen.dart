import 'package:flutter/material.dart';
import 'package:test_app/shift/checkout_screen.dart'; 
import 'package:test_app/chat/chat_screen.dart'; 
import 'package:test_app/tools/tools_screen.dart'; 
import 'package:test_app/plan/fitness_wellness.dart';
import 'package:test_app/utils/custom_bottom_nav.dart'; 

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(context),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Achievements',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildTrophyBanner(),
            const SizedBox(height: 10),
            _buildDateDropdown(),
            const SizedBox(height: 20),
            _buildLevelProgress(),
            const SizedBox(height: 20),
            _buildMilestoneBoard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrophyBanner() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Image.asset('assets/images/trofy.jpg', height: 100),
    );
  }

  Widget _buildDateDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.arrow_back_ios, size: 16),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: 'Today',
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(value: 'Today', child: Text('Today')),
            DropdownMenuItem(value: 'This Week', child: Text('This Week')),
            DropdownMenuItem(value: 'This Month', child: Text('This Month')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }

  Widget _buildLevelProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Level Progress', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset('assets/icons/level_icon.png', width: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Level 7'),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: 3240 / 4000,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('3,240 / 4,000 XP'),
                    ),
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
          const Text('Your Milestone Board', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildMilestoneCard(
            imagePath: 'assets/icons/points_icon.png',
            title: 'Points',
            subtitle: 'Today: +600\nGoal: 1200',
            buttonText: 'View Points',
          ),
          const SizedBox(height: 12),
          _buildMilestoneCard(
            imagePath: 'assets/icons/level_icon.png',
            title: 'Levels',
            subtitle: 'Completed: 6\nTotal: 12',
            buttonText: 'View Levels',
          ),
          const SizedBox(height: 12),
          _buildMilestoneCard(
            imagePath: 'assets/icons/streak.png',
            title: 'Streak',
            subtitle: 'Current: 6 days\nBest: 12 days',
            buttonText: 'View Streak',
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String buttonText,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
               
  Row(
        children: [
Container(
             padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 158, 226, 220),
        border: Border.all(width:1.5,color: const Color.fromARGB(255, 26, 25, 25)),
        borderRadius: BorderRadius.circular(12),
      ),
  child: Image.asset(
    imagePath,
    width: 30,
  ),
),
          const SizedBox(width: 12),
                Text(subtitle, style: const TextStyle(color: Color.fromARGB(136, 5, 145, 96),fontSize: 12,fontWeight: FontWeight.w500)),
        ] 
  )
            ],
       ),

          const SizedBox(width: 12),
        
      
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return CustomBottomNav(
      currentIndex: 3,
      onTap: (index) {
        if (index == 3) return;

        switch (index) {
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessWellnessScreen()));
            break;
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => HealthDashboardScreen()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWelcomeScreen()));
            break;
          case 4:
            Navigator.push(context, MaterialPageRoute(builder: (context) => ToolsScreen()));
            break;
        }
      },
    );
  }
}