import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'favorites_page.dart';
import 'playlist_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'about_page.dart';
import 'widgets/hamburger_menu.dart';
import 'services/audio_download_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration position = Duration.zero;
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  
  // Variables pour le menu hamburger 
  String _currentPage = 'home';
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    Future.delayed(Duration(milliseconds: 500), () {
      _togglePlayPause();
    });
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setUrl('assets/audio/sons1.m4a');
      
      _audioPlayer.playerStateStream.listen((state) {
        setState(() {
          isPlaying = state.playing;
        });
        
        if (state.processingState == ProcessingState.completed) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.play();
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

  void _performSearch(String query) {
    setState(() {
      _searchResults = [
        'Podcast Religion - $query',
        'Podcast Education - $query',
        'Podcast Motivation - $query',
        'Podcast Fictionnel - $query',
      ];
    });
  }
  
  // Méthode pour changer de page
  void _changePage(String page) {
    setState(() {
      _currentPage = page;
      _isMenuOpen = false;
    });

    switch (page) {
      case 'home':
        // On est déjà sur la page d'accueil
        break;
      case 'playlist':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const PlaylistPage(),
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

                    // Featured Podcast
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: AssetImage('assets/fa.jpg'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(102),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(204),
                            ],
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Titre et catégorie
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrangeAccent.withAlpha(230),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Religion',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(51),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Épisode 1',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                // Titre principal
                                Text(
                                  'Réligion',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Barre de progression
                                if (duration != null)
                                  Column(
                                    children: [
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: Colors.white,
                                          inactiveTrackColor: Colors.white.withAlpha(77),
                                          thumbColor: Colors.white,
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
                                              color: Colors.white.withAlpha(204),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "${duration?.inMinutes ?? 0}:${((duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                                            style: TextStyle(
                                              color: Colors.white.withAlpha(204),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 20),
                                // Contrôles de lecture
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(51),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(30),
                                          onTap: _togglePlayPause,
                                          child: AnimatedSwitcher(
                                            duration: Duration(milliseconds: 200),
                                            child: Icon(
                                              isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                                              color: Colors.black,
                                              size: 35,
                                              key: ValueKey<bool>(isPlaying),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Search Bar
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher un podcast...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchResults = [];
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _performSearch(value);
                          } else {
                            setState(() {
                              _searchResults = [];
                            });
                          }
                        },
                      ),
                    ),

                    if (_searchResults.isNotEmpty) ...[
                      SizedBox(height: 20),
                      Text(
                        'Résultats de recherche',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: Icon(Icons.audio_file),
                              title: Text(_searchResults[index]),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ],

                    SizedBox(height: 40),

                    // Search and Categories Section
                    Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff676076), Color(0xffAAAAAA)],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Color(0xff676076))],
                      ),
                      child: Column(
                        children: [
                          // Barre de recherche
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xff676076),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("podcast", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),

                          Divider(height: 40, color: Color(0xff676076), thickness: 0.0),

                          Text("Toutes Catégories", style: TextStyle(color: Colors.white, fontSize: 18)),

                          SizedBox(height: 40),

                          // Les grandes catégories
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _changePage('playlist'),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    child: Center(
                                      child: Text("Playlist", style: TextStyle(color: Colors.white, fontSize: 20)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _changePage('favorites'),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xff676076),
                                    ),
                                    child: Center(
                                      child: Text("Favoris", style: TextStyle(color: Colors.white, fontSize: 20)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _changePage('profile'),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xff676076),
                                    ),
                                    child: Center(
                                      child: Text("Profil", style: TextStyle(color: Colors.white, fontSize: 20)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          // Categories Row 2
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _changePage('settings'),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xff676076),
                                    ),
                                    child: Center(
                                      child: Text("Paramètres", style: TextStyle(color: Colors.white, fontSize: 20)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _changePage('about'),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    child: Center(
                                      child: Text("À propos", style: TextStyle(color: Colors.white, fontSize: 20)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromARGB(0, 255, 255, 255),
                                  ),
                                  child: Center(
                                    child: Text("+", style: TextStyle(color: Colors.white, fontSize: 20)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40), 

                    // Podcast Grid
                    Text("V1 podcast", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),

                    // Grid de podcasts
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final List<Map<String, dynamic>> podcastData = [
                          {
                            'image': 'assets/fa.jpg',
                            'title': 'Pod Religion',
                            'subtitle': 'Podcast',
                            'color': Colors.deepOrangeAccent,
                            'audioUrl': 'https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav',
                          },
                          {
                            'image': 'assets/bve.jpg',
                            'title': 'Pod Education',
                            'subtitle': 'Podcast',
                            'color': Color(0xff676876),
                            'audioUrl': 'https://www2.cs.uic.edu/~i101/SoundFiles/ImperialMarch.wav',
                          },
                          {
                            'image': 'assets/mame.jpg',
                            'title': 'Pod Motivation',
                            'subtitle': 'Podcast',
                            'color': Color(0xff676876),
                            'audioUrl': 'https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg.wav',
                          },
                          {
                            'image': 'assets/fa.jpg',
                            'title': 'Pod Fictionnel',
                            'subtitle': 'Podcast',
                            'color': Color(0xff676876),
                            'audioUrl': 'https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand3.wav',
                          },
                        ];
                        
                        return PodcastCard(
                          image: podcastData[index]['image'],
                          title: podcastData[index]['title'],
                          subtitle: podcastData[index]['subtitle'],
                          color: podcastData[index]['color'],
                          audioUrl: podcastData[index]['audioUrl'],
                        );
                      },
                    ),

                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [ 
                          Color(0xff676876),
                          Color(0xffAAAAAA),
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 20),
                            color: Color(0xff676876), 
                          )
                        ]
                      ),
                    ),
                    SizedBox(height: 40,),
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
  
  // Méthode pour construire un élément du menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? (isSelected ? Color.fromARGB(255, 243, 147, 2) : Colors.grey),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Color.fromARGB(255, 243, 147, 2) : Colors.black,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.grey[100],
      onTap: onTap,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class PodcastCard extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final Color color;
  final String audioUrl;

  const PodcastCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.audioUrl,
  });

  @override
  State<PodcastCard> createState() => _PodcastCardState();
}

class _PodcastCardState extends State<PodcastCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioDownloadService _downloadService = AudioDownloadService();
  bool isPlaying = false;
  bool isLiked = false;
  bool isFavorited = false;
  bool isDownloaded = false;
  bool isDownloading = false;
  double downloadProgress = 0.0;
  Duration? duration;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setUrl(widget.audioUrl);
      
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

  Future<void> _downloadAudio() async {
    if (isDownloading) return;

    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    try {
      final fileName = widget.audioUrl.split('/').last;
      final success = await _downloadService.downloadAudio(
        widget.audioUrl,
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
              widget.image,
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
                // Titre et sous-titre
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                
                // Barre de progression et contrôles
                Column(
                  children: [
                    // Barre de progression
                    if (duration != null)
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: widget.color,
                              inactiveTrackColor: Colors.white.withAlpha(77),
                              thumbColor: widget.color,
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
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${duration?.inMinutes ?? 0}:${((duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                                style: TextStyle(
                                  color: Colors.white.withAlpha(200),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    
                    SizedBox(height: 10),
                    
                    // Boutons de contrôle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bouton play/pause
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        // Icônes d'action
                        Row(
                          children: [
                            // J'aime
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
                            
                            // Téléchargement
                            IconButton(
                              icon: isDownloading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        value: downloadProgress,
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

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.text,
    required this.color,
  });
  

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }
}