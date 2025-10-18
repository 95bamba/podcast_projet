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
      'color': Color(0xff4CAF50),
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
      'color': Color(0xff2196F3),
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
      'color': Color(0xff9C27B0),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            setState(() {
              _isMenuOpen = !_isMenuOpen;
            });
          },
        ),
        title: const Text(
          'Podcasts Playlists',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Contenu principal
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barre de recherche
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
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

                  SizedBox(height: 20),

                  // Liste des playlists avec nouveau design
                  Text(
                    'Playlists Podcasts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _filteredPlaylists.length,
                    itemBuilder: (context, index) {
                      final playlist = _filteredPlaylists[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            // Image de la playlist
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage(playlist['image']),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            
                            // Contenu
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Playlist',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: playlist['color'].withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${playlist['episodeCount']} épisode${playlist['episodeCount'] > 1 ? 's' : ''}',
                                            style: TextStyle(
                                              color: playlist['color'],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () => _showPlaylistDetails(playlist),
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: playlist['color'],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
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
          
          // Menu hamburger
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