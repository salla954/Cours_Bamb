import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/cities.dart';
import '../models/weather_model.dart';
import '../widgets/city_location_map.dart';

/// Écran de détail : météo complète d'une ville et sa localisation exacte
/// sur une carte Google Maps interactive.
class DetailScreen extends StatelessWidget {
  final CityInfo city;
  final WeatherData weather;

  const DetailScreen({super.key, required this.city, required this.weather});

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeLabel = DateFormat('HH:mm').format(weather.observedAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(city.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            tooltip: 'Retour à l\'accueil',
            onPressed: () => _goHome(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(weather.iconUrl, width: 72, height: 72),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${city.name}, ${city.country}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              weather.capitalizedDescription,
                              style: TextStyle(color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(icon: Icons.thermostat, label: 'Ressenti', value: '${weather.feelsLike.toStringAsFixed(1)}°C'),
                      _StatItem(icon: Icons.water_drop, label: 'Humidité', value: '${weather.humidity}%'),
                      _StatItem(icon: Icons.air, label: 'Vent', value: '${weather.windSpeedKmh.toStringAsFixed(0)} km/h'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mis à jour à $timeLabel',
                    style: TextStyle(fontSize: 12, color: colorScheme.outline),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CityLocationMap(city: city),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}
