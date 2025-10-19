import 'dart:io';
import 'package:podcast/models/podcast.dart';
import 'package:podcast/services/api_service.dart';

class PodcastRepository {
  final ApiService _apiService;

  PodcastRepository(this._apiService);

  Future<List<Podcast>> getAllPodcasts() async {
    try {
      final response = await _apiService.get('/podcast');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Podcast.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load podcasts');
      }
    } catch (e) {
      throw Exception('Error loading podcasts: $e');
    }
  }

  Future<List<Podcast>> getPodcastsByCategory(String categoryUuid) async {
    try {
      print('DEBUG: Fetching podcasts for category: $categoryUuid');

      // L'API attend category_uuid dans le corps de la requête POST
      final response = await _apiService.post(
        '/podcast/getPodcastCategory',
        data: {
          'category_uuid': categoryUuid,
        },
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response data: ${response.data}');

      // Accepter les codes 200 et 201 (Created)
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic responseData = response.data;

        // Vérifier si la réponse est directement une liste ou un objet avec une liste
        if (responseData is List) {
          print('DEBUG: Response is a List with ${responseData.length} items');
          return responseData.map((json) => Podcast.fromJson(json)).toList();
        } else if (responseData is Map && responseData['data'] != null) {
          print('DEBUG: Response is a Map, extracting data field');
          final List<dynamic> data = responseData['data'];
          return data.map((json) => Podcast.fromJson(json)).toList();
        } else {
          print('DEBUG: Unexpected response format: ${responseData.runtimeType}');
          throw Exception('Unexpected response format from API');
        }
      } else {
        throw Exception('API returned status code ${response.statusCode}: ${response.data}');
      }
    } catch (e) {
      print('DEBUG: Error caught: $e');
      throw Exception('Error loading podcasts: $e');
    }
  }

  Future<Podcast> getPodcastById(String uuid) async {
    try {
      final response = await _apiService.get('/podcast/$uuid');

      if (response.statusCode == 200) {
        return Podcast.fromJson(response.data);
      } else {
        throw Exception('Failed to load podcast');
      }
    } catch (e) {
      throw Exception('Error loading podcast: $e');
    }
  }

  Future<Podcast> createPodcast({
    required String libelle,
    required String description,
    required String categoryUuid,
    File? image,
  }) async {
    try {
      final fields = {
        'libelle': libelle,
        'description': description,
        'category_uuid': categoryUuid,
      };

      final response = await _apiService.uploadFile(
        '/podcast',
        fields,
        image,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Podcast.fromJson(response.data);
      } else {
        throw Exception('Failed to create podcast');
      }
    } catch (e) {
      throw Exception('Error creating podcast: $e');
    }
  }

  Future<Podcast> updatePodcast({
    required String uuid,
    required String libelle,
    required String description,
    required String categoryUuid,
    File? image,
  }) async {
    try {
      final fields = {
        'libelle': libelle,
        'description': description,
        'category_uuid': categoryUuid,
      };

      final response = await _apiService.uploadFile(
        '/podcast/$uuid',
        fields,
        image,
      );

      if (response.statusCode == 200) {
        return Podcast.fromJson(response.data);
      } else {
        throw Exception('Failed to update podcast');
      }
    } catch (e) {
      throw Exception('Error updating podcast: $e');
    }
  }

  Future<void> deletePodcast(String uuid) async {
    try {
      final response = await _apiService.delete('/podcast/$uuid');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete podcast');
      }
    } catch (e) {
      throw Exception('Error deleting podcast: $e');
    }
  }
}
