# 📥 Guide de Téléchargement des Podcasts

## Vue d'ensemble

L'application supporte maintenant le **téléchargement** des podcasts pour une écoute hors-ligne.

### 🎯 Fonctionnalités

- ✅ Téléchargement avec progression en temps réel
- ✅ Stockage local dans l'appareil
- ✅ Gestion de l'espace disque
- ✅ Suppression des téléchargements
- ✅ Badge visuel "Téléchargé"
- ✅ Format de fichier lisible

---

## 🔌 API de Téléchargement

### Endpoint

```
GET http://51.254.204.25:2000/ged/download?uuid={podcast_uuid}
```

**Headers requis** :
```
Authorization: Bearer {jwt_token}
```

### Différence avec l'API de Streaming

| API | Endpoint | Usage |
|-----|----------|-------|
| **Streaming** | `/ged/preview?uuid=` | Lecture en ligne |
| **Téléchargement** | `/ged/download?uuid=` | Téléchargement local |

---

## 🏗️ Architecture

### 1. MediaService

Le `MediaService` a été mis à jour avec deux nouvelles méthodes :

```dart
// Streaming (existant)
MediaService.getAudioStreamUrl(podcast.audioFileUuid)
// → http://51.254.204.25:2000/ged/preview?uuid=xxxxx

// Téléchargement (nouveau)
MediaService.getAudioDownloadUrl(podcast.audioFileUuid)
// → http://51.254.204.25:2000/ged/download?uuid=xxxxx

// Alias (rétrocompatibilité)
MediaService.getAudioUrl(podcast.audioFileUuid)
// → Identique à getAudioStreamUrl
```

### 2. PodcastDownloadService

Service complet pour gérer les téléchargements :

**Localisation** : `lib/services/podcast_download_service.dart`

**Méthodes principales** :

```dart
// Télécharger un podcast
await downloadService.downloadPodcast(
  podcastUuid: podcast.uuid,
  podcastTitle: podcast.libelle,
  onProgress: (progress) {
    print('Progression: ${(progress * 100).toInt()}%');
  },
);

// Vérifier si téléchargé
bool isDownloaded = await downloadService.isPodcastDownloaded(
  podcast.uuid,
  podcast.libelle,
);

// Supprimer un téléchargement
await downloadService.deleteDownloadedPodcast(
  podcast.uuid,
  podcast.libelle,
);

// Obtenir la taille du fichier
int? size = await downloadService.getDownloadedFileSize(
  podcast.uuid,
  podcast.libelle,
);

// Lister tous les téléchargements
List<String> downloads = await downloadService.getDownloadedPodcasts();

// Espace total utilisé
int totalBytes = await downloadService.getTotalDownloadSize();

// Supprimer tous les téléchargements
await downloadService.clearAllDownloads();
```

### 3. Widgets de Téléchargement

**Localisation** : `lib/widgets/podcast_download_button.dart`

#### PodcastDownloadButton

Bouton interactif avec 3 états :

```dart
PodcastDownloadButton(
  podcast: podcast,
  downloadService: downloadService,
  onDownloadComplete: () {
    print('Téléchargement terminé !');
  },
  onDeleteComplete: () {
    print('Téléchargement supprimé !');
  },
)
```

**États** :
1. 📥 **Non téléchargé** : Icône de téléchargement grise
2. ⏳ **En téléchargement** : Cercle de progression avec %
3. ✅ **Téléchargé** : Icône verte (clic pour supprimer)

#### PodcastDownloadBadge

Badge compact affichant l'état et la taille :

```dart
PodcastDownloadBadge(
  podcast: podcast,
  downloadService: downloadService,
)
```

Affiche : `✅ 4.2 MB` si téléchargé, sinon rien.

---

## 💻 Utilisation

### Exemple Complet

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcast/models/podcast.dart';
import 'package:podcast/services/podcast_download_service.dart';
import 'package:podcast/services/api_service.dart';
import 'package:podcast/widgets/podcast_download_button.dart';

class PodcastListItem extends StatelessWidget {
  final Podcast podcast;

  const PodcastListItem({required this.podcast});

