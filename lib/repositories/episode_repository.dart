import 'package:podcast/models/episode.dart';
import 'package:podcast/services/api_service.dart';

class EpisodeRepository {
  final ApiService _apiService;

  EpisodeRepository(this._apiService);

  Future<List<Episode>> getAllEpisodesByPodcast(String podcastUuid) async {
    try {
      print('DEBUG: Fetching episodes for podcast: $podcastUuid');

      // L'API attend podcast_uuid dans le corps de la requête POST
      final response = await _apiService.post(
        '/episode/getAllEpisodeBypodcastUuid',
        data: {
          'podcast_uuid': podcastUuid,
        },
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response data: ${response.data}');

      // Accepter les codes 200 et 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic responseData = response.data;

        // Vérifier si la réponse est directement une liste ou un objet avec une liste
        if (responseData is List) {
          print('DEBUG: Response is a List with ${responseData.length} episodes');
          return responseData.map((json) => Episode.fromJson(json)).toList();
        } else if (responseData is Map && responseData['data'] != null) {
          print('DEBUG: Response is a Map, extracting data field');
          final List<dynamic> data = responseData['data'];
          return data.map((json) => Episode.fromJson(json)).toList();
        } else {
          print('DEBUG: Unexpected response format: ${responseData.runtimeType}');
          throw Exception('Unexpected response format from API');
        }
      } else {
        throw Exception('API returned status code ${response.statusCode}: ${response.data}');
      }
    } catch (e) {
      print('DEBUG: Error caught: $e');
      throw Exception('Error loading episodes: $e');
    }
  }

  Future<Episode> getEpisodeById(String uuid) async {
    try {
      final response = await _apiService.get('/episode/$uuid');

      if (response.statusCode == 200) {
        return Episode.fromJson(response.data);
      } else {
        throw Exception('Failed to load episode');
      }
    } catch (e) {
      throw Exception('Error loading episode: $e');
    }
  }

  /// Télécharge un fichier audio d'épisode via l'API GED
  /// Retourne les bytes du fichier audio
  Future<List<int>> downloadEpisodeAudio(String episodeUuid) async {
    try {
      print('DEBUG: Downloading audio for episode: $episodeUuid');

      // L'API attend l'UUID en query parameter
      final response = await _apiService.downloadFileWithQuery(
        '/ged/download',
        {'uuid': episodeUuid},
      );

      print('DEBUG: Download response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return response.data as List<int>;
      } else {
        throw Exception('Failed to download audio file: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Download error: $e');
      throw Exception('Error downloading audio: $e');
    }
  }
}
