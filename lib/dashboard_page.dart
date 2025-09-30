import 'package:flutter/material.dart';
import 'home_page.dart' as home;
import 'add_podcast_page.dart';
import 'manage_users_page.dart';
import 'moderate_comments_page.dart';
import 'statistics_page.dart';
import 'settings_page.dart';
import 'help_page.dart';

class DashboardPage extends StatefulWidget {
  final String username;

  const DashboardPage({super.key, required this.username});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Color.fromARGB(255, 243, 147, 2),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 147, 2),
        title: Text('Tableau de bord'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: _toggleMenu,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => home.HomePage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Contenu principal
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête de bienvenue
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 243, 147, 2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color.fromARGB(255, 243, 147, 2),
                        child: Icon(Icons.person, size: 35, color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bienvenue sur Galsen_Podcast, ${widget.username}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Administrateur',
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
                SizedBox(height: 30),

                // Statistiques
                Text(
                  'Statistiques',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Utilisateurs',
                        value: '1,234',
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Podcasts',
                        value: '567',
                        icon: Icons.headphones,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Écoutes',
                        value: '8,901',
                        icon: Icons.play_circle,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Téléchargements',
                        value: '2,345',
                        icon: Icons.download,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Actions rapides
                Text(
                  'Actions rapides',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.5,
                  children: [
                    _buildActionCard(
                      title: 'Ajouter un podcast',
                      icon: Icons.add_circle,
                      color: Colors.green,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AddPodcastPage()),
                        );
                      },
                    ),
                    _buildActionCard(
                      title: 'Gérer les utilisateurs',
                      icon: Icons.people_alt,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ManageUsersPage()),
                        );
                      },
                    ),
                    _buildActionCard(
                      title: 'Modérer les commentaires',
                      icon: Icons.comment,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ModerateCommentsPage()),
                        );
                      },
                    ),
                    _buildActionCard(
                      title: 'Voir les rapports',
                      icon: Icons.bar_chart,
                      color: Colors.purple,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => StatisticsPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu latéral
          if (_isMenuOpen)
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(5, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // En-tête du menu
                    Container(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, bottom: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color.fromARGB(255, 243, 147, 2), Colors.deepOrangeAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person, size: 35, color: Colors.deepOrangeAccent),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.username,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Administrateur',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.white),
                                  onPressed: _toggleMenu,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Options du menu
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildMenuItem(
                            icon: Icons.dashboard,
                            title: 'Tableau de bord',
                            onTap: () {
                              setState(() {
                                _isMenuOpen = false;
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => DashboardPage(username: widget.username)),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.add_circle,
                            title: 'Ajouter un podcast',
                            onTap: () {
                              setState(() {
                                _isMenuOpen = false;
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => AddPodcastPage()),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.people_alt,
                            title: 'Gérer les utilisateurs',
                            onTap: () {
                              setState(() {
                                _isMenuOpen = false;
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ManageUsersPage()),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.comment,
                            title: 'Modérer les commentaires',
                            onTap: () {
                              setState(() {
                                _isMenuOpen = false;
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ModerateCommentsPage()),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.bar_chart,
                            title: 'Statistiques',
                            onTap: () {
                              setState(() {
                                _isMenuOpen = false;
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => StatisticsPage()),
                              );
                            },
                          ),
                          Divider(),
                          _buildMenuItem(
                            icon: Icons.settings,
                            title: 'Paramètres',
                            onTap: () {
                              setState(() {
                                _isMenuOpen = false;
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SettingsPage()),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.help,
                            title: 'Aide',
                            onTap: () {
                              setState(() {
                                _isMenuOpen = false;
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HelpPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          // Overlay pour fermer le menu en cliquant en dehors
          if (_isMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 40),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}