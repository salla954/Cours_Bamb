import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/cities.dart';
import '../models/weather_model.dart';
import '../providers/cities_weather_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/cities_table.dart';
import '../widgets/error_view.dart';
import '../widgets/progress_gauge.dart';
import '../widgets/restart_button.dart';
import '../widgets/waiting_message.dart';
import 'detail_screen.dart';

/// Écran principal : affiche la jauge de progression pendant le chargement
/// des 5 villes, puis le tableau interactif des résultats une fois terminé.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _openDetail(BuildContext context, CityInfo city, WeatherData weather) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailScreen(city: city, weather: weather)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CitiesWeatherProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo en direct'),
        leading: IconButton(
          icon: const Icon(Icons.home_rounded),
          tooltip: 'Retour à l\'accueil',
          onPressed: () => _goHome(context),
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Changer de thème',
            onPressed: themeProvider.toggle,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              flex: 5,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (provider.hasError)
                        ErrorView(
                          message: provider.errorMessage ?? 'Erreur inconnue.',
                          onRetry: provider.retry,
                        )
                      else ...[
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) => ScaleTransition(
                            scale: animation,
                            child: FadeTransition(opacity: animation, child: child),
                          ),
                          child: provider.isComplete
                              ? RestartButton(key: const ValueKey('restart'), onPressed: provider.start)
                              : ProgressGauge(key: const ValueKey('gauge'), progress: provider.progress),
                        ),
                        const SizedBox(height: 20),
                        if (!provider.isComplete) WaitingMessage(message: provider.currentWaitingMessage),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: provider.isComplete
                    ? CitiesTable(
                        key: const ValueKey('table'),
                        cities: provider.cities,
                        results: provider.results,
                        onCityTap: (city, weather) => _openDetail(context, city, weather),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
