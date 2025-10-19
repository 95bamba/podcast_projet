import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/models/podcast.dart';
import 'package:podcast/services/media_service.dart';

/// Page de détail d'un podcast avec lecture audio
class PodcastDetailPageWithAudio extends StatefulWidget {
  final Podcast podcast;

  const PodcastDetailPageWithAudio({
    super.key,
    required this.podcast,
  });

  @override
  State<PodcastDetailPageWithAudio> createState() => _PodcastDetailPageWithAudioState();
}

class _PodcastDetailPageWithAudioState extends State<PodcastDetailPageWithAudio> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    // Écouter les changements d'état du lecteur
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isLoading = state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });

        // Gérer la fin de la lecture
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _position = Duration.zero;
          });
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
        }
      }
    });

    // Écouter la durée totale
    _audioPlayer.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });

    // Écouter la position actuelle
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });
  }

  Future<void> _loadAndPlayAudio() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Construire l'URL audio à partir de l'UUID du podcast
      final audioUrl = MediaService.getAudioUrl(widget.podcast.audioFileUuid);

      if (audioUrl.isEmpty) {
        throw Exception('Aucun fichier audio disponible pour ce podcast');
      }

      print('Chargement de l\'audio depuis: $audioUrl');

      // Charger l'audio
      await _audioPlayer.setUrl(audioUrl);

      // Démarrer la lecture
      await _audioPlayer.play();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors du chargement de l\'audio: $e';
      });
      print('Erreur audio: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Si c'est la première lecture, charger l'audio
      if (_audioPlayer.duration == null) {
        await _loadAndPlayAudio();
      } else {
        await _audioPlayer.play();
      }
    }
  }

  void _seek(Duration position) {
    _audioPlayer.seek(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.podcast.libelle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du podcast
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                image: widget.podcast.imagePath != null
                    ? DecorationImage(
                        image: NetworkImage(
                          MediaService.getImageUrl(widget.podcast.imagePath),
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.podcast.imagePath == null
                  ? Icon(
                      Icons.podcasts,
                      size: 100,
                      color: Colors.grey[400],
                    )
                  : null,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    widget.podcast.libelle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    widget.podcast.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // UUID du fichier audio (debug)
                  if (widget.podcast.audioFileUuid != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fichier audio:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.podcast.audioFileUuid!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 30),

                  // Message d'erreur
                  if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // Lecteur audio
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Slider de progression
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble() > 0
                                ? _duration.inSeconds.toDouble()
                                : 1.0,
                            onChanged: (value) {
                              _seek(Duration(seconds: value.toInt()));
                            },
                            activeColor: const Color(0xFFFF6B35),
                            inactiveColor: Colors.grey[300],
                          ),
                        ),

                        // Temps
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_position),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                _formatDuration(_duration),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Contrôles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Reculer de 10 secondes
                            IconButton(
                              onPressed: () {
                                final newPosition = _position - const Duration(seconds: 10);
                                _seek(newPosition < Duration.zero
                                    ? Duration.zero
                                    : newPosition);
                              },
                              icon: const Icon(Icons.replay_10),
                              iconSize: 32,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 20),

                            // Bouton Play/Pause
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: _isLoading ? null : _togglePlayPause,
                                icon: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        _isPlaying ? Icons.pause : Icons.play_arrow,
                                        size: 36,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Avancer de 10 secondes
                            IconButton(
                              onPressed: () {
                                final newPosition = _position + const Duration(seconds: 10);
                                _seek(newPosition > _duration ? _duration : newPosition);
                              },
                              icon: const Icon(Icons.forward_10),
                              iconSize: 32,
                              color: Colors.grey[700],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info: URL de l'API
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.green[700]),
                            const SizedBox(width: 8),
                            const Text(
                              'API utilisée:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          MediaService.getAudioUrl(widget.podcast.audioFileUuid ?? ''),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
