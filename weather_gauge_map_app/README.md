# Météo Live — Flutter

Application Flutter proposant une expérience guidée : écran d'accueil,
chargement animé de la météo de 5 villes, tableau interactif, puis détail
par ville avec localisation sur Google Maps.

## 🎬 Parcours utilisateur

1. **Écran d'accueil** — message de bienvenue + bouton « Commencer »
2. **Écran principal**
   - Une jauge circulaire animée se remplit automatiquement, ville après ville
   - Un message d'attente change en boucle toutes les ~2,2 s
   - Une fois les 5 appels terminés, la jauge se transforme en bouton
     **« Recommencer »** et un tableau interactif des 5 villes apparaît
   - En cas d'échec d'un appel, un écran d'erreur avec bouton **« Réessayer »**
     remplace la jauge
3. **Écran de détail** — météo complète de la ville + carte Google Maps
   centrée sur ses coordonnées exactes
4. **Retour à l'accueil** — un bouton dédié (icône maison) dans l'AppBar de
   chaque écran ramène directement à l'accueil, à tout moment
5. **Mode clair / sombre** — bascule via l'icône soleil/lune dans l'AppBar

## 🗂️ Structure du projet

```
lib/
├── main.dart                          # Providers + MaterialApp (thème clair/sombre)
├── data/
│   └── cities.dart                    # Les 5 villes (nom + coordonnées fixes)
├── models/
│   └── weather_model.dart             # WeatherData (parsing JSON OpenWeatherMap)
├── services/
│   └── weather_service.dart           # Client HTTP vers OpenWeatherMap
├── providers/
│   ├── cities_weather_provider.dart   # Orchestration du chargement séquentiel
│   └── theme_provider.dart            # Mode clair / sombre
├── theme/
│   └── app_theme.dart                 # ThemeData clair & sombre centralisés
├── widgets/
│   ├── progress_gauge.dart            # Jauge circulaire animée (Syncfusion)
│   ├── restart_button.dart            # Bouton "Recommencer" (remplace la jauge)
│   ├── waiting_message.dart           # Message d'attente avec fondu
│   ├── error_view.dart                # Écran d'erreur + bouton Réessayer
│   ├── cities_table.dart              # Tableau interactif des 5 villes
│   └── city_location_map.dart         # Carte OpenStreetMap (détail, sans clé API)
└── screens/
    ├── welcome_screen.dart
    ├── main_screen.dart
    └── detail_screen.dart
```

## ⚙️ Comment fonctionne le chargement séquentiel

`CitiesWeatherProvider.start()` :
1. Réinitialise l'état et démarre la rotation des messages d'attente
   (`Timer.periodic`)
2. Boucle sur les 5 villes : appelle `WeatherService.fetchWeather(city)`,
   met à jour la progression (`i / 5`), attend `kDelayBetweenCalls`
   (1,4 s, ajustable) avant la ville suivante — ce délai simule des appels
   "toutes les quelques secondes" pour que la jauge soit visible
3. Si un appel échoue : passe en état d'erreur, arrête tout, expose le
   message pour l'écran d'erreur
4. Une fois les 5 villes chargées : passe en état `isComplete`, ce qui
   déclenche la transition jauge → bouton "Recommencer" dans `MainScreen`

## 🔑 Configuration requise avant de lancer l'app

### Clé API OpenWeatherMap
1. Crée un compte gratuit sur https://home.openweathermap.org/users/sign_up
2. Récupère ta clé sur https://home.openweathermap.org/api_keys
3. Colle-la dans `lib/services/weather_service.dart` :
   ```dart
   static const String apiKey = 'TA_CLE_ICI';
   ```
   ⚠️ Une clé fraîchement créée peut prendre jusqu'à 2h pour s'activer.

### Carte (OpenStreetMap — aucune clé requise)
La carte utilise `flutter_map` + OpenStreetMap : **pas de clé API, pas de
compte de facturation Google nécessaire**. Il suffit de fusionner
`android_manifest_snippet.xml` (permission Internet) dans
`android/app/src/main/AndroidManifest.xml`. Rien à faire côté iOS.

## 🚀 Lancer le projet

```bash
flutter pub get
flutter run
```

## 🧩 Notes techniques

- Le package `http` joue le rôle de client REST (équivalent Retrofit côté
  Android natif), isolé dans `WeatherService` : une seule responsabilité,
  facilement testable/remplaçable (ex. par `dio` si tu veux intercepteurs,
  logs, retry automatique, etc.).
- Les 5 villes ont des coordonnées fixes dans `data/cities.dart` pour
  éviter un appel de géocodage supplémentaire à chaque lancement.
- `kDelayBetweenCalls` et `kMessageRotationInterval` dans
  `cities_weather_provider.dart` sont les deux constantes à ajuster pour
  changer le rythme de l'animation.
- Le mode sombre est un vrai `ColorScheme.fromSeed(brightness: dark)`,
  pas un simple filtre — cartes, boutons et champs restent cohérents.
