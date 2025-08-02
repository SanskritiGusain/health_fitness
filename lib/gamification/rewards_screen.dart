import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(''),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPointsCard(),

            const SizedBox(height: 24),
            const Text(
              "Routine Rewards",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            _buildRewardCard(
              title: "Sweat Champ",
              subtitle: "You crushed your workout today!",
              coins: 150,
              isHighlighted: true,
            ),
            _buildRewardCard(
              title: "Fuel Master",
              subtitle: "Your body says thank you!",
              coins: 200,
            ),
            _buildRewardCard(
              title: "Dream Achiever",
              subtitle: "You crushed your workout today!",
              coins: 200,
            ),

            const SizedBox(height: 24),
            const Text(
              "Bonus Reward",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildRewardCard(
              title: "Step Master",
              subtitle: "Good Job! Walked 10,000 steps",
              coins: 150,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Text("Earned: +600"),
              Spacer(),
              Text("Goal: 1500"),
            ],
          ),
          const SizedBox(height: 12),
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
                widthFactor: 0.4,
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
                  'assets/icons/points_icon.png',
                  height: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "* Every point takes you closer to the next level — stay consistent!",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard({
    required String title,
    required String subtitle,
    required int coins,
    bool isHighlighted = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(
          color: isHighlighted ? Colors.blue : Colors.grey.shade300,
          width: isHighlighted ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Title + Icon + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      'assets/icons/start_game_button_r.png',
                      height: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Text(
                "+$coins",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              Image.asset(
                'assets/icons/pts_icon.png',
                height: 18,
              ),
            ],
          )
        ],
      ),
    );
  }
}
