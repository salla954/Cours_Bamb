import 'package:flutter/material.dart';
import '../data/cities.dart';
import '../models/weather_model.dart';

/// Tableau interactif listant les 5 villes et leur météo courante.
/// Chaque ligne est tappable et ouvre l'écran de détail correspondant.
class CitiesTable extends StatelessWidget {
  final List<CityInfo> cities;
  final List<WeatherData?> results;
  final void Function(CityInfo city, WeatherData weather) onCityTap;

  const CitiesTable({
    super.key,
    required this.cities,
    required this.results,
    required this.onCityTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: cities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final city = cities[index];
        final weather = results[index];
        if (weather == null) return const SizedBox.shrink();

        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => onCityTap(city, weather),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Image.network(weather.iconUrl, width: 44, height: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(city.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(
                          weather.capitalizedDescription,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
