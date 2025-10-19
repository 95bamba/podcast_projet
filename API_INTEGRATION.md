# Intégration API - Galsen Podcast

Ce document décrit l'intégration de l'API backend avec l'application Flutter Galsen Podcast.

## API Base URL

```
http://51.254.204.25:2000
```

## Architecture Implémentée

L'application utilise maintenant une architecture BLoC (Business Logic Component) avec les couches suivantes :

### 1. Models (`lib/models/`)
- `user.dart` - Modèle utilisateur
- `category.dart` - Modèle catégorie
- `podcast.dart` - Modèle podcast
- `episode.dart` - Modèle épisode

### 2. Services (`lib/services/`)
- `api_service.dart` - Service HTTP avec gestion du token JWT
- `auth_service.dart` - Service d'authentification
- `audio_download_service.dart` - Service de téléchargement (existant)

### 3. Repositories (`lib/repositories/`)
- `category_repository.dart` - Gestion CRUD des catégories
- `podcast_repository.dart` - Gestion CRUD des podcasts

### 4. BLoCs (`lib/bloc/`)
- `auth/` - BLoC d'authentification (login, signup, logout)
- `category/` - BLoC de gestion des catégories
- `podcast/` - BLoC de gestion des podcasts

## Endpoints API

### Authentification

#### Inscription
```
POST /users/createUser
Content-Type: multipart/form-data

Fields:
- login: string (obligatoire)
- firstname: string (obligatoire)
- name: string (obligatoire)
- email: string (obligatoire)
- password_hash: string (obligatoire)
- file: binary (optionnel) - Photo de profil
```

#### Connexion
```
POST /auth/login
Content-Type: application/json

Body:
{
  "login": "string",
  "password_hash": "string"
}

Response:
{
  "access_token": "eyJhbGci...",
  "user": {
    "login": "string",
    "firstname": "string",
    "email": "string",
    "profileImgPath": "string|null",
    "accountState": number
  }
}
```

### Catégories

#### Récupérer toutes les catégories
```
GET /category
Authorization: Bearer {token}

Response: Category[]
```

#### Récupérer une catégorie
```
GET /category/:uuid
Authorization: Bearer {token}

Response: Category
```

#### Créer une catégorie
```
POST /category
Authorization: Bearer {token}
Content-Type: multipart/form-data

Fields:
- libelle: string
- description: string
- file: binary (optionnel) - Image de la catégorie
```

#### Modifier une catégorie
```
PUT /category/:uuid
Authorization: Bearer {token}
Content-Type: multipart/form-data

Fields:
- libelle: string
- description: string
- file: binary (optionnel)
```

#### Supprimer une catégorie
```
DELETE /category/:uuid
Authorization: Bearer {token}
```

### Podcasts

#### Récupérer tous les podcasts
```
GET /podcast
Authorization: Bearer {token}

Response: Podcast[]
```

#### Récupérer les podcasts d'une catégorie
```
GET /podcast/category/:categoryUuid
Authorization: Bearer {token}

Response: Podcast[]
```

#### Récupérer un podcast
```
GET /podcast/:uuid
Authorization: Bearer {token}

Response: Podcast
```

#### Créer un podcast
```
POST /podcast
Authorization: Bearer {token}
Content-Type: multipart/form-data

Fields:
- libelle: string
- description: string
- category_uuid: string (UUID de la catégorie)
- file: binary (optionnel) - Image du podcast
```

#### Modifier un podcast
```
PUT /podcast/:uuid
Authorization: Bearer {token}
Content-Type: multipart/form-data

Fields:
- libelle: string
- description: string
- category_uuid: string
- file: binary (optionnel)
```

#### Supprimer un podcast
```
DELETE /podcast/:uuid
Authorization: Bearer {token}
```

## Utilisation dans l'Application

### 1. Authentification

#### Login
```dart
// Dans votre page
context.read<AuthBloc>().add(
  AuthLoginRequested(
    login: 'username',
    password: 'password',
  ),
);

// Écouter les changements d'état
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // L'utilisateur est connecté
      // Naviguer vers la page d'accueil
    } else if (state is AuthError) {
      // Afficher le message d'erreur
      print(state.message);
    }
  },
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    // ...
  },
)
```

#### Signup
```dart
context.read<AuthBloc>().add(
  AuthSignupRequested(
    login: 'username',
    firstname: 'John',
    name: 'Doe',
    email: 'john@example.com',
    password: 'password123',
    profileImage: File('/path/to/image.jpg'), // optionnel
  ),
);
```

#### Logout
```dart
context.read<AuthBloc>().add(AuthLogoutRequested());
```

### 2. Gestion des Catégories

#### Charger les catégories
```dart
// Déclencher le chargement
context.read<CategoryBloc>().add(CategoryLoadRequested());

// Écouter les changements
BlocBuilder<CategoryBloc, CategoryState>(
  builder: (context, state) {
    if (state is CategoryLoading) {
      return CircularProgressIndicator();
    } else if (state is CategoryLoaded) {
      final categories = state.categories;
      return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category.libelle),
            subtitle: Text(category.description),
          );
        },
      );
    } else if (state is CategoryError) {
      return Text(state.message);
    }
    return Container();
  },
)
```

#### Créer une catégorie
```dart
context.read<CategoryBloc>().add(
  CategoryCreateRequested(
    libelle: 'Sport',
    description: 'Catégorie sport',
    image: File('/path/to/image.jpg'), // optionnel
  ),
);
```

### 3. Gestion des Podcasts

