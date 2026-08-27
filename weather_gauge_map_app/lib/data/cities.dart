/// Représente une ville pour laquelle on va interroger l'API météo.
/// Les coordonnées sont fournies directement pour éviter un appel de
/// géocodage supplémentaire à chaque lancement de l'expérience.
class CityInfo {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  const CityInfo({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}

/// Les 5 villes affichées par l'expérience "météo en direct".
const List<CityInfo> kCities = [
  CityInfo(name: 'Paris', country: 'France', latitude: 48.8566, longitude: 2.3522),
  CityInfo(name: 'Londres', country: 'Royaume-Uni', latitude: 51.5074, longitude: -0.1278),
  CityInfo(name: 'New York', country: 'États-Unis', latitude: 40.7128, longitude: -74.0060),
  CityInfo(name: 'Tokyo', country: 'Japon', latitude: 35.6895, longitude: 139.6917),
  CityInfo(name: 'Sydney', country: 'Australie', latitude: -33.8688, longitude: 151.2093),
];
