# 🎉 Galsen Podcast - API Backend Integration

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![Build](https://img.shields.io/badge/Build-Passing-brightgreen.svg)]()

Application Flutter Galsen Podcast **complètement intégrée** avec l'API backend.

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| **[QUICK_START.md](QUICK_START.md)** | 🚀 Démarrage rapide en 5 minutes |
| **[RESUME_INTEGRATION.md](RESUME_INTEGRATION.md)** | 🎊 Vue d'ensemble complète de l'intégration |
| **[API_INTEGRATION.md](API_INTEGRATION.md)** | 📖 Guide détaillé de l'API et utilisation |
| **[AUDIO_TESTING.md](AUDIO_TESTING.md)** | 🎵 Guide de test de la lecture audio |
| **[CLAUDE.md](CLAUDE.md)** | 📝 Instructions du projet (original) |

---

## ⚡ Démarrage en 30 Secondes

```bash
# 1. Installer
flutter pub get

# 2. Lancer
flutter run

# 3. Se connecter et tester !
```

📖 **Détails** : Voir [QUICK_START.md](QUICK_START.md)

---

## 🎯 Fonctionnalités Implémentées

### ✅ Authentification
- 🔐 Login avec API
- ✍️ Signup avec upload photo de profil
- 🔑 Token JWT automatique (stockage, injection, gestion)
- 💾 Session persistante

### ✅ Gestion des Données (BLoC)
- 📂 CRUD Catégories
- 🎙️ CRUD Podcasts
- 👤 Profil utilisateur
- 🔄 Refresh automatique

### ✅ Lecture Audio
- 🎵 API GED pour streaming audio
- ▶️ Lecteur complet (Play/Pause, Seek, ±10s)
- 📊 Affichage de la progression
- ❌ Gestion des erreurs

---

## 🏗️ Architecture

```
UI (Flutter Pages)
       ↓
BLoCs (State Management)
       ↓
Repositories (Business Logic)
       ↓
Services (API Communication)
       ↓
Backend API (http://51.254.204.25:2000)
```

**Pattern** : BLoC (Business Logic Component)
**State** : flutter_bloc
**HTTP** : Dio
**Audio** : just_audio

---

## 🎵 Lecture Audio - API GED

```
GET http://51.254.204.25:2000/ged/preview?uuid={podcast_uuid}
```

### Utilisation

```dart
import 'package:podcast/services/media_service.dart';

final audioUrl = MediaService.getAudioUrl(podcast.audioFileUuid);
// → http://51.254.204.25:2000/ged/preview?uuid=xxxxx

final player = AudioPlayer();
await player.setUrl(audioUrl);
await player.play();
```

---

## 📦 Structure des Fichiers

```
lib/
├── bloc/              # BLoCs (Auth, Category, Podcast)
├── models/            # Models (User, Category, Podcast, Episode)
├── repositories/      # Data repositories
├── services/          # API services
│   ├── api_service.dart      # HTTP + JWT
│   ├── auth_service.dart     # Authentication
│   └── media_service.dart    # Audio/Image URLs
├── login_page.dart
├── signup_page.dart
├── podcast_detail_page.dart  # Audio player
├── test_audio_page.dart      # Test page
└── main.dart
```

---

## 🚀 API Endpoints

### Authentification
- `POST /auth/login` - Connexion
- `POST /users/createUser` - Inscription

### Catégories
- `GET /category` - Liste
- `POST /category` - Créer
- `PUT /category/:uuid` - Modifier
- `DELETE /category/:uuid` - Supprimer

### Podcasts
- `GET /podcast` - Liste tous
- `GET /podcast/category/:uuid` - Par catégorie
- `POST /podcast` - Créer
- `PUT /podcast/:uuid` - Modifier
- `DELETE /podcast/:uuid` - Supprimer

### Fichiers
- `GET /ged/preview?uuid={uuid}` - Audio streaming

---

## 🧪 Test de l'Audio

### Méthode Rapide

1. Modifier `lib/main.dart` ligne ~100 :
```dart
final List<Widget> _pages = [
  const TestAudioPage(),  // ← Ajouter
  // ...
];
```

2. Ajouter l'import :
```dart
import 'test_audio_page.dart';
```

3. Hot reload : `r`

4. Tester !

📖 **Plus de détails** : [AUDIO_TESTING.md](AUDIO_TESTING.md)

---

## 📱 Pages Créées

| Page | Description |
|------|-------------|
| `TestAudioPage` | Liste des podcasts avec badges audio |
| `PodcastDetailPageWithAudio` | Lecteur audio complet |
| `SignupPage` | Inscription avec photo |
| `LoginPage` | Connexion (mis à jour) |

---

## 🔧 Build Status

✅ **Build réussi**
```
✓ Built build/app/outputs/flutter-apk/app-debug.apk
```

---

## 📚 Exemples de Code

### Login
```dart
context.read<AuthBloc>().add(
  AuthLoginRequested(
    login: 'username',
    password: 'password',
  ),
);
```

### Charger les Podcasts
```dart
context.read<PodcastBloc>().add(PodcastLoadAllRequested());

BlocBuilder<PodcastBloc, PodcastState>(
  builder: (context, state) {
    if (state is PodcastLoaded) {
      return ListView.builder(...);
    }
  },
)
```

### Jouer l'Audio
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PodcastDetailPageWithAudio(
      podcast: podcast,
    ),
  ),
);
```

---

## 🔑 Configuration

### URL de l'API
Définie dans `lib/services/api_service.dart` :
```dart
static const String baseUrl = 'http://51.254.204.25:2000';
```

### Token JWT
- Automatiquement stocké dans `SharedPreferences`
- Injecté dans toutes les requêtes
- Clear automatique si expiré (401)

---

## 🆘 Support

### Problèmes courants

**Pas de podcasts ?**
- Vérifier la connexion API
- Se reconnecter pour rafraîchir le token
- Ajouter des podcasts via l'API

**Audio ne joue pas ?**
- Vérifier que `audioFileUuid` existe
- Vérifier l'URL dans la console
- Tester l'URL dans le navigateur

**401 Unauthorized ?**
- Token expiré
- Se déconnecter et se reconnecter

📖 **Plus d'aide** : [AUDIO_TESTING.md](AUDIO_TESTING.md#résolution-de-problèmes)

---

## 🎯 Prochaines Étapes

- [ ] Adapter `home_page.dart` pour l'API
- [ ] Créer pages d'administration
- [ ] Implémenter favoris backend
- [ ] Ajouter recherche
- [ ] Mini-player persistant

---

## 📦 Dépendances Principales

```yaml
dependencies:
  flutter_bloc: ^8.1.3       # State management
  dio: ^5.4.0                # HTTP client
  just_audio: ^0.9.36        # Audio player
  shared_preferences: ^2.2.2 # Local storage
  image_picker: ^1.0.7       # Image selection
  equatable: ^2.0.5          # Value equality
```

---

## 👨‍💻 Développement

```bash
# Analyser le code
flutter analyze

# Formater
flutter format lib/

# Build debug
flutter build apk --debug

# Build release
flutter build apk --release
```

---

## 📄 License

Ce projet utilise Flutter et les bibliothèques open source listées dans `pubspec.yaml`.

---

## 🙏 Remerciements

- Flutter Team
- BLoC Library
- just_audio Package
- Dio HTTP Client

---

**Bon développement ! 🚀**

Pour plus de détails, consultez la [documentation complète](API_INTEGRATION.md).
