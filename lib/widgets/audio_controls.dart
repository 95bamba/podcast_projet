import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/audio_download_service.dart';
import '../repositories/episode_repository.dart';
import 'download_progress.dart';

class AudioControls extends StatefulWidget {
  final String? audioFileUuid;  // UUID du fichier dans GED
  final String fileName;
  final VoidCallback onPlay;

  const AudioControls({
    Key? key,
    this.audioFileUuid,  // Peut être null si pas de fichier audio
    required this.fileName,
    required this.onPlay,
  }) : super(key: key);

  @override
  State<AudioControls> createState() => _AudioControlsState();
}

class _AudioControlsState extends State<AudioControls> {
  AudioDownloadService? _downloadService;
  bool _isDownloading = false;
  double _downloadProgress = 0;
  String? _localFilePath;
  bool _isDownloaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialiser le service de téléchargement avec le repository
    if (_downloadService == null) {
      final episodeRepo = context.read<EpisodeRepository>();
      _downloadService = AudioDownloadService(episodeRepository: episodeRepo);
      // Vérifier si le fichier est déjà téléchargé
      _checkIfDownloaded();
    }
  }

  Future<void> _checkIfDownloaded() async {
    if (_downloadService != null) {
      final isDownloaded = await _downloadService!.isAudioDownloaded(widget.fileName);
      if (mounted) {
        setState(() {
          _isDownloaded = isDownloaded;
          if (isDownloaded) {
            _localFilePath = widget.fileName;
          }
        });
      }
    }
  }

  Future<void> _downloadAudio() async {
    if (_isDownloading || _downloadService == null) return;

    // Vérifier que nous avons un UUID de fichier
    if (widget.audioFileUuid == null || widget.audioFileUuid!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun fichier audio disponible pour cet épisode'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      // Utiliser la nouvelle méthode downloadAudioFromGED
      final success = await _downloadService!.downloadAudioFromGED(
        widget.audioFileUuid!,
        widget.fileName,
        onProgress: (progress) {
          setState(() {
            _downloadProgress = progress;
          });
        },
      );

      if (success) {
        setState(() {
          _localFilePath = widget.fileName;
          _isDownloaded = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Téléchargement terminé'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Échec du téléchargement'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du téléchargement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> _deleteAudio() async {
    if (_localFilePath == null || _downloadService == null) return;

    try {
      final success = await _downloadService!.deleteAudio(_localFilePath!);
      if (success) {
        setState(() {
          _localFilePath = null;
          _isDownloaded = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fichier audio supprimé'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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