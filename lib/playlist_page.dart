import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'services/audio_download_service.dart';
import 'services/api_service.dart';
import 'create_playlist_page.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _playlists = [];
  List<Map<String, dynamic>> _filteredPlaylists = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration position = Duration.zero;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _apiService.loadToken();
    _fetchPlaylists();
    _initAudioPlayer();
  }

  Future<void> _fetchPlaylists() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.getPlaylists();

      if (response.statusCode == 200) {
        final data = response.data;

        // Parse the response data
        if (data is List) {
          setState(() {
            _playlists = data.map((item) {
              return {
                'id': item['_id'] ?? '',
                'title': item['libelle'] ?? 'Sans titre',
                'description': item['description'] ?? '',
                'image': item['file'] ?? '', // URL de l'image depuis l'API
                'episodeCount': 0, // À adapter selon votre structure
                'color': Colors.deepOrangeAccent, // Couleur par défaut
                'episodes': [], // À adapter selon votre structure
              };
            }).toList();
            _filteredPlaylists = _playlists;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Format de données invalide';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Erreur lors du chargement des playlists';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setUrl('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
      
      _audioPlayer.playerStateStream.listen((state) {
        setState(() {
          isPlaying = state.playing;
        });
      });

      _audioPlayer.durationStream.listen((d) {
        setState(() {
          duration = d;
        });
      });

      _audioPlayer.positionStream.listen((p) {
        setState(() {
          position = p;
        });
      });
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error toggling play/pause: $e');
    }
  }

  void _filterPlaylists(String query) {
    setState(() {
      _filteredPlaylists = _playlists
          .where((playlist) =>
              playlist['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showPlaylistDetails(Map<String, dynamic> playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistEpisodesPage(playlist: playlist),
      ),
    );
  }


  void _navigateToCreatePlaylist() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePlaylistPage(),
      ),
    );

    // Si la playlist a été créée avec succès, rafraîchir la liste
    if (result == true && mounted) {
      _fetchPlaylists();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Playlist créée avec succès!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Podcasts Playlists',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFFFF6B35)),
            onPressed: _navigateToCreatePlaylist,
            tooltip: 'Créer une playlist',
          ),
        ],
      ),
      body: SafeArea(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF6B35),
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchPlaylists,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35),
                              ),
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Barre de recherche
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: _filterPlaylists,
                                decoration: InputDecoration(
                                  hintText: 'Rechercher une playlist...',
                                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(Icons.clear, color: Colors.grey[600], size: 18),
                                          onPressed: () {
                                            _searchController.clear();
                                            _filterPlaylists('');
                                          },
                                        )
                                      : null,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Liste des playlists avec nouveau design
                            const Text(
                              'Playlists Podcasts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),

                            _filteredPlaylists.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.playlist_remove,
                                            size: 60,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Aucune playlist trouvée',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _filteredPlaylists.length,
                                    itemBuilder: (context, index) {
                                      final playlist = _filteredPlaylists[index];
                                      final imageUrl = playlist['image'] ?? '';
                                      final hasValidImage = imageUrl.isNotEmpty &&
                                          (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 16),
                                        child: Row(
                                          children: [
                                            // Image de la playlist
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Colors.grey[300],
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: hasValidImage
                                                    ? Image.network(
                                                        imageUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Icon(
                                                            Icons.music_note,
                                                            size: 30,
                                                            color: Colors.grey[600],
                                                          );
                                                        },
                                                        loadingBuilder: (context, child, loadingProgress) {
                                                          if (loadingProgress == null) return child;
                                                          return Center(
                                                            child: CircularProgressIndicator(
                                                              value: loadingProgress.expectedTotalBytes != null
                                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                                      loadingProgress.expectedTotalBytes!
                                                                  : null,
                                                              strokeWidth: 2,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : Icon(
                                                        Icons.music_note,
                                                        size: 30,
                                                        color: Colors.grey[600],
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),

                                            // Contenu
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.05),
                                                      blurRadius: 6,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                  border: Border.all(
                                                    color: Colors.grey[100]!,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      playlist['title'],
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      playlist['description'] ?? 'Playlist',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 8, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFFF6B35).withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            '${playlist['episodeCount']} épisode${playlist['episodeCount'] > 1 ? 's' : ''}',
                                                            style: const TextStyle(
                                                              color: Color(0xFFFF6B35),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        GestureDetector(
                                                          onTap: () => _showPlaylistDetails(playlist),
                                                          child: Container(
                                                            width: 32,
                                                            height: 32,
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFFFF6B35),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: const Icon(
                                                              Icons.play_arrow,
                                                              color: Colors.white,
                                                              size: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
          ),
          
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class PlaylistEpisodesPage extends StatefulWidget {
  final Map<String, dynamic> playlist;

  const PlaylistEpisodesPage({
    super.key,
    required this.playlist,
  });

  @override
  State<PlaylistEpisodesPage> createState() => _PlaylistEpisodesPageState();
}

class _PlaylistEpisodesPageState extends State<PlaylistEpisodesPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration position = Duration.zero;
  int? currentEpisodeIndex;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      if (widget.playlist['episodes'].isNotEmpty) {
        await _audioPlayer.setUrl(widget.playlist['episodes'][0]['audioUrl']);
        currentEpisodeIndex = 0;
        
        _audioPlayer.playerStateStream.listen((state) {
          setState(() {
            isPlaying = state.playing;
          });
          
          if (state.processingState == ProcessingState.completed) {
            _playNextEpisode();
          }
        });

        _audioPlayer.durationStream.listen((d) {
          setState(() {
            duration = d;
          });
        });

        _audioPlayer.positionStream.listen((p) {
          setState(() {
            position = p;
          });
        });
      }
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error toggling play/pause: $e');
    }
  }

  Future<void> _playEpisode(int index) async {
    try {
      if (index >= 0 && index < widget.playlist['episodes'].length) {
        await _audioPlayer.setUrl(widget.playlist['episodes'][index]['audioUrl']);
        await _audioPlayer.play();
        setState(() {
          currentEpisodeIndex = index;
          isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint('Error playing episode: $e');
    }
  }

  Future<void> _playNextEpisode() async {
    if (currentEpisodeIndex != null && currentEpisodeIndex! < widget.playlist['episodes'].length - 1) {
      await _playEpisode(currentEpisodeIndex! + 1);
    } else if (currentEpisodeIndex != null && currentEpisodeIndex! == widget.playlist['episodes'].length - 1) {
      await _playEpisode(0);
    }
  }

  Future<void> _playPreviousEpisode() async {
    if (currentEpisodeIndex != null && currentEpisodeIndex! > 0) {
      await _playEpisode(currentEpisodeIndex! - 1);
    } else if (currentEpisodeIndex != null && currentEpisodeIndex! == 0) {
      await _playEpisode(widget.playlist['episodes'].length - 1);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.playlist['title'],
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de la playlist
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.playlist['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(widget.playlist['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playlist['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${widget.playlist['episodeCount']} épisodes',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Lecteur audio
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // Épisode en cours
                  if (currentEpisodeIndex != null)
                    Text(
                      widget.playlist['episodes'][currentEpisodeIndex!]['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  
                  SizedBox(height: 10),
                  
                  // Barre de progression
                  if (duration != null)
                    Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: widget.playlist['color'],
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: widget.playlist['color'],
                            trackHeight: 4,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                          ),
                          child: Slider(
                            value: position.inSeconds.toDouble(),
                            max: duration!.inSeconds.toDouble(),
                            onChanged: (value) {
                              _audioPlayer.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "${duration?.inMinutes ?? 0}:${((duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  
                  SizedBox(height: 10),
                  
                  // Contrôles de lecture
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, size: 30),
                        onPressed: _playPreviousEpisode,
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: widget.playlist['color'],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.skip_next, size: 30),
                        onPressed: _playNextEpisode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Liste des épisodes
            Text(
              'Épisodes (${widget.playlist['episodes'].length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.playlist['episodes'].length,
              itemBuilder: (context, index) {
                final episode = widget.playlist['episodes'][index];
                final isCurrentEpisode = currentEpisodeIndex == index;
                
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isCurrentEpisode ? widget.playlist['color'] : Colors.grey[200]!,
                      width: isCurrentEpisode ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Numéro de l'épisode
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.playlist['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: widget.playlist['color'].withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: widget.playlist['color'],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      
                      // Contenu de l'épisode
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              episode['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              episode['duration'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Bouton play
                      GestureDetector(
                        onTap: () => _playEpisode(index),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: widget.playlist['color'],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            isCurrentEpisode && isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}