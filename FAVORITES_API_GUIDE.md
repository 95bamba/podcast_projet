# Favorites API Integration Guide

This guide explains how to use the favorites CRUD functionality in the Galsen Podcast app.

## Overview

The favorites system allows users to save their favorite podcast episodes. The implementation includes:

1. **Favorite Model** (`lib/models/favorite.dart`) - Data model for favorites
2. **FavoriteService** (`lib/services/favorite_service.dart`) - API service for CRUD operations
3. **FavoritesPage** (`lib/favorites_page.dart`) - Updated to use the API
4. **FavoriteButton Widget** (`lib/widgets/favorite_button.dart`) - Reusable widget for adding/removing favorites

## API Endpoints

Base URL: `http://51.254.204.25:2000`

### 1. Create Favorite
```
POST /favoris/createFavori
```

**Payload:**
```json
{
  "user_login": "string",
  "episode_uuid": "string"
}
```

**Response (201):**
```json
{
  "uuid": "string",
  "user_login": "string",
  "episode_uuid": "string",
  "createdAt": "ISO8601 datetime",
  "updatedAt": "ISO8601 datetime"
}
```

### 2. Get All Favorites
```
GET /favoris/getAllFavoris?user_login=xxx
```

**Response (200):**
```json
[
  {
    "uuid": "string",
    "user_login": "string",
    "episode_uuid": "string",
    "episode": {
      "uuid": "string",
      "title": "string",
      "description": "string",
      "audioPath": "string",
      "duration": "string",
      ...
    },
    "createdAt": "ISO8601 datetime",
    "updatedAt": "ISO8601 datetime"
  }
]
```

### 3. Get Favorite by UUID
```
GET /favoris/getFavoriByUuid?uuid=xxx
```

**Response (200):**
```json
{
  "uuid": "string",
  "user_login": "string",
  "episode_uuid": "string",
  ...
}
```

### 4. Update Favorite
```
PUT /favoris/updateFavori
```

**Payload:**
```json
{
  "uuid": "string",
  "user_login": "string",
  "episode_uuid": "string"
}
```

### 5. Delete Favorite
```
DELETE /favoris/deleteFavori?uuid=xxx
```

**Response (200 or 204):**
Success - no content

## Usage Examples

### 1. Using FavoriteService Directly

```dart
import 'package:podcast/services/favorite_service.dart';
import 'package:podcast/services/api_service.dart';

// Initialize service
final favoriteService = FavoriteService(ApiService());

// Create a favorite
final result = await favoriteService.createFavorite(
  userLogin: 'john_doe',
  episodeUuid: 'episode-uuid-123',
);

if (result['success'] == true) {
  print('Favorite created: ${result['favorite']}');
} else {
  print('Error: ${result['message']}');
}

// Get all favorites for a user
final allFavorites = await favoriteService.getAllFavorites('john_doe');
if (allFavorites['success'] == true) {
  List<Favorite> favorites = allFavorites['favorites'];
  print('User has ${favorites.length} favorites');
}

// Delete a favorite
final deleteResult = await favoriteService.deleteFavorite('favorite-uuid');
if (deleteResult['success'] == true) {
  print('Favorite deleted');
}

// Check if episode is favorited
bool isFavorited = await favoriteService.isFavorited(
  userLogin: 'john_doe',
  episodeUuid: 'episode-uuid-123',
);
```

### 2. Using FavoriteButton Widget

The `FavoriteButton` widget is a ready-to-use component that handles all favorite logic automatically.

**Basic Usage:**
```dart
import 'package:podcast/widgets/favorite_button.dart';

FavoriteButton(
  episodeUuid: 'episode-uuid-123',
)
```

**Customized:**
```dart
FavoriteButton(
  episodeUuid: episode.uuid,
  size: 28,
  activeColor: Colors.red,
  inactiveColor: Colors.grey[400],
  onFavoriteChanged: () {
    // Callback when favorite status changes
    print('Favorite status changed!');
  },
)
```

