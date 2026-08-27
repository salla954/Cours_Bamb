/// Données météo pour une ville, telles que renvoyées par l'API.
class WeatherData {
  final String cityName;
  final double latitude;
  final double longitude;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeedKmh;
  final String description;
  final String iconCode;
  final DateTime observedAt;

  const WeatherData({
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeedKmh,
    required this.description,
    required this.iconCode,
    required this.observedAt,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final windMs = (json['wind']?['speed'] as num?)?.toDouble() ?? 0.0;
    final weatherList = json['weather'] as List;
    return WeatherData(
      cityName: json['name'] as String? ?? 'Ville inconnue',
      latitude: (json['coord']?['lat'] as num).toDouble(),
      longitude: (json['coord']?['lon'] as num).toDouble(),
      temperature: (json['main']?['temp'] as num).toDouble(),
      feelsLike: (json['main']?['feels_like'] as num).toDouble(),
      humidity: (json['main']?['humidity'] as num).toInt(),
      windSpeedKmh: windMs * 3.6,
      description: weatherList.isNotEmpty ? weatherList[0]['description'] as String : '',
      iconCode: weatherList.isNotEmpty ? weatherList[0]['icon'] as String : '01d',
      observedAt: DateTime.now(),
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get capitalizedDescription =>
      description.isEmpty ? '' : '${description[0].toUpperCase()}${description.substring(1)}';
}
