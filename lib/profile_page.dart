import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'widgets/hamburger_menu.dart';
import 'login_page.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'utils/navigation_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration position = Duration.zero;
  
  String _currentPage = 'profile';
  bool _isMenuOpen = false;

  // Statistiques de l'utilisateur
  final Map<String, dynamic> _userStats = {
    'episodesEcoutes': 127,
    'heuresEcoutees': 45,
    'categoriesPreferees': 8,
  };

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
    NavigationHelper.navigateToPage(context, page, _currentPage);
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
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header avec fond gradient
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF667EEA),
                          Color(0xFF764BA2),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header Row
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
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
                                  color: Colors.white, 
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold
                                )),
                                Text("o", style: TextStyle(
                                  color: Color(0xFFFFD700), 
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold
                                )),
                                Text("dcast", style: TextStyle(
                                  color: Colors.white, 
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
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: Icon(Icons.notifications_outlined, color: Colors.white),
                            ),
                          ],
                        ),

                        SizedBox(height: 30),

                        // Section Profil
                        Column(
                          children: [
                            // Avatar avec badge
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 56,
                                    backgroundImage: AssetImage('assets/fa.jpg'),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFD700),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'PRO',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Informations utilisateur
                            Text(
                              'Galsen Podcast',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Podcasteur Passionné',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Accès Administrateur',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // Contenu principal
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Bouton de déconnexion/connexion basé sur l'état d'authentification
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isAuthenticated = state is AuthAuthenticated;

                            return Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isAuthenticated
                                    ? [Color(0xFFE53935), Color(0xFFD32F2F)]
                                    : [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isAuthenticated
                                      ? Color(0xFFE53935)
                                      : Color(0xFFFF6B35)).withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(28),
                                  onTap: () {
                                    if (isAuthenticated) {
                                      // Afficher un dialogue de confirmation
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) => AlertDialog(
                                          title: Text('Déconnexion'),
                                          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(dialogContext),
                                              child: Text('Annuler'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(dialogContext);
                                                context.read<AuthBloc>().add(AuthLogoutRequested());
                                              },
                                              child: Text(
                                                'Déconnexion',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginPage()),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isAuthenticated ? Icons.logout : Icons.login,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        isAuthenticated ? 'Se déconnecter' : 'Se connecter',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 30),

                        // Statistiques
                        Text(
                          'Mes Statistiques',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Grid des statistiques
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            List<Map<String, dynamic>> stats = [
                              {
                                'value': _userStats['episodesEcoutes'].toString(),
                                'label': 'Épisodes\nÉcoutés',
                                'icon': Icons.play_circle_fill,
                                'color': Color(0xFF667EEA),
                              },
                              {
                                'value': _userStats['heuresEcoutees'].toString(),
                                'label': 'Heures\nÉcoutées',
                                'icon': Icons.timer,
                                'color': Color(0xFF4CAF50),
                              },
                              {
                                'value': _userStats['categoriesPreferees'].toString(),
                                'label': 'Catégories\nPréférées',
                                'icon': Icons.category,
                                'color': Color(0xFFFF6B35),
                              },
                            ];

                            return _buildStatCard(stats[index]);
                          },
                        ),

                        SizedBox(height: 30),

                        // Section activité récente
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.history, color: Color(0xFF667EEA), size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Activité Récente',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              _buildActivityItem('Spiritualité Moderne', 'Aujourd\'hui • 25:30'),
                              _buildActivityItem('Dépasser ses limites', 'Hier • 27:30'),
                              _buildActivityItem('Apprendre à apprendre', '23 Oct • 29:15'),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

                        // Options rapides
                        Text(
                          'Options Rapides',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            List<Map<String, dynamic>> options = [
                              {
                                'title': 'Mes Abonnements',
                                'icon': Icons.subscriptions,
                                'color': Color(0xFF667EEA),
                              },
                              {
                                'title': 'Téléchargements',
                                'icon': Icons.download,
                                'color': Color(0xFF4CAF50),
                              },
                              {
                                'title': 'Historique',
                                'icon': Icons.history,
                                'color': Color(0xFFFF6B35),
                              },
                              {
                                'title': 'Paramètres',
                                'icon': Icons.settings,
                                'color': Color(0xFF9C27B0),
                              },
                            ];

                            return _buildQuickOption(options[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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
            parentContext: context,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: stat['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              stat['icon'],
              color: stat['color'],
              size: 24,
            ),
          ),
          SizedBox(height: 10),
          Text(
            stat['value'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          Text(
            stat['label'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.play_arrow,
              color: Color(0xFF667EEA),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOption(Map<String, dynamic> option) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // Action selon l'option
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: option['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    option['icon'],
                    color: option['color'],
                    size: 20,
                  ),
                ),
                Text(
                  option['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}