**Example in Episode List:**
```dart
ListView.builder(
  itemCount: episodes.length,
  itemBuilder: (context, index) {
    final episode = episodes[index];
    return ListTile(
      title: Text(episode.title),
      subtitle: Text(episode.description),
      trailing: FavoriteButton(
        episodeUuid: episode.uuid,
        size: 24,
      ),
    );
  },
)
```

### 3. Getting Current User from AuthBloc

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcast/bloc/auth/auth_bloc.dart';
import 'package:podcast/bloc/auth/auth_state.dart';

// In a StatefulWidget or StatelessWidget with BuildContext
final authState = context.read<AuthBloc>().state;
if (authState is AuthAuthenticated && authState.user != null) {
  final userLogin = authState.user!.login;
  // Use userLogin for API calls
}
```

## Integration in Existing Pages

### Example: Adding Favorite Button to Episode Detail Page

```dart
import 'package:flutter/material.dart';
import 'package:podcast/widgets/favorite_button.dart';

class EpisodeDetailPage extends StatelessWidget {
  final Episode episode;

  const EpisodeDetailPage({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(episode.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: FavoriteButton(
              episodeUuid: episode.uuid,
              size: 28,
              onFavoriteChanged: () {
                // Optional: refresh UI or show notification
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Episode content...
        ],
      ),
    );
  }
}
```

## Updated Favorites Page

The `FavoritesPage` has been updated to:

1. **Load favorites from API** instead of hardcoded data
2. **Get user login from AuthBloc**
3. **Display loading states** while fetching data
4. **Show error messages** when API calls fail
5. **Delete favorites** via API
6. **Play audio** from episode's audioPath

**Features:**
- Pull-to-refresh support (can be added)
- Search/filter favorites by episode title
- Delete favorites with confirmation
- Play audio directly from favorites
- Error handling with user-friendly messages

## Error Handling

All service methods return a `Map<String, dynamic>` with:

```dart
{
  'success': bool,
  'message': String?, // Error message if success is false
  'favorite': Favorite?, // For create/update operations
  'favorites': List<Favorite>?, // For getAllFavorites
}
```

**Example:**
```dart
final result = await favoriteService.createFavorite(...);

if (result['success'] == true) {
  // Success!
  final favorite = result['favorite'];
} else {
  // Error
  final errorMessage = result['message'];
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(errorMessage)),
  );
}
```

## Data Models

### Favorite Model
```dart
class Favorite {
  final String uuid;
  final String userLogin;
  final String episodeUuid;
  final Episode? episode; // Full episode object if included by API
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

### Episode Model (nested in Favorite)
```dart
class Episode {
  final String uuid;
  final String title;
  final String description;
  final String podcastUuid;
  final String? audioPath;
  final String? duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

## Testing

To test the favorites functionality:

1. **Login** with a valid user account
2. **Navigate to any page** with episodes
3. **Click the favorite button** on an episode (use FavoriteButton widget)
4. **Go to Favorites page** to see your saved episodes
5. **Click the heart icon** to remove from favorites
6. **Search** for specific episodes in your favorites

## Authentication Requirements

- User must be logged in (authenticated via AuthBloc)
- User's login is automatically retrieved from AuthBloc state
- If user is not authenticated, favorite operations will fail gracefully

## Notes

- Favorites are stored on the server and persist across app sessions
- The API expects `user_login` (not user UUID)
- Episode data is optionally nested in favorite responses
- Audio playback uses the episode's `audioPath` field
- Full audio URL is constructed as: `{baseUrl}/files/getAudio?audioFileUuid={audioPath}`

## Future Enhancements

Consider adding:
1. Pull-to-refresh on Favorites page
2. Offline caching of favorites
3. Batch operations (favorite multiple episodes at once)
4. Sort favorites by date added, title, etc.
5. Favorite playlists or categories
6. Share favorites with other users
