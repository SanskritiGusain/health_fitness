import 'package:flutter/material.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(),
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
      child: Image.asset('assets/images/trofy.jpg', height: 100), // Banner image
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
              Image.asset('assets/images/trofy.jpg', width: 40),
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
            imagePath: 'assets/images/trofy.jpg',
            title: 'Points',
            subtitle: 'Today: +600\nGoal: 1200',
            buttonText: 'View Points',
          ),
          const SizedBox(height: 12),
          _buildMilestoneCard(
            imagePath: 'assets/images/trofy.jpg',
            title: 'Levels',
            subtitle: 'Completed: 6\nTotal: 12',
            buttonText: 'View Levels',
          ),
          const SizedBox(height: 12),
          _buildMilestoneCard(
            imagePath: 'aassets/images/trofy.jpg',
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
          Image.asset(imagePath, width: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(buttonText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      currentIndex: 3,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'My Plan'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Merits'),
        BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
      ],
    );
  }
}
