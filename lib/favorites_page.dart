import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'widgets/hamburger_menu.dart';
import 'home_page.dart' as home;
import 'playlist_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'about_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _favoriteEpisodes = [];
  List<Map<String, dynamic>> _filteredEpisodes = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration position = Duration.zero;
  int? currentEpisodeIndex;
  
  String _currentPage = 'favorites';
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteEpisodes();
    _initAudioPlayer();
  }

  void _loadFavoriteEpisodes() {
    // Simuler le chargement des épisodes favoris
    setState(() {
      _favoriteEpisodes.addAll([
        {
          'title': 'Introduction à la spiritualité',
          'duration': '15:30',
          'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
          'playlistTitle': 'Religion et Spiritualité',
          'image': 'assets/fa.jpg',
          'color': Colors.deepOrangeAccent,
        },
        {
          'title': 'Techniques d\'apprentissage',
          'duration': '18:25',
          'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
          'playlistTitle': 'Éducation et Apprentissage',
          'image': 'assets/bve.jpg',
          'color': Color(0xff676876),
        },
        {
          'title': 'Définir ses objectifs',
          'duration': '20:15',
          'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
          'playlistTitle': 'Motivation et Développement',
          'image': 'assets/mame.jpg',
          'color': Color(0xff676876),
        },
      ]);
      _filteredEpisodes = _favoriteEpisodes;
    });
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

  Future<void> _playEpisode(int index) async {
    try {
      if (index >= 0 && index < _filteredEpisodes.length) {
        await _audioPlayer.setUrl(_filteredEpisodes[index]['audioUrl']);
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
    if (currentEpisodeIndex != null && currentEpisodeIndex! < _filteredEpisodes.length - 1) {
      await _playEpisode(currentEpisodeIndex! + 1);
    } else if (currentEpisodeIndex != null && currentEpisodeIndex! == _filteredEpisodes.length - 1) {
      await _playEpisode(0);
    }
  }

  Future<void> _playPreviousEpisode() async {
    if (currentEpisodeIndex != null && currentEpisodeIndex! > 0) {
      await _playEpisode(currentEpisodeIndex! - 1);
    } else if (currentEpisodeIndex != null && currentEpisodeIndex! == 0) {
      await _playEpisode(_filteredEpisodes.length - 1);
    }
  }

  void _filterEpisodes(String query) {
    setState(() {
      _filteredEpisodes = _favoriteEpisodes
          .where((episode) =>
              episode['title'].toLowerCase().contains(query.toLowerCase()) ||
              episode['playlistTitle'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _removeFavorite(int index) {
    setState(() {
      _favoriteEpisodes.removeAt(index);
      _filteredEpisodes = _favoriteEpisodes
          .where((episode) =>
              episode['title'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
              episode['playlistTitle'].toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
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
            pageBuilder: (context, animation, secondaryAnimation) => home.HomePage(),
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
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const PlaylistPage(),
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
      case 'favorites':
        // On est déjà sur la page des favoris
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
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Contenu principal
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              _isMenuOpen = !_isMenuOpen;
                            });
                          },
                        ),
                        Row(
                          children: [
                           Text("P", style: TextStyle(color: Colors.black, fontSize: 30)),
                           Text("o", style: TextStyle(color: Color.fromARGB(255, 243, 147, 2), fontSize: 30)),
                           Text("dcast", style: TextStyle(color: Colors.black, fontSize: 30)),
                          ],
                        ),
                        SizedBox(width: 10), 
                      ],
                    ),

                    SizedBox(height: 40),

                    // Titre de la page
                    Text(
                      'Mes Favoris',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Liste des favoris
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _filteredEpisodes.length,
                      itemBuilder: (context, index) {
                        final episode = _filteredEpisodes[index];
                        final isCurrentEpisode = currentEpisodeIndex == index;
                        
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(episode['image']),
                            ),
                            title: Text(episode['title']),
                            subtitle: Text(episode['playlistTitle']),
                            trailing: IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              onPressed: () => _removeFavorite(index),
                            ),
                            onTap: () => _playEpisode(index),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Menu hamburger
          if (_isMenuOpen)
            HamburgerMenu(
              currentPage: _currentPage,
              onPageChange: _changePage,
              isMenuOpen: _isMenuOpen,
              onMenuToggle: (value) {
                setState(() {
                  _isMenuOpen = value;
                });
              },
            ),
        ],
      ),
    );
  }
} 