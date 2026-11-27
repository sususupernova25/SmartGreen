import 'package:flutter/material.dart';
import '../models/greenhouse_models.dart';
import '../services/greenhouse_service.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenControl;

  const HomeScreen({
    super.key,
    required this.onOpenAlerts,
    required this.onOpenControl,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GreenhouseService _service = GreenhouseService();
  bool _awayMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning, Alex',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Atyrau Dacha Greenhouse',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.primaryGreen, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: widget.onOpenAlerts,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<SensorReadings>(
        stream: _service.getSensorReadingsStream(),
        builder: (context, snapshot) {
          final readings = snapshot.data ??
              SensorReadings(
                temperature: 24.6,
                airHumidity: 68.0,
                soilMoisture: 64.0,
                lightKlx: 12.4,
                waterLevelLiters: 984.0,
                updatedAt: DateTime.now(),
              );

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // Status banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.eco, color: Colors.white, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Everything is growing well',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Live from Firestore · Updated ${_formatTime(readings.updatedAt)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        onPressed: widget.onOpenControl,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Away mode toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _awayMode ? Icons.flight_takeoff : Icons.home,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Away Mode',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                _awayMode ? 'Smart autonomous rules active' : 'Standard schedule',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: _awayMode,
                        activeColor: AppColors.primaryGreen,
                        onChanged: (val) => setState(() => _awayMode = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 4 Sensor Cards Grid (M2 Dashboard)
                const Text(
                  'Live Conditions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _buildMetricCard(
                      title: 'Air Temperature',
                      value: '${readings.temperature.toStringAsFixed(1)} °C',
                      icon: Icons.thermostat,
                      iconColor: readings.temperature > 32 ? Colors.red : AppColors.amberAccent,
                      status: readings.temperature > 32 ? 'High' : 'Normal',
                      isAlert: readings.temperature > 32,
                    ),
                    _buildMetricCard(
                      title: 'Air Humidity',
                      value: '${readings.airHumidity.toStringAsFixed(0)} %',
                      icon: Icons.water_drop_outlined,
                      iconColor: Colors.blue,
                      status: 'Optimal',
                      isAlert: false,
                    ),
                    _buildMetricCard(
                      title: 'Soil Moisture',
                      value: '${readings.soilMoisture.toStringAsFixed(0)} %',
                      icon: Icons.grass,
                      iconColor: AppColors.primaryGreen,
                      status: readings.soilMoisture < 30 ? 'Dry' : 'Good',
                      isAlert: readings.soilMoisture < 30,
                    ),
                    _buildMetricCard(
                      title: 'Sunlight',
                      value: '${readings.lightKlx.toStringAsFixed(1)} klx',
                      icon: Icons.wb_sunny_outlined,
                      iconColor: AppColors.amberAccent,
                      status: 'Daylight',
                      isAlert: false,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Water reserve card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.water, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Water Reserve',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              '${readings.waterLevelLiters.toStringAsFixed(0)} L available (82%)',
                              style: const TextStyle(color: AppColors.textDark, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Sufficient for 6 days away',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required String status,
    required bool isAlert,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isAlert ? AppColors.criticalBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAlert ? AppColors.criticalText.withOpacity(0.3) : Colors.black12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isAlert ? AppColors.criticalText : AppColors.textMuted,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isAlert ? AppColors.criticalText : AppColors.textDark,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isAlert
                  ? AppColors.criticalText.withOpacity(0.1)
                  : AppColors.softGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isAlert ? AppColors.criticalText : AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
