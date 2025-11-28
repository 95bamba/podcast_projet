import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/models/podcast.dart';
import 'package:podcast/models/episode.dart';
import 'package:podcast/services/media_service.dart';
import 'package:podcast/services/api_service.dart';
import 'package:podcast/bloc/episode/episode_bloc.dart';
import 'package:podcast/bloc/episode/episode_event.dart';
import 'package:podcast/bloc/episode/episode_state.dart';
import 'package:podcast/widgets/audio_controls.dart';

/// Page de détail d'un podcast avec chargement des épisodes et lecture audio
class PodcastDetailWithEpisodesPage extends StatefulWidget {
  final Podcast podcast;

  const PodcastDetailWithEpisodesPage({
    super.key,
    required this.podcast,
  });

  @override
  State<PodcastDetailWithEpisodesPage> createState() =>
      _PodcastDetailWithEpisodesPageState();
}

class _PodcastDetailWithEpisodesPageState
    extends State<PodcastDetailWithEpisodesPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _errorMessage;
  Episode? _currentEpisode;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
    // Charger les épisodes au démarrage
    context
        .read<EpisodeBloc>()
        .add(EpisodeLoadByPodcastRequested(widget.podcast.uuid));
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

  Future<void> _loadAndPlayEpisode(Episode episode) async {
    print('\n========== DÉBUT CHARGEMENT AUDIO ==========');
    print('DEBUG: Episode complet: ${episode.toJson()}');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentEpisode = episode;
    });

    try {
      print('DEBUG: Episode UUID: ${episode.uuid}');
      print('DEBUG: Episode title: ${episode.title}');
      print('DEBUG: Episode audioPath: ${episode.audioPath}');

      // Récupérer le token d'authentification
      final apiService = context.read<ApiService>();
      final token = apiService.token;

      print('DEBUG: Token disponible: ${token != null}');
      if (token != null) {
        print('DEBUG: Token (premiers 20 chars): ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
      }

      // Construire l'URL audio à partir de l'UUID du fichier audio de l'épisode
      // L'API attend l'UUID de l'épisode dans le paramètre uuid
      // Format: http://51.254.204.25:2000/ged/preview?uuid={episodeUuid}
      final audioUuid = episode.audioPath ?? episode.uuid;
      print('DEBUG: Audio UUID utilisé: $audioUuid');

      final audioUrl = MediaService.getAudioStreamUrl(audioUuid);
      print('DEBUG: URL audio construite: $audioUrl');

      if (audioUrl.isEmpty) {
        throw Exception('Aucun fichier audio disponible pour cet épisode');
      }

      print('DEBUG: Création de AudioSource...');
      // Charger l'audio avec les headers d'authentification
      final audioSource = AudioSource.uri(
        Uri.parse(audioUrl),
        headers: token != null ? {
          'Authorization': 'Bearer $token',
        } : null,
      );

      print('DEBUG: Chargement de l\'audio dans le player...');
      await _audioPlayer.setAudioSource(audioSource);

      print('DEBUG: Démarrage de la lecture...');
      // Démarrer la lecture
      await _audioPlayer.play();

      setState(() {
        _isLoading = false;
      });

      print('DEBUG: ✅ Lecture démarrée avec succès!');
      print('========== FIN CHARGEMENT AUDIO ==========\n');
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors du chargement de l\'audio: $e';
      });
      print('DEBUG: ❌ Erreur audio: $e');
      print('DEBUG: Stack trace: $stackTrace');
      print('========== FIN AVEC ERREUR ==========\n');
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<EpisodeBloc>()
                  .add(EpisodeLoadByPodcastRequested(widget.podcast.uuid));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // En-tête du podcast
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Image du podcast
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
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
                          size: 50,
                          color: Colors.grey[400],
                        )
                      : null,
                ),
                const SizedBox(width: 15),

                // Info du podcast
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.podcast.libelle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.podcast.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Message d'erreur
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(20),
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

          // Liste des épisodes
          Expanded(
            child: BlocBuilder<EpisodeBloc, EpisodeState>(
              builder: (context, state) {
                if (state is EpisodeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                }

                if (state is EpisodeError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 60, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Erreur de chargement',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<EpisodeBloc>().add(
                                  EpisodeLoadByPodcastRequested(
                                      widget.podcast.uuid));
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Réessayer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is EpisodeLoaded) {
                  final episodes = state.episodes;

                  if (episodes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.library_music_outlined,
                              size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun épisode disponible',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: episodes.length,
                    itemBuilder: (context, index) {
                      final episode = episodes[index];
                      final isCurrentEpisode = _currentEpisode?.uuid == episode.uuid;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: isCurrentEpisode ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isCurrentEpisode
                                ? const Color(0xFFFF6B35)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              // Info de l'épisode avec boutons
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icône
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isCurrentEpisode
                                          ? const Color(0xFFFF6B35)
                                          : Colors.orange[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      isCurrentEpisode && _isPlaying
                                          ? Icons.volume_up
                                          : Icons.play_arrow,
                                      color: isCurrentEpisode
                                          ? Colors.white
                                          : Colors.orange[700],
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Titre et description
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          episode.title,
                                          style: TextStyle(
                                            fontWeight: isCurrentEpisode
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          episode.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        if (episode.duration != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Durée: ${episode.duration}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Bouton de lecture streaming
                                  IconButton(
                                    icon: Icon(
                                      isCurrentEpisode && _isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                      size: 40,
                                      color: const Color(0xFFFF6B35),
                                    ),
                                    onPressed: () {
                                      if (isCurrentEpisode) {
                                        _togglePlayPause();
                                      } else {
                                        _loadAndPlayEpisode(episode);
                                      }
                                    },
                                  ),
                                ],
                              ),

                              // Widget de téléchargement
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 8),
                              AudioControls(
                                audioFileUuid: episode.uuid, // Utiliser l'UUID de l'épisode
                                fileName: 'episode_${episode.uuid}.m4a',
                                onPlay: () => _loadAndPlayEpisode(episode),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child: Text('Chargement...'),
                );
              },
            ),
          ),

          // Lecteur audio (seulement si un épisode est sélectionné)
          if (_currentEpisode != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Info épisode en cours
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentEpisode!.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.podcast.libelle,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Slider de progression
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 4,
                      ),
                      trackHeight: 2,
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
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _formatDuration(_duration),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Contrôles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          final newPosition =
                              _position - const Duration(seconds: 10);
                          _seek(newPosition < Duration.zero
                              ? Duration.zero
                              : newPosition);
                        },
                        icon: const Icon(Icons.replay_10),
                        iconSize: 28,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 56,
                        height: 56,
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
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 32,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          final newPosition =
                              _position + const Duration(seconds: 10);
                          _seek(newPosition > _duration
                              ? _duration
                              : newPosition);
                        },
                        icon: const Icon(Icons.forward_10),
                        iconSize: 28,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
