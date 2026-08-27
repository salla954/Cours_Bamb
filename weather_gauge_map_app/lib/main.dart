import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cities_weather_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const WeatherLiveApp());
}

class WeatherLiveApp extends StatelessWidget {
  const WeatherLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CitiesWeatherProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Météo Live',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.mode,
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
