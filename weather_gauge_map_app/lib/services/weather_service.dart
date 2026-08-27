import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/cities.dart';
import '../models/weather_model.dart';

/// Exception dédiée pour distinguer les erreurs API des autres erreurs Dart.
class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);
  @override
  String toString() => message;
}

/// Encapsule les appels à l'API OpenWeatherMap.
///
/// Le package `http` joue ici le rôle de client REST, au même titre que
/// Retrofit côté Android natif : une seule responsabilité (parler au réseau),
/// isolée du reste de l'application.
///
/// ⚠️ Remplace [apiKey] par ta propre clé, obtenue gratuitement sur
/// https://home.openweathermap.org/api_keys
class WeatherService {
  static const String apiKey = '2f763e61165415fe27d508057012fefe';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Récupère la météo courante pour une ville donnée par ses coordonnées.
  Future<WeatherData> fetchWeather(CityInfo city) async {
    final uri = Uri.parse(
      '$_baseUrl/weather'
      '?lat=${city.latitude}&lon=${city.longitude}'
      '&units=metric&lang=fr&appid=$apiKey',
    );

    late final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } catch (_) {
      throw WeatherApiException('Impossible de contacter le serveur météo pour ${city.name}.');
    }

    if (response.statusCode != 200) {
      throw WeatherApiException(_parseError(response, city.name));
    }

    return WeatherData.fromJson(jsonDecode(response.body));
  }

  String _parseError(http.Response response, String cityName) {
    try {
      final body = jsonDecode(response.body);
      final apiMessage = body['message'] as String?;
      return apiMessage != null
          ? 'Erreur pour $cityName : $apiMessage'
          : 'Erreur pour $cityName (code ${response.statusCode}).';
    } catch (_) {
      return 'Erreur pour $cityName (code ${response.statusCode}).';
    }
  }
}
