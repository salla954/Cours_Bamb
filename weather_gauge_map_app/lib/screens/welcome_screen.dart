import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cities_weather_provider.dart';
import 'main_screen.dart';

/// Écran d'accueil : message de bienvenue et bouton pour lancer l'expérience.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _start(BuildContext context) {
    // On réinitialise puis on démarre le chargement AVANT de naviguer,
    // pour que la jauge parte déjà en mouvement dès l'affichage de l'écran.
    final provider = context.read<CitiesWeatherProvider>();
    provider.start();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary.withOpacity(0.9), colorScheme.primaryContainer],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_cloudy_rounded, size: 96, color: colorScheme.onPrimary),
                  const SizedBox(height: 24),
                  Text(
                    'Bienvenue sur Météo Live',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Découvrez en un instant la météo en direct de 5 grandes '
                    'villes du monde, présentée sur une carte interactive.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: colorScheme.onPrimary.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () => _start(context),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Commencer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.onPrimary,
                      foregroundColor: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
