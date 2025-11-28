import 'package:flutter/material.dart';
import 'package:podcast/models/podcast.dart';
import 'package:podcast/services/podcast_download_service.dart';

/// Widget de bouton de téléchargement pour un podcast
/// Affiche l'état : Non téléchargé → En téléchargement → Téléchargé
class PodcastDownloadButton extends StatefulWidget {
  final Podcast podcast;
  final PodcastDownloadService downloadService;
  final VoidCallback? onDownloadComplete;
  final VoidCallback? onDeleteComplete;

  const PodcastDownloadButton({
    super.key,
    required this.podcast,
    required this.downloadService,
    this.onDownloadComplete,
    this.onDeleteComplete,
  });

  @override
  State<PodcastDownloadButton> createState() => _PodcastDownloadButtonState();
}

class _PodcastDownloadButtonState extends State<PodcastDownloadButton> {
  bool _isDownloaded = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkDownloadStatus();
  }

  Future<void> _checkDownloadStatus() async {
    final isDownloaded = await widget.downloadService.isPodcastDownloaded(
      widget.podcast.uuid,
      widget.podcast.libelle,
    );

    if (mounted) {
      setState(() {
        _isDownloaded = isDownloaded;
      });
    }
  }

  Future<void> _startDownload() async {
    if (widget.podcast.audioFileUuid == null) {
      setState(() {
        _errorMessage = 'Pas de fichier audio disponible';
      });
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _errorMessage = null;
    });

    try {
      await widget.downloadService.downloadPodcast(
        podcastUuid: widget.podcast.uuid,
        podcastTitle: widget.podcast.libelle,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _downloadProgress = progress;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _isDownloading = false;
          _isDownloaded = true;
          _downloadProgress = 1.0;
        });

        widget.onDownloadComplete?.call();

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('${widget.podcast.libelle} téléchargé'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _errorMessage = e.toString();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteDownload() async {
    // Demander confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le téléchargement'),
        content: Text('Voulez-vous supprimer ${widget.podcast.libelle} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await widget.downloadService.deleteDownloadedPodcast(
        widget.podcast.uuid,
        widget.podcast.libelle,
      );

      if (mounted) {
        setState(() {
          _isDownloaded = false;
        });

        widget.onDeleteComplete?.call();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Téléchargement supprimé'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDownloading) {
      return _buildDownloadingState();
    } else if (_isDownloaded) {
      return _buildDownloadedState();
    } else {
      return _buildNotDownloadedState();
    }
  }

  Widget _buildNotDownloadedState() {
    return IconButton(
      icon: const Icon(Icons.download_outlined),
      color: Colors.grey[600],
      onPressed: _startDownload,
      tooltip: 'Télécharger',
    );
  }

  Widget _buildDownloadingState() {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: _downloadProgress,
            strokeWidth: 3,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
          ),
          Text(
            '${(_downloadProgress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadedState() {
    return IconButton(
      icon: const Icon(Icons.download_done),
      color: Colors.green,
      onPressed: _deleteDownload,
      tooltip: 'Téléchargé (appuyer pour supprimer)',
    );
  }
}

/// Widget de badge de téléchargement (version compacte)
class PodcastDownloadBadge extends StatefulWidget {
  final Podcast podcast;
  final PodcastDownloadService downloadService;

  const PodcastDownloadBadge({
    super.key,
    required this.podcast,
    required this.downloadService,
  });

  @override
  State<PodcastDownloadBadge> createState() => _PodcastDownloadBadgeState();
}

class _PodcastDownloadBadgeState extends State<PodcastDownloadBadge> {
  bool _isDownloaded = false;
  int? _fileSize;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final isDownloaded = await widget.downloadService.isPodcastDownloaded(
      widget.podcast.uuid,
      widget.podcast.libelle,
    );

    int? size;
    if (isDownloaded) {
      size = await widget.downloadService.getDownloadedFileSize(
        widget.podcast.uuid,
        widget.podcast.libelle,
      );
    }

    if (mounted) {
      setState(() {
        _isDownloaded = isDownloaded;
        _fileSize = size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDownloaded) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.download_done,
            size: 14,
            color: Colors.green[700],
          ),
          const SizedBox(width: 4),
          Text(
            _fileSize != null
                ? PodcastDownloadService.formatFileSize(_fileSize!)
                : 'Téléchargé',
            style: TextStyle(
              fontSize: 11,
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
