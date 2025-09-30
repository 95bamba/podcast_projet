import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AudioDownloadService {
  Future<bool> downloadAudio(
    String url,
    String fileName, {
    void Function(double)? onProgress,
  }) async {
    try {
      debugPrint('Début du téléchargement: $url');
      debugPrint('Nom du fichier: $fileName');

      // Vérifier si l'URL est valide
      if (!Uri.parse(url).isAbsolute) {
        debugPrint('URL invalide: $url');
        return false;
      }

      // Obtenir le répertoire de téléchargement
      final appDir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${appDir.path}/downloads');
      debugPrint('Dossier de téléchargement: ${downloadsDir.path}');

      // Créer le dossier s'il n'existe pas
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
        debugPrint('Dossier de téléchargement créé');
      }

      final file = File('${downloadsDir.path}/$fileName');
      debugPrint('Chemin du fichier: ${file.path}');

      // Vérifier si le fichier existe déjà
      if (await file.exists()) {
        debugPrint('Le fichier existe déjà');
        return true;
      }

      // Télécharger le fichier
      debugPrint('Envoi de la requête HTTP...');
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          debugPrint('Timeout de la requête HTTP');
          throw TimeoutException('Le téléchargement a pris trop de temps');
        },
      );
      
      debugPrint('Code de statut HTTP: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        // Écrire le fichier
        debugPrint('Écriture du fichier...');
        await file.writeAsBytes(response.bodyBytes);
        debugPrint('Fichier écrit avec succès');
        
        if (onProgress != null) {
          onProgress(100.0);
        }
        
        return true;
      }

      debugPrint('Échec du téléchargement: Code ${response.statusCode}');
      return false;
    } catch (e, stackTrace) {
      debugPrint('Erreur lors du téléchargement: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> deleteAudio(String fileName) async {
    try {
      debugPrint('Suppression du fichier: $fileName');
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/downloads/$fileName');
      
      if (await file.exists()) {
        await file.delete();
        debugPrint('Fichier supprimé avec succès');
        return true;
      }
      debugPrint('Le fichier n\'existe pas');
      return false;
    } catch (e, stackTrace) {
      debugPrint('Erreur lors de la suppression: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  // Méthode pour vérifier si un fichier est déjà téléchargé
  Future<bool> isAudioDownloaded(String fileName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/downloads/$fileName');
      return await file.exists();
    } catch (e) {
      debugPrint('Erreur lors de la vérification du fichier: $e');
      return false;
    }
  }
} 