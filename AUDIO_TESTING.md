# Guide de Test - Lecture Audio

Ce guide explique comment tester la lecture audio avec votre API.

## Architecture Audio

### 🎵 Système de Fichiers Audio

Votre API utilise un système GED (Gestion Électronique de Documents) :

```
Podcast → audioFileUuid → http://51.254.204.25:2000/ged/preview?uuid={podcast_uuid}
```

**Important** : Chaque podcast a un `audioFileUuid` qui est utilisé pour récupérer le fichier audio via l'API `/ged/preview`.

## Pages de Test Créées

### 1. TestAudioPage (`lib/test_audio_page.dart`)

Page simple qui liste tous les podcasts avec indication de disponibilité audio.

**Fonctionnalités** :
- Liste tous les podcasts depuis l'API
- Badge "Audio disponible" ou "Pas d'audio"
- Clic sur un podcast → navigation vers le lecteur
- Bouton refresh pour recharger

**Comment y accéder** :
```dart
import 'package:podcast/test_audio_page.dart';

Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => TestAudioPage()),
);
```

### 2. PodcastDetailPageWithAudio (`lib/podcast_detail_page.dart`)

Page complète de lecture audio avec lecteur intégré.

**Fonctionnalités** :
- Affichage de l'image du podcast
- Lecteur audio avec :
  - Play/Pause
  - Slider de progression
  - Reculer de 10 secondes
  - Avancer de 10 secondes
  - Affichage du temps (position / durée)
- Affichage de l'UUID du fichier audio (debug)
- Affichage de l'URL de l'API utilisée (debug)
- Gestion des erreurs

**Comment y accéder** :
```dart
import 'package:podcast/podcast_detail_page.dart';
import 'package:podcast/models/podcast.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PodcastDetailPageWithAudio(
      podcast: podcast, // Instance de Podcast
    ),
  ),
);
```

## MediaService - Helper d'URLs

Le service `MediaService` construit automatiquement les URLs :

```dart
import 'package:podcast/services/media_service.dart';

// URL audio
final audioUrl = MediaService.getAudioUrl(podcast.audioFileUuid);
// → http://51.254.204.25:2000/ged/preview?uuid=dc82e38d-9627-454f-84c2-b3a6a1009138

// URL image
final imageUrl = MediaService.getImageUrl(podcast.imagePath);
// → http://51.254.204.25:2000/uploads/image.jpg
```

## Comment Tester

### Étape 1 : Vérifier l'API

Assurez-vous que votre API est accessible :

```bash
# Test de connexion
curl http://51.254.204.25:2000/category

# Test d'authentification
curl -X POST http://51.254.204.25:2000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"login":"votre_login","password_hash":"votre_password"}'
```

### Étape 2 : Se Connecter à l'App

1. Lancer l'application
2. Se connecter avec vos identifiants
3. Le token JWT est automatiquement sauvegardé

### Étape 3 : Tester la Page de Test

Option 1 - Depuis la page Profile :
```dart
// Ajouter un bouton dans profile_page.dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TestAudioPage()),
    );
  },
  child: Text('Tester Audio'),
)
```

Option 2 - Modifier temporairement main.dart :
```dart
// Dans MainScreen, remplacer temporairement une page
final List<Widget> _pages = [
  const TestAudioPage(), // Au lieu de home.HomePage()
  const PlaylistPage(),
  const FavoritesPage(),
  const ProfilePage(),
];
```

### Étape 4 : Tester la Lecture

1. La page affiche la liste des podcasts
2. Vérifier les badges :
   - ✅ "Audio disponible" (vert) = podcast a un audioFileUuid
   - ⚠️ "Pas d'audio" (orange) = pas d'audioFileUuid
3. Cliquer sur un podcast avec audio disponible
4. La page de détail s'ouvre
5. Vérifier les infos debug :
   - UUID du fichier audio
   - URL de l'API
6. Cliquer sur le bouton Play ▶️
7. L'audio devrait se charger et jouer

## Résolution de Problèmes

### ❌ Erreur de chargement audio

**Causes possibles** :
1. Le podcast n'a pas d'`audioFileUuid`
2. L'UUID est invalide
3. Le serveur GED ne répond pas
4. Problème de réseau

**Solutions** :
```dart
// Vérifier dans la console
print('Audio URL: ${MediaService.getAudioUrl(podcast.audioFileUuid)}');

// L'URL devrait être:
// http://51.254.204.25:2000/ged/preview?uuid=xxxxx-xxxxx-xxxxx
```

### ❌ Pas de podcasts affichés

**Causes** :
1. Problème d'authentification (token expiré)
2. Aucun podcast dans la base de données
3. Problème de connexion API

**Solutions** :
1. Se reconnecter pour rafraîchir le token
2. Vérifier l'API : `GET /podcast` avec le token
3. Ajouter des podcasts via l'API ou l'interface admin

### ❌ Images ne s'affichent pas

Les images utilisent un système différent. Vérifiez :
```dart
final imageUrl = MediaService.getImageUrl(podcast.imagePath);
print('Image URL: $imageUrl');
```

## Exemple de Podcast de Test

Pour tester, créez un podcast via l'API avec ces données :

```bash
curl -X POST http://51.254.204.25:2000/podcast \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "libelle=Podcast Test Audio" \
  -F "description=Podcast pour tester la lecture audio" \
  -F "category_uuid=UUID_DE_VOTRE_CATEGORIE" \
  -F "file=@/path/to/audio.mp3"
```

L'API devrait retourner un podcast avec un `audioFileUuid` que vous pourrez utiliser pour tester.

## Intégration dans l'App Principale

Pour intégrer le lecteur audio dans votre app :

### 1. Dans home_page.dart
```dart
// Au lieu de naviguer vers une page statique
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PodcastDetailPageWithAudio(
        podcast: podcast,
      ),
    ),
  );
}
```

### 2. Dans une liste de podcasts
```dart
ListView.builder(
  itemCount: podcasts.length,
  itemBuilder: (context, index) {
    final podcast = podcasts[index];
    return ListTile(
      title: Text(podcast.libelle),
      trailing: podcast.audioFileUuid != null
          ? Icon(Icons.play_circle, color: Colors.green)
          : Icon(Icons.music_off, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PodcastDetailPageWithAudio(
              podcast: podcast,
            ),
          ),
        );
      },
    );
  },
)
```

## Fichiers Créés

- `lib/services/media_service.dart` - Helper pour URLs
- `lib/podcast_detail_page.dart` - Page de lecture audio complète
- `lib/test_audio_page.dart` - Page de test et debug
- `lib/models/podcast.dart` - Modèle mis à jour avec `audioFileUuid`

## API Endpoints Utilisés

- `GET /podcast` - Liste des podcasts (avec audioFileUuid)
- `GET /ged/preview?uuid={uuid}` - Récupération du fichier audio
- `GET /{imagePath}` - Récupération des images

## Notes Importantes

1. **Token JWT requis** : Toutes les requêtes nécessitent un token valide
2. **UUID du podcast** : C'est l'UUID du podcast qui est utilisé pour `/ged/preview`, pas un UUID de fichier séparé
3. **Format audio** : L'API supporte MP3, M4A, WAV, etc. (formats supportés par `just_audio`)
4. **Streaming** : Le lecteur utilise le streaming, pas de téléchargement complet avant lecture

Bon test ! 🎧
