import 'package:podcast/models/favorite.dart';
import 'package:podcast/services/api_service.dart';

class FavoriteService {
  final ApiService _apiService;

  FavoriteService(this._apiService);

  /// Create a new favorite
  /// Payload: { "user_login": "string", "episode_uuid": "string" }
  Future<Map<String, dynamic>> createFavorite({
    required String userLogin,
    required String episodeUuid,
  }) async {
    try {
      final response = await _apiService.post(
        '/favoris/createFavori',
        data: {
          'user_login': userLogin,
          'episode_uuid': episodeUuid,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data == null) {
          return {
            'success': false,
            'message': 'Réponse invalide du serveur',
          };
        }

        // Parse favorite from response
        Favorite? favorite;
        if (data is Map<String, dynamic>) {
          try {
            favorite = Favorite.fromJson(data);
          } catch (e) {
            // If parsing fails, continue without favorite object
          }
        }

        return {
          'success': true,
          'message': 'Favori ajouté avec succès',
          if (favorite != null) 'favorite': favorite,
        };
      } else if (response.statusCode == 409) {
        return {
          'success': false,
          'message': 'Ce favori existe déjà',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout du favori',
        };
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('409') || errorMessage.contains('Conflict')) {
        return {
          'success': false,
          'message': 'Ce favori existe déjà',
        };
      }

      return {
        'success': false,
        'message': 'Erreur de connexion: ${errorMessage.length > 100 ? errorMessage.substring(0, 100) : errorMessage}',
      };
    }
  }

  /// Get all favorites for a user
  /// GET /favoris/getAllFavoris?user_login=xxx
  Future<Map<String, dynamic>> getAllFavorites(String userLogin) async {
    try {
      final response = await _apiService.get(
        '/favoris/getAllFavoris',
        queryParameters: {'user_login': userLogin},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data == null) {
          return {
            'success': false,
            'message': 'Réponse invalide du serveur',
          };
        }

        List<Favorite> favorites = [];

        if (data is List) {
          for (var item in data) {
            if (item is Map<String, dynamic>) {
              try {
                favorites.add(Favorite.fromJson(item));
              } catch (e) {
                // Skip invalid items
                print('Error parsing favorite: $e');
              }
            }
          }
        }

        return {
          'success': true,
          'favorites': favorites,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des favoris',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Get a specific favorite by UUID
  /// GET /favoris/getFavoriByUuid?uuid=xxx
  Future<Map<String, dynamic>> getFavoriteByUuid(String uuid) async {
    try {
      final response = await _apiService.get(
        '/favoris/getFavoriByUuid',
        queryParameters: {'uuid': uuid},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data == null) {
          return {
            'success': false,
            'message': 'Réponse invalide du serveur',
          };
        }

        Favorite? favorite;
        if (data is Map<String, dynamic>) {
          try {
            favorite = Favorite.fromJson(data);
          } catch (e) {
            return {
              'success': false,
              'message': 'Erreur lors du parsing des données',
            };
          }
        }

        return {
          'success': true,
          'favorite': favorite,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Favori non trouvé',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération du favori',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Update a favorite
  /// PUT /favoris/updateFavori
  /// Body: { "uuid": "string", "user_login": "string", "episode_uuid": "string" }
  Future<Map<String, dynamic>> updateFavorite({
    required String uuid,
    required String userLogin,
    required String episodeUuid,
  }) async {
    try {
      final response = await _apiService.put(
        '/favoris/updateFavori',
        data: {
          'uuid': uuid,
          'user_login': userLogin,
          'episode_uuid': episodeUuid,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        Favorite? favorite;
        if (data != null && data is Map<String, dynamic>) {
          try {
            favorite = Favorite.fromJson(data);
          } catch (e) {
            // If parsing fails, continue without favorite object
          }
        }

        return {
          'success': true,
          'message': 'Favori mis à jour avec succès',
          if (favorite != null) 'favorite': favorite,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Favori non trouvé',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la mise à jour du favori',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Delete a favorite
  /// DELETE /favoris/deleteFavori?uuid=xxx
  Future<Map<String, dynamic>> deleteFavorite(String uuid) async {
    try {
      final response = await _apiService.delete(
        '/favoris/deleteFavori?uuid=$uuid',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Favori supprimé avec succès',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Favori non trouvé',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la suppression du favori',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Check if an episode is in favorites
  /// Helper method to check if user has favorited an episode
  Future<bool> isFavorited({
    required String userLogin,
    required String episodeUuid,
  }) async {
    try {
      final result = await getAllFavorites(userLogin);

      if (result['success'] == true && result['favorites'] != null) {
        final List<Favorite> favorites = result['favorites'];
        return favorites.any((fav) => fav.episodeUuid == episodeUuid);
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get favorite UUID by user and episode
  /// Helper method to find a favorite's UUID
  Future<String?> getFavoriteUuid({
    required String userLogin,
    required String episodeUuid,
  }) async {
    try {
      final result = await getAllFavorites(userLogin);

      if (result['success'] == true && result['favorites'] != null) {
        final List<Favorite> favorites = result['favorites'];
        final favorite = favorites.firstWhere(
          (fav) => fav.episodeUuid == episodeUuid,
          orElse: () => const Favorite(
            uuid: '',
            userLogin: '',
            episodeUuid: '',
          ),
        );
        return favorite.uuid.isEmpty ? null : favorite.uuid;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
