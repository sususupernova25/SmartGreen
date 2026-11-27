import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});

  @override
  State<PlantsScreen> createState() => _PlantsScreenState();
}

class _PlantsScreenState extends State<PlantsScreen> {
  String _selectedFilter = 'all'; // 'all', 'healthy', 'needs_care'

  final List<Map<String, dynamic>> _plants = [
    {
      'title': 'Cherry Tomatoes',
      'subtitle': 'Bed 1 · 4 plants',
      'healthScore': 96,
      'harvestInDays': 12,
      'moisture': '64%',
      'temp': '24.6°C',
      'status': 'Thriving',
      'statusColor': AppColors.successText,
      'isHealthy': true,
    },
    {
      'title': 'Roma Tomatoes',
      'subtitle': 'Bed 2 · 3 plants',
      'healthScore': 81,
      'harvestInDays': 24,
      'moisture': '28%',
      'temp': '26.1°C',
      'status': 'Needs Water',
      'statusColor': AppColors.warningText,
      'isHealthy': false,
    },
    {
      'title': 'Sweet Basil',
      'subtitle': 'Bed 3 · 6 herbs',
      'healthScore': 89,
      'harvestInDays': 5,
      'moisture': '72%',
      'temp': '24.0°C',
      'status': 'Optimal',
      'statusColor': AppColors.successText,
      'isHealthy': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPlants = _plants.where((p) {
      if (_selectedFilter == 'healthy') return p['isHealthy'] == true;
      if (_selectedFilter == 'needs_care') return p['isHealthy'] == false;
      return true;
    }).toList();

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
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGreen, size: 26),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bed configuration: 3 active beds connected to telemetry'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Filter pills (interactive)
          Row(
            children: [
              _buildFilterPill('All (3)', 'all'),
              const SizedBox(width: 8),
              _buildFilterPill('Healthy (2)', 'healthy'),
              const SizedBox(width: 8),
              _buildFilterPill('Needs Care (1)', 'needs_care'),
            ],
          ),

          const SizedBox(height: 16),

          ...filteredPlants.map((plant) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPlantCard(
                title: plant['title'],
                subtitle: plant['subtitle'],
                healthScore: plant['healthScore'],
                harvestInDays: plant['harvestInDays'],
                moisture: plant['moisture'],
                temp: plant['temp'],
                status: plant['status'],
                statusColor: plant['statusColor'],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String label, String filterKey) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filterKey;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primaryGreen : Colors.black12),
          boxShadow: isSelected
              ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
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
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title telemetry: Moisture $moisture, Temp $temp'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
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
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMiniStat('Health', '$healthScore%', Icons.favorite, Colors.redAccent),
                _buildMiniStat('Harvest', '$harvestInDays days', Icons.calendar_today, AppColors.amberAccent),
                _buildMiniStat('Moisture', moisture, Icons.water_drop, Colors.blue),
                _buildMiniStat('Temp', temp, Icons.thermostat, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
