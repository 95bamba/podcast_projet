import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'widgets/hamburger_menu.dart';
import 'home_page.dart' as home;
import 'playlist_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'about_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration position = Duration.zero;
  
  String _currentPage = 'settings';
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
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const FavoritesPage(),
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
            pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
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
        // On est déjà sur la page des paramètres
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

                    // Titre de la page
                    Text(
                      'Paramètres',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Liste des paramètres
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5, // Exemple avec 5 paramètres
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Paramètre ${index + 1}'),
                            subtitle: Text('Description du paramètre ${index + 1}'),
                            trailing: Switch(
                              value: true, // Exemple de valeur
                              onChanged: (value) {
                                // Logique pour changer le paramètre
                              },
                            ),
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
    _audioPlayer.dispose();
    super.dispose();
  }
}