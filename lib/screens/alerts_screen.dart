import 'package:flutter/material.dart';
import '../models/greenhouse_models.dart';
import '../services/greenhouse_service.dart';
import '../theme/app_colors.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GreenhouseService service = GreenhouseService();

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: const Text(
          'Alerts & Notifications',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<AlertNotice>>(
        stream: service.getAlertsStream(),
        builder: (context, snapshot) {
          final alerts = snapshot.data ?? [];

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              final bool isCritical = alert.type == 'critical';

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCritical ? AppColors.criticalBackground : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCritical
                        ? AppColors.criticalText.withOpacity(0.3)
                        : Colors.black12,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isCritical ? Icons.error_outline : Icons.info_outline,
                      color: isCritical ? AppColors.criticalText : AppColors.primaryGreen,
                      size: 26,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                alert.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isCritical ? AppColors.criticalText : AppColors.textDark,
                                ),
                              ),
                              Text(
                                _formatAgo(alert.createdAt),
                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            alert.message,
                            style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                          ),
                          if (isCritical) ...[
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                service.toggleDevice('ventilation', true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Roof ventilation opened automatically!'),
                                    backgroundColor: AppColors.primaryGreen,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.air, size: 16),
                              label: const Text('Open Roof Vents'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.criticalText,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
