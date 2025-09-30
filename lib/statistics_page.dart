import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'widgets/hamburger_menu.dart';
import 'home_page.dart' as home;
import 'playlist_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'about_page.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _currentPage = 'statistics';
  bool _isMenuOpen = false;

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

                    // Statistiques générales
                    Text(
                      'Statistiques générales',
                      style: TextStyle(
                        fontSize: 24,
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
                            color: Color.fromARGB(255, 243, 147, 2),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Podcasts',
                            value: '567',
                            icon: Icons.headphones,
                            color: Color.fromARGB(255, 243, 147, 2),
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
                            color: Color.fromARGB(255, 243, 147, 2),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Téléchargements',
                            value: '2,345',
                            icon: Icons.download,
                            color: Color.fromARGB(255, 243, 147, 2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Graphique des écoutes
                    Text(
                      'Écoutes par mois',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 250,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin'];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      months[value.toInt()],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 3),
                                FlSpot(1, 1),
                                FlSpot(2, 4),
                                FlSpot(3, 2),
                                FlSpot(4, 5),
                                FlSpot(5, 3),
                              ],
                              isCurved: true,
                              color: Color.fromARGB(255, 243, 147, 2),
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Color.fromARGB(255, 243, 147, 2).withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Catégories populaires
                    Text(
                      'Catégories populaires',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 250,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: 30,
                              title: 'Religion',
                              color: Color.fromARGB(255, 243, 147, 2),
                              radius: 100,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: 25,
                              title: 'Éducation',
                              color: Color.fromARGB(255, 243, 147, 2).withOpacity(0.8),
                              radius: 100,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: 20,
                              title: 'Motivation',
                              color: Color.fromARGB(255, 243, 147, 2).withOpacity(0.6),
                              radius: 100,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: 15,
                              title: 'Actualités',
                              color: Color.fromARGB(255, 243, 147, 2).withOpacity(0.4),
                              radius: 100,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: 10,
                              title: 'Autres',
                              color: Color.fromARGB(255, 243, 147, 2).withOpacity(0.2),
                              radius: 100,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
} 