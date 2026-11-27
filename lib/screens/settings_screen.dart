import 'package:flutter/material.dart';
import '../services/greenhouse_service.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GreenhouseService _service = GreenhouseService();
  double _maxTemp = 30.0;
  double _minSoilMoisture = 35.0;
  bool _isCelsius = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: const Text(
          'Settings & Thresholds',
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
          // User profile card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryGreen,
                  radius: 24,
                  child: Text('AM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alex Morgan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('alex.morgan@dacha.kz · Atyrau', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Automation Thresholds (M7 Settings)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Container(
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
                    const Text('Max Temperature Alarm', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('${_maxTemp.toInt()} ${_isCelsius ? "°C" : "°F"}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                  ],
                ),
                Slider(
                  value: _maxTemp,
                  min: 20,
                  max: 45,
                  divisions: 25,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (val) => setState(() => _maxTemp = val),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Min Soil Moisture (Auto-water)', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('${_minSoilMoisture.toInt()} %',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                  ],
                ),
                Slider(
                  value: _minSoilMoisture,
                  min: 15,
                  max: 60,
                  divisions: 45,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (val) => setState(() => _minSoilMoisture = val),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Temperature Units', style: TextStyle(fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        Text(_isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                        const SizedBox(width: 8),
                        Switch(
                          value: _isCelsius,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (val) => setState(() => _isCelsius = val),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Save button
          ElevatedButton.icon(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await _service.saveSettings(
                maxTemp: _maxTemp,
                minSoilMoisture: _minSoilMoisture,
                isCelsius: _isCelsius,
              );
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    '✅ Settings saved! Max Temp: ${_maxTemp.toInt()}°C, Min Moisture: ${_minSoilMoisture.toInt()}%',
                  ),
                  backgroundColor: AppColors.primaryGreen,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text('Save Configuration', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 16),

          // Cloud sync status
          Center(
            child: Text(
              'Connected to Firestore · smartgreen-b9cbe',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    );
  }
}
