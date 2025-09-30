import 'package:flutter/material.dart';
import '../services/audio_download_service.dart';
import 'download_progress.dart';

class AudioControls extends StatefulWidget {
  final String audioUrl;
  final String fileName;
  final VoidCallback onPlay;

  const AudioControls({
    Key? key,
    required this.audioUrl,
    required this.fileName,
    required this.onPlay,
  }) : super(key: key);

  @override
  State<AudioControls> createState() => _AudioControlsState();
}

class _AudioControlsState extends State<AudioControls> {
  final AudioDownloadService _downloadService = AudioDownloadService();
  bool _isDownloading = false;
  double _downloadProgress = 0;
  String? _localFilePath;

  Future<void> _downloadAudio() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      final success = await _downloadService.downloadAudio(
        widget.audioUrl,
        widget.fileName,
        onProgress: (progress) {
          setState(() {
            _downloadProgress = progress;
          });
        },
      );

      if (success) {
        setState(() {
          _localFilePath = widget.fileName; // Stocker le nom du fichier comme référence
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Téléchargement terminé'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec du téléchargement'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du téléchargement: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> _deleteAudio() async {
    if (_localFilePath == null) return;

    try {
      final success = await _downloadService.deleteAudio(_localFilePath!);
      if (success) {
        setState(() {
          _localFilePath = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fichier audio supprimé'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isDownloading)
          DownloadProgress(
            progress: _downloadProgress,
            fileName: widget.fileName,
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_localFilePath == null)
              ElevatedButton.icon(
                onPressed: _downloadAudio,
                icon: const Icon(Icons.download),
                label: const Text('Télécharger'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              )
            else ...[
              ElevatedButton.icon(
                onPressed: widget.onPlay,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Lire'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _deleteAudio,
                icon: const Icon(Icons.delete),
                color: Colors.red,
                tooltip: 'Supprimer',
              ),
            ],
          ],
        ),
      ],
    );
  }
} 