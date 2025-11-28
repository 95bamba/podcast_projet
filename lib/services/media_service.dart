import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service pour gérer les URLs des médias (images, audio) depuis le serveur
class MediaService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://51.254.204.25:2000';

  /// Construit l'URL complète pour le streaming audio à partir de son UUID
  /// Exemple: http://51.254.204.25:2000/ged/preview?uuid=dc82e38d-9627-454f-84c2-b3a6a1009138
  static String getAudioStreamUrl(String? fileUuid) {
    if (fileUuid == null || fileUuid.isEmpty) {
      return '';
    }
    return '$baseUrl/ged/preview?uuid=$fileUuid';
  }

  /// Construit l'URL complète pour le téléchargement audio à partir de son UUID
  /// Exemple: http://51.254.204.25:2000/ged/download?uuid=dc82e38d-9627-454f-84c2-b3a6a1009138
  static String getAudioDownloadUrl(String? fileUuid) {
    if (fileUuid == null || fileUuid.isEmpty) {
      return '';
    }
    return '$baseUrl/ged/download?uuid=$fileUuid';
  }

  /// Alias pour getAudioStreamUrl (rétrocompatibilité)
  static String getAudioUrl(String? fileUuid) {
    return getAudioStreamUrl(fileUuid);
  }

  /// Construit l'URL complète pour une image à partir de son chemin relatif
  /// Exemple: http://51.254.204.25:2000/uploads/image.jpg
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // Si le chemin commence déjà par http, le retourner tel quel
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Sinon, construire l'URL complète
    // Retirer le / initial si présent
    final path = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$baseUrl/$path';
  }

  /// Vérifie si une URL audio est valide
  static bool isValidAudioUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    return url.contains('/ged/preview?uuid=') || url.startsWith('http');
  }

  /// Vérifie si une URL image est valide
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    return url.startsWith('http');
  }
}