  @override
  Widget build(BuildContext context) {
    // Récupérer le service API
    final apiService = context.read<ApiService>();
    final downloadService = PodcastDownloadService(apiService);

    return ListTile(
      title: Text(podcast.libelle),
      subtitle: Text(podcast.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge de téléchargement
          PodcastDownloadBadge(
            podcast: podcast,
            downloadService: downloadService,
          ),
          const SizedBox(width: 8),
          // Bouton de téléchargement
          PodcastDownloadButton(
            podcast: podcast,
            downloadService: downloadService,
            onDownloadComplete: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Téléchargement terminé !')),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### Téléchargement Manuel

```dart
final apiService = context.read<ApiService>();
final downloadService = PodcastDownloadService(apiService);

try {
  final filePath = await downloadService.downloadPodcast(
    podcastUuid: podcast.uuid,
    podcastTitle: podcast.libelle,
    onProgress: (progress) {
      setState(() {
        _downloadProgress = progress;
      });
    },
  );

  print('Fichier téléchargé : $filePath');
} catch (e) {
  print('Erreur : $e');
}
```

---

## 📂 Stockage Local

### Emplacement des Fichiers

```
{ApplicationDocumentsDirectory}/podcast_downloads/
```

**Exemple** :
```
/data/user/0/com.example.podcast/files/podcast_downloads/
├── mon_podcast_dc82e38d.mp3
├── autre_podcast_5f4a2b1c.mp3
└── episode_test_a3d7e9f2.mp3
```

### Nommage des Fichiers

Format : `{titre_nettoyé}_{8_premiers_uuid}.mp3`

**Exemples** :
- Titre : "Mon Super Podcast"
- UUID : `dc82e38d-9627-454f-84c2-b3a6a1009138`
- Nom de fichier : `mon_super_podcast_dc82e38d.mp3`

### Nettoyage du Titre

- Caractères spéciaux supprimés
- Espaces remplacés par `_`
- En minuscules

---

## 📊 Gestion de l'Espace

### Vérifier l'Espace Utilisé

```dart
final downloadService = PodcastDownloadService(apiService);

// Taille totale
int totalBytes = await downloadService.getTotalDownloadSize();
String formatted = PodcastDownloadService.formatFileSize(totalBytes);
print('Espace utilisé : $formatted');

// Nombre de fichiers
List<String> files = await downloadService.getDownloadedPodcasts();
print('${files.length} podcasts téléchargés');
```

### Format Lisible

Le service inclut un formatter :

```dart
PodcastDownloadService.formatFileSize(1024);        // "1.0 KB"
PodcastDownloadService.formatFileSize(1048576);     // "1.0 MB"
PodcastDownloadService.formatFileSize(1073741824);  // "1.0 GB"
```

### Nettoyer l'Espace

```dart
// Supprimer tous les téléchargements
await downloadService.clearAllDownloads();
```

---

## 🎯 Cas d'Usage

### 1. Page de Liste de Podcasts

Afficher un badge pour les podcasts téléchargés :

```dart
ListView.builder(
  itemCount: podcasts.length,
  itemBuilder: (context, index) {
    final podcast = podcasts[index];
    return Card(
      child: ListTile(
        title: Text(podcast.libelle),
        trailing: PodcastDownloadBadge(
          podcast: podcast,
          downloadService: downloadService,
        ),
      ),
    );
  },
)
```

### 2. Page de Détail avec Téléchargement

```dart
AppBar(
  actions: [
    PodcastDownloadButton(
      podcast: podcast,
      downloadService: downloadService,
    ),
  ],
)
```

### 3. Page de Téléchargements

Liste de tous les podcasts téléchargés :

```dart
FutureBuilder<List<String>>(
  future: downloadService.getDownloadedPodcasts(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final filePath = snapshot.data![index];
          return ListTile(
            title: Text(filePath.split('/').last),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Supprimer
              },
            ),
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

---

## 🔒 Sécurité & Authentification

### Token JWT Requis

Le service utilise automatiquement le token JWT :

```dart
// Le token est récupéré automatiquement depuis ApiService
final token = _apiService.token;

// Ajouté dans les headers
await _dio.download(
  downloadUrl,
  filePath,
  options: Options(
    headers: {
      'Authorization': 'Bearer $token',
    },
  ),
);
```

### Gestion des Erreurs

```dart
try {
  await downloadService.downloadPodcast(...);
} catch (e) {
  if (e.toString().contains('Non authentifié')) {
    // Rediriger vers login
  } else if (e.toString().contains('UUID invalide')) {
    // Afficher erreur
  }
}
```

---

## ⚡ Performance

### Timeout

Téléchargement avec timeout de **10 minutes** :

```dart
receiveTimeout: const Duration(minutes: 10)
```

### Progression en Temps Réel

Callback appelé pendant le téléchargement :

```dart
onReceiveProgress: (received, total) {
  if (total != -1 && onProgress != null) {
    final progress = received / total;
    onProgress(progress); // 0.0 à 1.0
  }
}
```

### Vérification de Fichier Existant

Évite de re-télécharger :

```dart
if (await File(filePath).exists()) {
  return filePath; // Déjà téléchargé
}
```

---

## 🐛 Résolution de Problèmes

### ❌ Erreur "Non authentifié"

**Cause** : Token JWT manquant ou expiré

**Solution** :
```dart
// Se reconnecter
context.read<AuthBloc>().add(AuthLoginRequested(...));
```

### ❌ Erreur "UUID invalide"

**Cause** : Le podcast n'a pas d'audioFileUuid

**Solution** :
```dart
if (podcast.audioFileUuid == null) {
  // Afficher message : "Pas d'audio disponible"
}
```

### ❌ Téléchargement échoue

**Causes possibles** :
1. Connexion internet
2. Serveur indisponible
3. Espace disque insuffisant

**Debug** :
```dart
try {
  await downloadService.downloadPodcast(...);
} catch (e) {
  print('Erreur détaillée : $e');
}
```

### ❌ Fichier ne s'affiche pas comme téléchargé

**Solution** :
```dart
// Forcer la vérification
await downloadService.isPodcastDownloaded(...);
```

---

## 📱 Intégration dans main.dart

Ajouter le service dans les providers :

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final downloadService = PodcastDownloadService(apiService);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: apiService),
        RepositoryProvider.value(value: downloadService), // 👈 Ajouter
        // ...
      ],
      child: MultiBlocProvider(
        // ...
      ),
    );
  }
}
```

Puis utiliser dans l'app :

```dart
final downloadService = context.read<PodcastDownloadService>();
```

---

## 🎯 Exemple Complet : Page avec Téléchargement

Voir le fichier d'exemple : `lib/examples/download_example_page.dart`

---

## 📚 Fichiers Créés

- `lib/services/media_service.dart` - Mis à jour avec URLs de téléchargement
- `lib/services/podcast_download_service.dart` - Service de téléchargement complet
- `lib/widgets/podcast_download_button.dart` - Widgets UI

---

## 🔄 Prochaines Améliorations

- [ ] Queue de téléchargement (plusieurs en parallèle)
- [ ] Téléchargement automatique des nouveaux épisodes
- [ ] Notification de fin de téléchargement
- [ ] Limite d'espace disque configurable
- [ ] Téléchargement uniquement en WiFi (option)
- [ ] Import/Export des téléchargements

---

**Bon téléchargement ! 📥**
