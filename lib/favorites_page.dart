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
          'color': Color(0xff4CAF50),
        },
        {
          'title': 'Définir ses objectifs',
          'duration': '20:15',
          'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
          'playlistTitle': 'Motivation et Développement',
          'image': 'assets/mame.jpg',
          'color': Color(0xff2196F3),
        },
        {
          'title': 'Méditation guidée',
          'duration': '20:45',
          'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
          'playlistTitle': 'Religion et Spiritualité',
          'image': 'assets/fa.jpg',
          'color': Colors.deepOrangeAccent,
        },
        {
          'title': 'Gestion du temps',
          'duration': '25:15',
          'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
          'playlistTitle': 'Éducation et Apprentissage',
          'image': 'assets/bve.jpg',
          'color': Color(0xff4CAF50),
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
    
    // Show snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Épisode retiré des favoris'),
        backgroundColor: Colors.deepOrangeAccent,
        duration: Duration(seconds: 2),
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
                          icon: const Icon(Icons.menu, color: Colors.black, size: 28),
                          onPressed: () {
                            setState(() {
                              _isMenuOpen = !_isMenuOpen;
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Text("P", style: TextStyle(
                              color: Colors.black, 
                              fontSize: 32,
                              fontWeight: FontWeight.bold
                            )),
                            Text("o", style: TextStyle(
                              color: Color(0xFFFF6B35), 
                              fontSize: 32,
                              fontWeight: FontWeight.bold
                            )),
                            Text("dcast", style: TextStyle(
                              color: Colors.black, 
                              fontSize: 32,
                              fontWeight: FontWeight.bold
                            )),
                          ],
                        ),
                        Spacer(),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          child: Icon(Icons.notifications_outlined, color: Colors.grey[600]),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    // Titre et statistiques
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mes Favoris',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_filteredEpisodes.length} épisodes',
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

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
                        onChanged: _filterEpisodes,
                        decoration: InputDecoration(
                          hintText: 'Rechercher dans mes favoris...',
                          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey[600], size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterEpisodes('');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),

                    SizedBox(height: 25),

                    // Liste des favoris - NOUVEAU DESIGN
                    if (_filteredEpisodes.isEmpty)
                      Container(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucun favori',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ajoutez des épisodes à vos favoris',
                              style: TextStyle(
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredEpisodes.length,
                        itemBuilder: (context, index) {
                          final episode = _filteredEpisodes[index];
                          final isCurrentEpisode = currentEpisodeIndex == index;
                          
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isCurrentEpisode ? episode['color'] : Colors.grey[200]!,
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
                                // Image de l'épisode
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(episode['image']),
                                      fit: BoxFit.cover,
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
                                        episode['playlistTitle'],
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
                                              color: episode['color'].withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              episode['duration'],
                                              style: TextStyle(
                                                color: episode['color'],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          // Boutons d'action
                                          Row(
                                            children: [
                                              // Bouton play
                                              GestureDetector(
                                                onTap: () => _playEpisode(index),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: episode['color'],
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Icon(
                                                    isCurrentEpisode && isPlaying ? Icons.pause : Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              // Bouton supprimer
                                              GestureDetector(
                                                onTap: () => _removeFavorite(index),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
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
          ),
          
          // Menu hamburger
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