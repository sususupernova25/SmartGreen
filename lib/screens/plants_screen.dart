import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PlantsScreen extends StatelessWidget {
  const PlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: const Text(
          'My Plants',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Filter pills
          Row(
            children: [
              _buildFilterPill('All (3)', true),
              const SizedBox(width: 8),
              _buildFilterPill('Healthy (2)', false),
              const SizedBox(width: 8),
              _buildFilterPill('Needs Care (1)', false),
            ],
          ),

          const SizedBox(height: 16),

          _buildPlantCard(
            title: 'Cherry Tomatoes',
            subtitle: 'Bed 1 · 4 plants',
            healthScore: 96,
            harvestInDays: 12,
            moisture: '64%',
            temp: '24.6°C',
            status: 'Thriving',
            statusColor: AppColors.successText,
          ),
          const SizedBox(height: 12),
          _buildPlantCard(
            title: 'Roma Tomatoes',
            subtitle: 'Bed 2 · 3 plants',
            healthScore: 81,
            harvestInDays: 24,
            moisture: '28%',
            temp: '26.1°C',
            status: 'Needs Water',
            statusColor: AppColors.warningText,
          ),
          const SizedBox(height: 12),
          _buildPlantCard(
            title: 'Sweet Basil',
            subtitle: 'Bed 3 · 6 herbs',
            healthScore: 89,
            harvestInDays: 5,
            moisture: '72%',
            temp: '24.0°C',
            status: 'Optimal',
            statusColor: AppColors.successText,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryGreen : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primaryGreen : Colors.black12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildPlantCard({
    required String title,
    required String subtitle,
    required int healthScore,
    required int harvestInDays,
    required String moisture,
    required String temp,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Health $healthScore%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Harvest in $harvestInDays days', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text('Soil: $moisture · Temp: $temp', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
            ],
          ),
        ],
      ),
    );
  }
}
