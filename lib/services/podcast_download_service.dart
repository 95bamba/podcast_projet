import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast/services/media_service.dart';
import 'package:podcast/services/api_service.dart';

/// Service pour télécharger les podcasts depuis l'API GED
class PodcastDownloadService {
  final ApiService _apiService;
  final Dio _dio;

  PodcastDownloadService(this._apiService) : _dio = Dio();

  /// Récupère le répertoire de téléchargement
  Future<Directory> _getDownloadDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${appDir.path}/podcast_downloads');

    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    return downloadDir;
  }

  /// Génère un nom de fichier sécurisé à partir de l'UUID et du titre
  String _sanitizeFileName(String podcastTitle, String uuid) {
    // Nettoyer le titre
    final cleanTitle = podcastTitle
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();

    // Prendre les 8 premiers caractères de l'UUID
    final shortUuid = uuid.substring(0, 8);

    return '${cleanTitle}_$shortUuid.mp3';
  }

  /// Télécharge un podcast depuis l'API GED
  ///
  /// [podcastUuid] - UUID du podcast
  /// [podcastTitle] - Titre du podcast (pour le nom de fichier)
  /// [onProgress] - Callback de progression (0.0 à 1.0)
  ///
  /// Retourne le chemin du fichier téléchargé
  Future<String> downloadPodcast({
    required String podcastUuid,
    required String podcastTitle,
    void Function(double progress)? onProgress,
  }) async {
    try {
      // Construire l'URL de téléchargement
      final downloadUrl = MediaService.getAudioDownloadUrl(podcastUuid);

      if (downloadUrl.isEmpty) {
        throw Exception('UUID du podcast invalide');
      }

      // Récupérer le répertoire de téléchargement
      final downloadDir = await _getDownloadDirectory();

      // Créer le nom de fichier
      final fileName = _sanitizeFileName(podcastTitle, podcastUuid);
      final filePath = '${downloadDir.path}/$fileName';

      // Vérifier si le fichier existe déjà
      if (await File(filePath).exists()) {
        return filePath; // Déjà téléchargé
      }

      // Récupérer le token pour l'authentification
      final token = _apiService.token;

      if (token == null) {
        throw Exception('Non authentifié - veuillez vous connecter');
      }

      // Télécharger le fichier avec progression
      await _dio.download(
        downloadUrl,
        filePath,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          receiveTimeout: const Duration(minutes: 10),
        ),
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            final progress = received / total;
            onProgress(progress);
          }
        },
      );

      return filePath;
    } catch (e) {
      throw Exception('Erreur de téléchargement: $e');
    }
  }

  /// Vérifie si un podcast est déjà téléchargé
  Future<bool> isPodcastDownloaded(String podcastUuid, String podcastTitle) async {
    try {
      final downloadDir = await _getDownloadDirectory();
      final fileName = _sanitizeFileName(podcastTitle, podcastUuid);
      final filePath = '${downloadDir.path}/$fileName';

      return await File(filePath).exists();
    } catch (e) {
      return false;
    }
  }

  /// Récupère le chemin du fichier téléchargé
  Future<String?> getDownloadedFilePath(String podcastUuid, String podcastTitle) async {
    try {
      final downloadDir = await _getDownloadDirectory();
      final fileName = _sanitizeFileName(podcastUuid, podcastTitle);
      final filePath = '${downloadDir.path}/$fileName';

      if (await File(filePath).exists()) {
        return filePath;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Supprime un podcast téléchargé
  Future<void> deleteDownloadedPodcast(String podcastUuid, String podcastTitle) async {
    try {
      final downloadDir = await _getDownloadDirectory();
      final fileName = _sanitizeFileName(podcastTitle, podcastUuid);
      final file = File('${downloadDir.path}/$fileName');

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Erreur de suppression: $e');
    }
  }

  /// Récupère la taille d'un fichier téléchargé (en bytes)
  Future<int?> getDownloadedFileSize(String podcastUuid, String podcastTitle) async {
    try {
      final downloadDir = await _getDownloadDirectory();
      final fileName = _sanitizeFileName(podcastTitle, podcastUuid);
      final file = File('${downloadDir.path}/$fileName');

      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Liste tous les podcasts téléchargés
  Future<List<String>> getDownloadedPodcasts() async {
    try {
      final downloadDir = await _getDownloadDirectory();
      final files = downloadDir.listSync();

      return files
          .where((file) => file is File && file.path.endsWith('.mp3'))
          .map((file) => file.path)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Récupère l'espace total utilisé par les téléchargements (en bytes)
  Future<int> getTotalDownloadSize() async {
    try {
      final files = await getDownloadedPodcasts();
      int totalSize = 0;

      for (final filePath in files) {
        final file = File(filePath);
        if (await file.exists()) {
          totalSize += await file.length();
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Supprime tous les podcasts téléchargés
  Future<void> clearAllDownloads() async {
    try {
      final downloadDir = await _getDownloadDirectory();

      if (await downloadDir.exists()) {
        await downloadDir.delete(recursive: true);
        await downloadDir.create(recursive: true);
      }
    } catch (e) {
      throw Exception('Erreur de nettoyage: $e');
    }
  }

  /// Formate une taille en bytes en format lisible
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
