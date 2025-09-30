import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'widgets/hamburger_menu.dart';
import 'home_page.dart' as home;
import 'favorites_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'about_page.dart';
import 'services/audio_download_service.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _playlists = [
    {
      'title': 'Religion et Spiritualité',
      'image': 'assets/fa.jpg', 
      'episodeCount': 8,
      'color': Colors.deepOrangeAccent,
      'episodes': [
        {'title': 'Introduction à la spiritualité', 'duration': '15:30', 'audioUrl': 'https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav'},
        {'title': 'Méditation guidée', 'duration': '20:45', 'audioUrl': 'https://www2.cs.uic.edu/~i101/SoundFiles/ImperialMarch.wav'},
        {'title': 'Prière et réflexion', 'duration': '18:20', 'audioUrl': 'https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg.wav'},
        {'title': 'Sagesse ancienne', 'duration': '25:10', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'},
        {'title': 'Pratiques quotidiennes', 'duration': '12:35', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3'},
        {'title': 'Questions et réponses', 'duration': '30:15', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3'},
        {'title': 'Témoignages', 'duration': '22:40', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3'},
        {'title': 'Conclusion et méditation', 'duration': '16:50', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3'},
      ],
    },
    {
      'title': 'Éducation et Apprentissage',
      'image': 'assets/bve.jpg',
      'episodeCount': 6,
      'color': Color(0xff676876),
      'episodes': [
        {'title': 'Techniques d\'apprentissage', 'duration': '18:25', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3'},
        {'title': 'Mémoire et concentration', 'duration': '22:10', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3'},
        {'title': 'Lecture rapide', 'duration': '15:40', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3'},
        {'title': 'Prise de notes efficace', 'duration': '19:30', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3'},
        {'title': 'Gestion du temps', 'duration': '25:15', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3'},
        {'title': 'Préparation aux examens', 'duration': '28:20', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3'},
      ],
    },
    {
      'title': 'Motivation et Développement',
      'image': 'assets/mame.jpg',
      'episodeCount': 7,
      'color': Color(0xff676876),
      'episodes': [
        {'title': 'Définir ses objectifs', 'duration': '20:15', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3'},
        {'title': 'Surmonter les obstacles', 'duration': '18:40', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3'},
        {'title': 'Cultiver la persévérance', 'duration': '22:30', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-17.mp3'},
        {'title': 'Mindset de croissance', 'duration': '25:50', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-18.mp3'},
        {'title': 'Routines matinales', 'duration': '15:20', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-19.mp3'},
        {'title': 'Visualisation et affirmation', 'duration': '19:45', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-20.mp3'},
        {'title': 'Célébrer les succès', 'duration': '16:35', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-21.mp3'},
      ],
    },
    {
      'title': 'Fiction et Histoire',
      'image': 'assets/fa.jpg',
      'episodeCount': 9,
      'color': Color(0xff676876),
      'episodes': [
        {'title': 'Introduction à l\'histoire', 'duration': '12:30', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-22.mp3'},
        {'title': 'Les origines', 'duration': '18:45', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-23.mp3'},
        {'title': 'L\'évolution', 'duration': '22:20', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-24.mp3'},
        {'title': 'Les personnages', 'duration': '25:10', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-25.mp3'},
        {'title': 'Les conflits', 'duration': '20:35', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-26.mp3'},
        {'title': 'La résolution', 'duration': '15:50', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-27.mp3'},
        {'title': 'Les leçons', 'duration': '19:25', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-28.mp3'},
        {'title': 'L\'impact', 'duration': '16:40', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-29.mp3'},
        {'title': 'Conclusion', 'duration': '14:15', 'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-30.mp3'},
      ],
    },
  ];
  List<Map<String, dynamic>> _filteredPlaylists = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration position = Duration.zero;
  
  String _currentPage = 'playlist';
  
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredPlaylists = _playlists;
    _initAudioPlayer();
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

  void _changePage(String page) {
    setState(() {
      _currentPage = page;
      _isMenuOpen = false;
    });

    switch (page) {
      case 'home':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const home.HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(-1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 'playlist':
        // On est déjà sur la page des playlists
        break;
      case 'favorites':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const FavoritesPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 'profile':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 'settings':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SettingsPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 'about':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const AboutPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff676876),
      appBar: AppBar(
        backgroundColor: const Color(0xff676876),
        title: const Text(
          'Playlists',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            setState(() {
              _isMenuOpen = !_isMenuOpen;
            });
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterPlaylists,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une playlist...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredPlaylists.length,
                  itemBuilder: (context, index) {
                    final playlist = _filteredPlaylists[index];
                    return GestureDetector(
                      onTap: () => _showPlaylistDetails(playlist),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(playlist['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      playlist['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${playlist['episodeCount']} épisodes',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_arrow, color: Colors.white),
                              onPressed: () => _showPlaylistDetails(playlist),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_isMenuOpen)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMenuOpen = false;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: HamburgerMenu(
                    currentPage: _currentPage,
                    onPageChange: _changePage,
                    isMenuOpen: _isMenuOpen,
                    onMenuToggle: (value) {
                      setState(() {
                        _isMenuOpen = value;
                      });
                    },
                  ),
                ),
              ),
            ),
        ],
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

class PlaylistCard extends StatefulWidget {
  final Map<String, dynamic> playlist;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
  });

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  bool isLiked = false;
  bool isFavorited = false;
  bool isDownloaded = false;
  bool isDownloading = false;
  double downloadProgress = 0.0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioDownloadService _downloadService = AudioDownloadService();
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

  Future<void> _downloadAudio() async {
    if (isDownloading) return;

    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    try {
      final episode = widget.playlist['episodes'][currentEpisodeIndex ?? 0];
      final fileName = episode['audioUrl'].split('/').last;
      final success = await _downloadService.downloadAudio(
        episode['audioUrl'],
        fileName,
        onProgress: (progress) {
          setState(() {
            downloadProgress = progress;
          });
        },
      );

      if (success) {
        setState(() {
          isDownloaded = true;
          isDownloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Téléchargement terminé'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          isDownloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec du téléchargement'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du téléchargement: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleDownloaded() {
    if (!isDownloaded && !isDownloading) {
      _downloadAudio();
    }
  }

  void _toggleLiked() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _toggleFavorited() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            // Image de fond
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                widget.playlist['image'],
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(180),
                  ],
                ),
              ),
            ),
            
            // Contenu de la carte
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Titre et nombre d'épisodes
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.playlist['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${widget.playlist['episodeCount']} épisodes',
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  // Lecteur audio intégré
                  Column(
                    children: [
                      // Barre de progression
                      if (duration != null)
                        Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: widget.playlist['color'],
                                inactiveTrackColor: Colors.white.withAlpha(100),
                                thumbColor: widget.playlist['color'],
                                trackHeight: 2,
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 4,
                                ),
                                overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: 8,
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
                                    color: Colors.white.withAlpha(200),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  "${duration?.inMinutes ?? 0}:${((duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(200),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      
                      SizedBox(height: 5),
                      
                      // Contrôles de lecture
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.skip_previous, size: 24, color: Colors.white),
                            onPressed: _playPreviousEpisode,
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: widget.playlist['color'],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.skip_next, size: 24, color: Colors.white),
                            onPressed: _playNextEpisode,
                          ),
                        ],
                      ),
                      
                      // Épisode en cours
                      if (currentEpisodeIndex != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            widget.playlist['episodes'][currentEpisodeIndex!]['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 20,
                        ),
                        onPressed: _toggleLiked,
                      ),
                      
                      // Favoris
                      IconButton(
                        icon: Icon(
                          isFavorited ? Icons.star : Icons.star_border,
                          color: isFavorited ? Colors.amber : Colors.white,
                          size: 20,
                        ),
                        onPressed: _toggleFavorited,
                      ),
                      
                      IconButton(
                        icon: isDownloading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  value: downloadProgress / 100,
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Icon(
                                isDownloaded ? Icons.download_done : Icons.download,
                                color: isDownloaded ? Colors.green : Colors.white,
                                size: 20,
                              ),
                        onPressed: _toggleDownloaded,
                      ),
                    ],
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
  bool isExpanded = false;

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.playlist['title'],
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Menu options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec image et informations
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.playlist['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(180),
                  ],
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.playlist['title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${widget.playlist['episodeCount']} épisodes',
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Lecteur audio
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
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
                      icon: Icon(Icons.skip_previous, size: 40),
                      onPressed: _playPreviousEpisode,
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: widget.playlist['color'],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: Icon(Icons.skip_next, size: 40),
                      onPressed: _playNextEpisode,
                    ),
                  ],
                ),
                
                // Épisode en cours
                if (currentEpisodeIndex != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      widget.playlist['episodes'][currentEpisodeIndex!]['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          
          // Titre de la section épisodes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tous les épisodes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Text(isExpanded ? 'Réduire' : 'Tout afficher'),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Liste des épisodes
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: isExpanded 
                  ? widget.playlist['episodes'].length 
                  : (widget.playlist['episodes'].length > 5 ? 5 : widget.playlist['episodes'].length),
              itemBuilder: (context, index) {
                final episode = widget.playlist['episodes'][index];
                final isCurrentEpisode = currentEpisodeIndex == index;
                
                return ExpansionTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCurrentEpisode ? widget.playlist['color'] : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCurrentEpisode && isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      color: isCurrentEpisode ? Colors.white : Colors.grey[700],
                      size: 20,
                    ),
                  ),
                  title: Text(
                    episode['title'],
                    style: TextStyle(
                      fontWeight: isCurrentEpisode ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(episode['duration']),
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      _playEpisode(index);
                    }
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description de l\'épisode',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.download),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}