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
    bool isActive = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFFF6B35).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? Color(0xFFFF6B35) : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey[700],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: isActive ? Icon(Icons.circle, color: Color(0xFFFF6B35), size: 8) : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Contenu principal
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.black, size: 28),
                        onPressed: _toggleMenu,
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

                  // En-tête de bienvenue
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF6B35).withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 30),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonjour, ${widget.username} 👋',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Administrateur Galsen Podcast',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                  ),
                  SizedBox(height: 30),

                  // Section Statistiques
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aperçu des performances',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Aujourd\'hui',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Grille de statistiques
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildStatCard(
                        title: 'Utilisateurs',
                        value: '1,234',
                        subtitle: '+12% ce mois',
                        icon: Icons.people_alt_rounded,
                        color: Color(0xFF4CAF50),
                        iconBgColor: Color(0xFF4CAF50).withOpacity(0.1),
                      ),
                      _buildStatCard(
                        title: 'Podcasts',
                        value: '567',
                        subtitle: '+8 nouveaux',
                        icon: Icons.headphones_rounded,
                        color: Color(0xFF2196F3),
                        iconBgColor: Color(0xFF2196F3).withOpacity(0.1),
                      ),
                      _buildStatCard(
                        title: 'Écoutes',
                        value: '8,901',
                        subtitle: '+23% aujourd\'hui',
                        icon: Icons.play_circle_fill_rounded,
                        color: Color(0xFFFF9800),
                        iconBgColor: Color(0xFFFF9800).withOpacity(0.1),
                      ),
                      _buildStatCard(
                        title: 'Téléchargements',
                        value: '2,345',
                        subtitle: '+15% cette semaine',
                        icon: Icons.download_rounded,
                        color: Color(0xFF9C27B0),
                        iconBgColor: Color(0xFF9C27B0).withOpacity(0.1),
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
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildActionCard(
                        title: 'Ajouter Podcast',
                        icon: Icons.add_circle_outline_rounded,
                        color: Color(0xFF4CAF50),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddPodcastPage()),
                          );
                        },
                      ),
                      _buildActionCard(
                        title: 'Gérer Utilisateurs',
                        icon: Icons.people_outline_rounded,
                        color: Color(0xFF2196F3),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ManageUsersPage()),
                          );
                        },
                      ),
                      _buildActionCard(
                        title: 'Modérer Contenu',
                        icon: Icons.comment_outlined,
                        color: Color(0xFFFF9800),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ModerateCommentsPage()),
                          );
                        },
                      ),
                      _buildActionCard(
                        title: 'Analytiques',
                        icon: Icons.analytics_outlined,
                        color: Color(0xFF9C27B0),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StatisticsPage()),
                          );
                        },
                      ),
                      _buildActionCard(
                        title: 'Paramètres',
                        icon: Icons.settings_outlined,
                        color: Color(0xFF607D8B),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsPage()),
                          );
                        },
                      ),
                      _buildActionCard(
                        title: 'Support',
                        icon: Icons.help_outline_rounded,
                        color: Color(0xFFFF6B35),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HelpPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Menu latéral
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: 0,
            left: _isMenuOpen ? 0 : -MediaQuery.of(context).size.width * 0.75,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(5, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // En-tête du menu
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          child: Icon(Icons.person, color: Colors.white, size: 24),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.username,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Administrateur',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: _toggleMenu,
                        ),
                      ],
                    ),
                  ),
                  
                  // Options du menu
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      children: [
                        _buildMenuItem(
                          icon: Icons.dashboard_rounded,
                          title: 'Tableau de bord',
                          onTap: () {
                            _toggleMenu();
                          },
                          isActive: true,
                        ),
                        _buildMenuItem(
                          icon: Icons.add_circle_outline_rounded,
                          title: 'Ajouter un podcast',
                          onTap: () {
                            _toggleMenu();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddPodcastPage()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.people_alt_outlined,
                          title: 'Gérer les utilisateurs',
                          onTap: () {
                            _toggleMenu();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ManageUsersPage()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.comment_outlined,
                          title: 'Modérer les commentaires',
                          onTap: () {
                            _toggleMenu();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ModerateCommentsPage()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.analytics_outlined,
                          title: 'Statistiques',
                          onTap: () {
                            _toggleMenu();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StatisticsPage()),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        Divider(indent: 20, endIndent: 20),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Paramètres',
                          onTap: () {
                            _toggleMenu();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SettingsPage()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline_rounded,
                          title: 'Aide & Support',
                          onTap: () {
                            _toggleMenu();
                            Navigator.push(
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
            
          // Overlay pour fermer le menu
          if (_isMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
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
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconBgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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