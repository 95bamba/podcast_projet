import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'widgets/hamburger_menu.dart';
import 'home_page.dart' as home;
import 'playlist_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration position = Duration.zero;
  
  String _currentPage = 'about';
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
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
            pageBuilder: (context, animation, secondaryAnimation) => PlaylistPage(),
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
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => FavoritesPage(),
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
      case 'profile':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
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
      case 'settings':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
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
      case 'about':
        // On est déjà sur la page À propos
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

                    // Titre de la page
                    Text(
                      'À propos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Contenu À propos
                    Card(
                      margin: EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Galsen_Podcast',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Description de l\'application',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Galsen_Podcast est une application de streaming audio qui vous permet d\'écouter vos podcasts préférés. L\'application offre une expérience utilisateur intuitive et des fonctionnalités avancées pour une écoute optimale.',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Développeur',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Mame Bamba',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Contact',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Email: contact@galsenpodcast.com',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Site web: www.galsenpodcast.com',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
} 