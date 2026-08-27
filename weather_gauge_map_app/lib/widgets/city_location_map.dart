import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/cities.dart';

/// Affiche la localisation exacte d'une ville sur une carte OpenStreetMap,
/// avec un marqueur centré sur ses coordonnées.
///
/// Contrairement à Google Maps, OpenStreetMap ne nécessite ni clé API,
/// ni compte de facturation : les tuiles cartographiques sont servies
/// gratuitement par tile.openstreetmap.org.
class CityLocationMap extends StatelessWidget {
  final CityInfo city;

  const CityLocationMap({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final position = LatLng(city.latitude, city.longitude);

    return FlutterMap(
      options: MapOptions(
        initialCenter: position,
        initialZoom: 10,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.weather_gauge_map_app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: position,
              width: 48,
              height: 48,
              child: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.error,
                size: 44,
              ),
            ),
          ],
        ),
        // Attribution obligatoire pour respecter la licence OpenStreetMap.
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution('© OpenStreetMap contributors'),
          ],
        ),
      ],
    );
  }
}