#### Charger tous les podcasts
```dart
context.read<PodcastBloc>().add(PodcastLoadAllRequested());
```

#### Charger les podcasts d'une catégorie
```dart
context.read<PodcastBloc>().add(
  PodcastLoadByCategoryRequested('category-uuid-here'),
);
```

#### Créer un podcast
```dart
context.read<PodcastBloc>().add(
  PodcastCreateRequested(
    libelle: 'Mon Podcast',
    description: 'Description du podcast',
    categoryUuid: 'category-uuid-here',
    image: File('/path/to/image.jpg'), // optionnel
  ),
);
```

## Gestion du Token JWT

Le token JWT est automatiquement géré par `ApiService` :

1. **Stockage** : Le token est sauvegardé dans `SharedPreferences` après une connexion réussie
2. **Injection** : Le token est automatiquement ajouté dans l'en-tête `Authorization: Bearer {token}` de chaque requête
3. **Expiration** : Si une requête retourne un code 401, le token est automatiquement supprimé
4. **Persistance** : Le token persiste entre les redémarrages de l'application

## Structure des Dossiers

```
lib/
├── bloc/
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── category/
│   │   ├── category_bloc.dart
│   │   ├── category_event.dart
│   │   └── category_state.dart
│   └── podcast/
│       ├── podcast_bloc.dart
│       ├── podcast_event.dart
│       └── podcast_state.dart
├── models/
│   ├── user.dart
│   ├── category.dart
│   ├── podcast.dart
│   └── episode.dart
├── repositories/
│   ├── category_repository.dart
│   └── podcast_repository.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── audio_download_service.dart
├── login_page.dart
├── signup_page.dart
└── main.dart
```

## Dépendances Ajoutées

```yaml
dependencies:
  flutter_bloc: ^8.1.3      # Gestion d'état BLoC
  equatable: ^2.0.5         # Comparaison d'objets
  shared_preferences: ^2.2.2 # Stockage local
  image_picker: ^1.0.7      # Sélection d'images
  dio: ^5.4.0              # Client HTTP (déjà présent)
```

## Lecture Audio depuis l'API

### API de Récupération Audio (GED)

L'API utilise un système de GED (Gestion Électronique de Documents) pour servir les fichiers audio.

#### Streaming Audio

```
GET /ged/preview?uuid={podcast_uuid}
```

Utilisé pour la **lecture en ligne** (streaming).

#### Téléchargement Audio

```
GET /ged/download?uuid={podcast_uuid}
```

Utilisé pour le **téléchargement local**.

**Important** : L'UUID utilisé est celui du **podcast**, pas d'un fichier séparé.

**Headers requis** : `Authorization: Bearer {jwt_token}`

### MediaService

Un service `MediaService` a été créé pour construire les URLs :

```dart
import 'package:podcast/services/media_service.dart';

// Streaming audio (lecture en ligne)
final streamUrl = MediaService.getAudioStreamUrl(podcast.audioFileUuid);
// → http://51.254.204.25:2000/ged/preview?uuid=dc82e38d...

// Téléchargement audio
final downloadUrl = MediaService.getAudioDownloadUrl(podcast.audioFileUuid);
// → http://51.254.204.25:2000/ged/download?uuid=dc82e38d...

// Alias (rétrocompatibilité) - équivalent à getAudioStreamUrl
final audioUrl = MediaService.getAudioUrl(podcast.audioFileUuid);

// URL d'une image
final imageUrl = MediaService.getImageUrl(podcast.imagePath);
// → http://51.254.204.25:2000/uploads/image.jpg
```

### Exemple de Lecture Audio

```dart
import 'package:just_audio/just_audio.dart';
import 'package:podcast/services/media_service.dart';

final audioPlayer = AudioPlayer();

// Charger et jouer l'audio
Future<void> playPodcast(Podcast podcast) async {
  final audioUrl = MediaService.getAudioUrl(podcast.audioFileUuid);

  if (audioUrl.isNotEmpty) {
    await audioPlayer.setUrl(audioUrl);
    await audioPlayer.play();
  }
}
```

### Page de Détail avec Lecteur Audio

Une page complète `PodcastDetailPageWithAudio` a été créée comme exemple :

```dart
import 'package:podcast/podcast_detail_page.dart';

// Navigation vers la page de détail
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PodcastDetailPageWithAudio(
      podcast: podcast,
    ),
  ),
);
```

Cette page inclut :
- Affichage de l'image du podcast
- Lecteur audio avec contrôles (play/pause, seek, +10s, -10s)
- Affichage de la progression
- Gestion des erreurs
- Debug info (UUID et URL de l'API)

## Prochaines Étapes

Pour adapter complètement l'application à l'API :

1. **Adapter home_page.dart** pour charger les catégories depuis l'API au lieu des données hardcodées
2. **Créer des pages d'administration** pour gérer les catégories et podcasts
3. **Ajouter la gestion des favoris** avec API backend
4. **Implémenter la recherche** avec API backend
5. **Intégrer le lecteur audio** dans toutes les pages de l'application

## Notes Importantes

- Le serveur API utilise `password_hash` comme nom de champ pour le mot de passe
- Les fichiers uploadés (images, audio) utilisent `multipart/form-data`
- Toutes les requêtes (sauf login et signup) nécessitent le token JWT
- Les UUIDs sont utilisés comme identifiants pour toutes les entités
- Les images/fichiers du serveur sont accessibles via un chemin relatif stocké dans `imagePath` ou `audioPath`
