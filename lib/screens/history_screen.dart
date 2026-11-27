import 'package:flutter/material.dart';
import '../models/greenhouse_models.dart';
import '../services/greenhouse_service.dart';
import '../theme/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final GreenhouseService _service = GreenhouseService();
  bool _isWeekView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: const Text(
          'Telemetry History',
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
          // Period toggle (Day / Week)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildPeriodPill('Day', !_isWeekView, () => setState(() => _isWeekView = false)),
              const SizedBox(width: 8),
              _buildPeriodPill('Week', _isWeekView, () => setState(() => _isWeekView = true)),
            ],
          ),

          const SizedBox(height: 16),

          StreamBuilder<List<HistoryEntry>>(
            stream: _service.getHistoryStream(),
            builder: (context, snapshot) {
              final entries = snapshot.data ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '7-Day Temperature Log (Includes Heatwave Spike)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ...entries.map((entry) {
                    final bool isSpike = entry.temperature > 35.0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSpike ? AppColors.criticalBackground : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSpike ? AppColors.criticalText.withOpacity(0.3) : Colors.black12,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isSpike ? Icons.warning_amber : Icons.thermostat,
                                color: isSpike ? AppColors.criticalText : AppColors.primaryGreen,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _formatDate(entry.timestamp),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSpike ? AppColors.criticalText : AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${entry.temperature.toStringAsFixed(1)} °C',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isSpike ? AppColors.criticalText : AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Soil: ${entry.soilMoisture.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[dt.weekday - 1]} ${dt.day}/${dt.month}';
  }
}
