import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/models/weather.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  const WeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.primaryDark]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.network(
            weather.iconUrl,
            width: 50,
            height: 50,
            errorBuilder: (_, __, ___) => Icon(Icons.cloud, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weather.temperatureDisplay, style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                Text(weather.condition, style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(children: [Icon(Icons.water_drop, color: Colors.white70, size: 14), SizedBox(width: 4), Text('${weather.humidity}%', style: TextStyle(color: Colors.white70))]),
              SizedBox(height: 4),
              Row(children: [Icon(Icons.air, color: Colors.white70, size: 14), SizedBox(width: 4), Text('${weather.windSpeed.round()} km/h', style: TextStyle(color: Colors.white70))]),
            ],
          ),
        ],
      ),
    );
  }
}
