import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/cities.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

/// Délai artificiel entre deux appels API, pour que l'utilisateur voie
/// clairement la jauge se remplir ville par ville ("toutes les quelques
/// secondes"). Réduis cette valeur si tu préfères un chargement plus rapide.
const Duration kDelayBetweenCalls = Duration(milliseconds: 1400);

/// Fréquence de rotation des messages d'attente affichés pendant le chargement.
const Duration kMessageRotationInterval = Duration(milliseconds: 2200);

const List<String> kWaitingMessages = [
  'Nous téléchargeons les données…',
  'Interrogation des stations météo…',
  'C\'est presque fini…',
  'Plus que quelques secondes avant d\'avoir le résultat…',
];

/// Orchestration complète de l'expérience "météo en direct" :
/// appelle l'API pour chaque ville l'une après l'autre, expose la progression
/// pour la jauge animée, fait tourner les messages d'attente, et gère
/// l'état d'erreur avec possibilité de relance.
class CitiesWeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  final List<WeatherData?> _results = List<WeatherData?>.filled(kCities.length, null);
  double _progress = 0;
  bool _isLoading = false;
  bool _isComplete = false;
  bool _hasError = false;
  String? _errorMessage;
  int _messageIndex = 0;
  Timer? _messageTimer;

  List<CityInfo> get cities => kCities;
  List<WeatherData?> get results => List.unmodifiable(_results);
  double get progress => _progress;
  bool get isLoading => _isLoading;
  bool get isComplete => _isComplete;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  String get currentWaitingMessage => kWaitingMessages[_messageIndex];

  /// Lance (ou relance) le chargement séquentiel des 5 villes depuis le début.
  Future<void> start() async {
    _messageTimer?.cancel();
    _results.setAll(0, List<WeatherData?>.filled(kCities.length, null));
    _progress = 0;
    _isLoading = true;
    _isComplete = false;
    _hasError = false;
    _errorMessage = null;
    _messageIndex = 0;
    notifyListeners();

    _startMessageRotation();

    for (var i = 0; i < kCities.length; i++) {
      try {
        final weather = await _service.fetchWeather(kCities[i]);
        _results[i] = weather;
        _progress = (i + 1) / kCities.length;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _isLoading = false;
        _errorMessage = e.toString();
        _messageTimer?.cancel();
        notifyListeners();
        return;
      }
      if (i < kCities.length - 1) {
        await Future.delayed(kDelayBetweenCalls);
      }
    }

    _isLoading = false;
    _isComplete = true;
    _messageTimer?.cancel();
    notifyListeners();
  }

  /// Relance l'expérience après une erreur (bouton "Réessayer").
  void retry() => start();

  void _startMessageRotation() {
    _messageTimer = Timer.periodic(kMessageRotationInterval, (_) {
      _messageIndex = (_messageIndex + 1) % kWaitingMessages.length;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }
}
