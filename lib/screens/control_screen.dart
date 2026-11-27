import 'package:flutter/material.dart';
import '../models/greenhouse_models.dart';
import '../services/greenhouse_service.dart';
import '../theme/app_colors.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final GreenhouseService _service = GreenhouseService();
  bool _isAutoMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: const Text(
          'Climate Control',
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
          // Segmented mode switch (M4 Modes)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAutoMode = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_isAutoMode ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: !_isAutoMode
                            ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Manual',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: !_isAutoMode ? AppColors.primaryGreen : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAutoMode = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _isAutoMode ? AppColors.primaryGreen : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _isAutoMode
                            ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Automatic',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isAutoMode ? Colors.white : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Active Mode Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isAutoMode ? AppColors.softGreen : AppColors.warningBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  _isAutoMode ? Icons.auto_awesome : Icons.touch_app,
                  color: _isAutoMode ? AppColors.primaryGreen : AppColors.warningText,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isAutoMode ? 'AUTOMATIC MODE ACTIVE' : 'MANUAL OVERRIDE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _isAutoMode ? AppColors.primaryGreen : AppColors.warningText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isAutoMode
                            ? 'Rules: Soil < 30% waters automatically; Temp > 28°C opens vents.'
                            : 'Sensors only report status; all devices are controlled by you.',
                        style: const TextStyle(fontSize: 11, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Actuators & Devices',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          StreamBuilder<List<DeviceItem>>(
            stream: _service.getDevicesStream(),
            builder: (context, snapshot) {
              final devices = snapshot.data ?? [];

              return Column(
                children: [
                  _buildDeviceCard(
                    id: 'irrigation',
                    title: 'Irrigation Pump',
                    subtitle: 'Automatic drip lines · 3 beds',
                    icon: Icons.water_drop,
                    devices: devices,
                  ),
                  const SizedBox(height: 12),
                  _buildDeviceCard(
                    id: 'ventilation',
                    title: 'Roof Windows & Vents',
                    subtitle: 'Opens when temperature exceeds 28°C',
                    icon: Icons.air,
                    devices: devices,
                  ),
                  const SizedBox(height: 12),
                  _buildDeviceCard(
                    id: 'lighting',
                    title: 'Grow Lights',
                    subtitle: 'Scheduled spectrum lighting',
                    icon: Icons.lightbulb,
                    devices: devices,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<DeviceItem> devices,
  }) {
    final device = devices.firstWhere(
      (d) => d.id == id,
      orElse: () => DeviceItem(id: id, name: title, state: false, updatedAt: DateTime.now()),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: device.state ? AppColors.softGreen : Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: device.state ? AppColors.primaryGreen : AppColors.textMuted,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: device.state,
            activeColor: AppColors.primaryGreen,
            onChanged: (val) {
              _service.toggleDevice(id, val);
            },
          ),
        ],
      ),
    );
  }
}
