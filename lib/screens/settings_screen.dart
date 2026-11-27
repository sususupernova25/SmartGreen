import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                    Text('${_maxTemp.toInt()} °C', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
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
                    Text('${_minSoilMoisture.toInt()} %', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                  ],
                ),
                Slider(
                  value: _minSoilMoisture,
                  min: 10,
                  max: 60,
                  divisions: 10,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (val) => setState(() => _minSoilMoisture = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Units switch
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
                const Text('Temperature Unit', style: TextStyle(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Text(_isCelsius ? '°C (Celsius)' : '°F (Fahrenheit)', style: const TextStyle(color: AppColors.textMuted)),
                    Switch(
                      value: _isCelsius,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (val) => setState(() => _isCelsius = val),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Save settings button
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings saved to Firestore! Automation updated.'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
