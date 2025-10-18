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

  // Données des catégories avec podcasts
  final List<PodcastCategory> _categories = [
    PodcastCategory(
      name: 'Religion',
      image: 'assets/fa.jpg',
      color: Colors.deepOrangeAccent,
      podcasts: [
        Podcast(
          title: 'La foi au quotidien',
          image: 'assets/fa.jpg',
          description: 'Des conseils pour vivre sa foi au jour le jour',
          author: 'Serigne Sam Mbaye',
          episodes: [
            Episode(
              title: 'Introduction à la foi',
              duration: '25:30',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav',
            ),
            Episode(
              title: 'La prière quotidienne',
              duration: '32:15',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/ImperialMarch.wav',
            ),
            Episode(
              title: 'Les sacrements',
              duration: '28:45',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Les grandes religions',
          image: 'assets/fa.jpg',
          description: 'Découverte des principales religions du monde',
          author: 'Serigne Mbacké',
          episodes: [
            Episode(
              title: 'Le Mouridisme',
              duration: '35:20',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/BabyElephantWalk60.wav',
            ),
            Episode(
              title: 'L\'islam',
              duration: '33:10',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Spiritualité moderne',
          image: 'assets/fa.jpg',
          description: 'La spiritualité dans le monde contemporain',
          author: 'Serigne Sy',
          episodes: [
            Episode(
              title: 'Méditation et spiritualité',
              duration: '28:45',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Questions existentielles',
          image: 'assets/fa.jpg',
          description: 'Réflexions sur les grandes questions de la vie',
          author: 'Serigne Fall',
          episodes: [
            Episode(
              title: 'Le sens de la vie',
              duration: '40:15',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand3.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Histoire des religions',
          image: 'assets/fa.jpg',
          description: 'L\'évolution des croyances à travers l\'histoire',
          author: 'Prof. Bernard',
          episodes: [
            Episode(
              title: 'Les religions antiques',
              duration: '38:20',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/BabyElephantWalk60.wav',
            ),
          ],
        ),
        Podcast(
          title: 'La Bible expliquée',
          image: 'assets/fa.jpg',
          description: 'Étude approfondie des textes bibliques',
          author: 'Pière Diouf',
          episodes: [
            Episode(
              title: 'Genèse chapitre 1',
              duration: '45:30',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Philosophie et religion',
          image: 'assets/fa.jpg',
          description: 'Dialogue entre philosophie et croyance',
          author: 'Dr. Songué',
          episodes: [
            Episode(
              title: 'Platon et la religion',
              duration: '42:10',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/ImperialMarch.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Témoignages de foi',
          image: 'assets/fa.jpg',
          description: 'Histoires personnelles de conversion et de foi',
          author: 'Communauté',
          episodes: [
            Episode(
              title: 'Mon chemin vers Dieu',
              duration: '29:45',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg.wav',
            ),
          ],
        ),
      ],
    ),
    PodcastCategory(
      name: 'Éducation',
      image: 'assets/bve.jpg',
      color: Color(0xff4CAF50),
      podcasts: [
        Podcast(
          title: 'Apprendre à apprendre',
          image: 'assets/bve.jpg',
          description: 'Méthodes et techniques d\'apprentissage efficaces',
          author: 'Dr. Sarah Cohen',
          episodes: [
            Episode(
              title: 'Les bases de la mémorisation',
              duration: '29:15',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav',
            ),
            Episode(
              title: 'Gestion du temps d\'étude',
              duration: '31:40',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/ImperialMarch.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Éducation numérique',
          image: 'assets/bve.jpg',
          description: 'Les nouvelles technologies dans l\'éducation',
          author: 'Tech Education',
          episodes: [
            Episode(
              title: 'Les outils digitaux',
              duration: '26:55',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Parentalité bienveillante',
          image: 'assets/bve.jpg',
          description: 'Conseils pour une éducation positive',
          author: 'Sophie Parent',
          episodes: [
            Episode(
              title: 'La communication non-violente',
              duration: '33:20',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand3.wav',
            ),
          ],
        ),
      ],
    ),
    PodcastCategory(
      name: 'Motivation',
      image: 'assets/mame.jpg',
      color: Color(0xff2196F3),
      podcasts: [
        Podcast(
          title: 'Dépasser ses limites',
          image: 'assets/mame.jpg',
          description: 'Techniques pour repousser vos limites',
          author: 'Coach Motivation',
          episodes: [
            Episode(
              title: 'Introduction à la motivation',
              duration: '27:30',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Confiance en soi',
          image: 'assets/mame.jpg',
          description: 'Développer une estime de soi solide',
          author: 'Dr. Confidence',
          episodes: [
            Episode(
              title: 'Les piliers de la confiance',
              duration: '29:20',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Objectifs et réussite',
          image: 'assets/mame.jpg',
          description: 'Atteindre ses objectifs efficacement',
          author: 'Success Coach',
          episodes: [
            Episode(
              title: 'La méthode SMART',
              duration: '24:45',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/ImperialMarch.wav',
            ),
          ],
        ),
      ],
    ),
    PodcastCategory(
      name: 'Fiction',
      image: 'assets/fa.jpg',
      color: Color(0xff9C27B0),
      podcasts: [
        Podcast(
          title: 'Histoires courtes',
          image: 'assets/fa.jpg',
          description: 'Nouvelles et histoires courtes',
          author: 'Auteur Fiction',
          episodes: [
            Episode(
              title: 'Première histoire',
              duration: '22:25',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Science-fiction',
          image: 'assets/fa.jpg',
          description: 'Voyages dans le futur et l\'espace',
          author: 'SF Writer',
          episodes: [
            Episode(
              title: 'La nouvelle planète',
              duration: '34:50',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/ImperialMarch.wav',
            ),
          ],
        ),
        Podcast(
          title: 'Fantasy moderne',
          image: 'assets/fa.jpg',
          description: 'Contes fantastiques contemporains',
          author: 'Fantasy Author',
          episodes: [
            Episode(
              title: 'Le royaume caché',
              duration: '28:35',
              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg.wav',
            ),
          ],
        ),
      ],
    ),
  ];

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
  
  void _changePage(String page) {
    setState(() {
      _currentPage = page;
      _isMenuOpen = false;
    });

    switch (page) {
      case 'home':
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

  // MODIFICATION : Navigation vers la page des podcasts d'une catégorie
  void _openCategoryPage(PodcastCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PodcastsPage(category: category),
      ),
    );
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

                    // Featured Podcast - Nouveau design
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Éléments décoratifs
                          Positioned(
                            top: -20,
                            right: -20,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -30,
                            left: -30,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          'EN DIRECT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Spiritualité Moderne',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Épisode spécial • En cours',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: _togglePlayPause,
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                isPlaying ? Icons.pause : Icons.play_arrow,
                                                color: Color(0xFF667EEA),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Écoute en cours',
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.8),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                if (duration != null)
                                                  LinearProgressIndicator(
                                                    value: position.inSeconds / duration!.inSeconds,
                                                    backgroundColor: Colors.white.withOpacity(0.3),
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    minHeight: 3,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: AssetImage('assets/fa.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
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

                    SizedBox(height: 30),

                    // Search Bar
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher un podcast...',
                          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey[600], size: 18),
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
                      SizedBox(height: 15),
                      Text(
                        'Résultats de recherche',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ..._searchResults.map((result) => Card(
                        margin: EdgeInsets.only(bottom: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.audio_file, color: Colors.orange, size: 18),
                          ),
                          title: Text(result, style: TextStyle(fontSize: 14)),
                          subtitle: Text('Podcast • 25 min', style: TextStyle(fontSize: 12)),
                          trailing: Icon(Icons.play_circle_fill, color: Colors.orange, size: 20),
                          onTap: () {},
                        ),
                      )).toList(),
                    ],

                    SizedBox(height: 30),

                    // Categories Grid - Nouveau design
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Catégories",
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Voir tout",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Grid de catégories - Nouvelle disposition
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.3, // Format plus carré
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return CategoryCard(
                          category: category,
                          onTap: () => _openCategoryPage(category), // MODIFICATION
                        );
                      },
                    ),

                    SizedBox(height: 30),
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

  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}

// NOUVELLE PAGE : Page des podcasts d'une catégorie
class PodcastsPage extends StatelessWidget {
  final PodcastCategory category;

  const PodcastsPage({super.key, required this.category});

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
          category.name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de la catégorie
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
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
                        image: AssetImage(category.image),
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
                          category.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${category.podcasts.length} podcasts',
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
            
            // Liste des podcasts - NOUVEAU DESIGN MODERNE
            Text(
              'Tous les podcasts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: category.podcasts.length,
              itemBuilder: (context, index) {
                final podcast = category.podcasts[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      // Image du podcast
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(podcast.image),
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
                                podcast.title,
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
                                podcast.author,
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
                                      color: category.color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${podcast.episodes.length} épisode${podcast.episodes.length > 1 ? 's' : ''}',
                                      style: TextStyle(
                                        color: category.color,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigation vers la page des épisodes
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EpisodesPage(podcast: podcast),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: category.color,
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
    );
  }
}

// NOUVELLE PAGE : Page des épisodes d'un podcast
class EpisodesPage extends StatefulWidget {
  final Podcast podcast;

  const EpisodesPage({super.key, required this.podcast});

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
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
          widget.podcast.title,
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
            // Header du podcast
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(widget.podcast.image),
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
                          widget.podcast.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.podcast.author,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.podcast.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
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
            
            SizedBox(height: 20),
            
            // Liste des épisodes
            Text(
              'Épisodes (${widget.podcast.episodes.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.podcast.episodes.length,
              itemBuilder: (context, index) {
                final episode = widget.podcast.episodes[index];
                return EpisodeCard(
                  episode: episode,
                  categoryColor: Colors.orange, 
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Carte de catégorie pour l'accueil
class CategoryCard extends StatelessWidget {
  final PodcastCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image de fond avec overlay
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: AssetImage(category.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Partie inférieure avec informations
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${category.podcasts.length} podcasts',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: category.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Catégorie',
                            style: TextStyle(
                              color: category.color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: 0.7, // Progression fictive
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(category.color),
                      minHeight: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Carte d'épisode avec fonctionnalités de téléchargement, like et favoris
class EpisodeCard extends StatefulWidget {
  final Episode episode;
  final Color categoryColor;
  final int index;

  const EpisodeCard({
    super.key,
    required this.episode,
    required this.categoryColor,
    required this.index,
  });

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
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
      await _audioPlayer.setUrl(widget.episode.audioUrl);
      
      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            isPlaying = state.playing;
          });
        }
      });

      _audioPlayer.durationStream.listen((d) {
        if (mounted) {
          setState(() {
            duration = d;
          });
        }
      });

      _audioPlayer.positionStream.listen((p) {
        if (mounted) {
          setState(() {
            position = p;
          });
        }
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
      final fileName = '${widget.episode.title.replaceAll(' ', '_')}.mp3';
      final success = await _downloadService.downloadAudio(
        widget.episode.audioUrl,
        fileName,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              downloadProgress = progress;
            });
          }
        },
      );

      if (success && mounted) {
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
      } else if (mounted) {
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
      if (mounted) {
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
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
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
          // Numéro de l'épisode - Design comme dans la capture
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.categoryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${widget.index + 1}',
                style: TextStyle(
                  color: widget.categoryColor,
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
                  widget.episode.title,
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
                  widget.episode.duration,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                
                // Barre de progression et contrôles
                Row(
                  children: [
                    // Bouton play principal
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: widget.categoryColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: widget.categoryColor.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    
                    // Barre de progression
                    if (isPlaying && duration != null)
                      Expanded(
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: widget.categoryColor,
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: widget.categoryColor,
                                trackHeight: 3,
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
                          ],
                        ),
                      )
                    else
                      Spacer(),
                    
                    // Actions secondaires
                    Row(
                      children: [
                        // Like
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey[500],
                            size: 20,
                          ),
                          onPressed: _toggleLiked,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(minWidth: 36),
                        ),
                        
                        // Téléchargement
                        IconButton(
                          icon: isDownloading
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    value: downloadProgress,
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(widget.categoryColor),
                                  ),
                                )
                              : Icon(
                                  isDownloaded ? Icons.download_done : Icons.download,
                                  color: isDownloaded ? Colors.green : Colors.grey[500],
                                  size: 20,
                                ),
                          onPressed: _toggleDownloaded,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(minWidth: 36),
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

// Modèles de données MIS À JOUR
class PodcastCategory {
  final String name;
  final String image;
  final Color color;
  final List<Podcast> podcasts; 

  PodcastCategory({
    required this.name,
    required this.image,
    required this.color,
    required this.podcasts,
  });
}

// NOUVEAU MODÈLE : Podcast
class Podcast {
  final String title;
  final String image;
  final String description;
  final String author;
  final List<Episode> episodes;

  Podcast({
    required this.title,
    required this.image,
    required this.description,
    required this.author,
    required this.episodes,
  });
}

class Episode {
  final String title;
  final String duration;
  final String audioUrl;

  Episode({
    required this.title,
    required this.duration,
    required this.audioUrl,
  });
}