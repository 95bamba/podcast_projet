import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onPageSelected;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with user info
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepOrange, Colors.orange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.deepOrange),
                  ),
                  accountName: Text(
                    state.user.nom,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  accountEmail: Text(state.user.email),
                );
              }

              return DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Galsen ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Podcast',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Découvrez et écoutez',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Primary Pages Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader('Navigation Principale'),
                _buildDrawerItem(
                  context: context,
                  index: 0,
                  icon: Icons.home,
                  title: 'Accueil',
                ),
                _buildDrawerItem(
                  context: context,
                  index: 1,
                  icon: Icons.playlist_play,
                  title: 'Playlists',
                ),
                _buildDrawerItem(
                  context: context,
                  index: 2,
                  icon: Icons.favorite,
                  title: 'Favoris',
                ),
                _buildDrawerItem(
                  context: context,
                  index: 3,
                  icon: Icons.person,
                  title: 'Profil',
                ),

                Divider(height: 1),

                // Secondary Pages Section
                _buildSectionHeader('Plus'),
                _buildDrawerItem(
                  context: context,
                  index: 4,
                  icon: Icons.settings,
                  title: 'Paramètres',
                ),
                _buildDrawerItem(
                  context: context,
                  index: 5,
                  icon: Icons.info,
                  title: 'À propos',
                ),

                // Admin section (conditional)
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated && state.user.role == 'admin') {
                      return Column(
                        children: [
                          Divider(height: 1),
                          _buildSectionHeader('Administration'),
                          _buildDrawerItem(
                            context: context,
                            index: 6,
                            icon: Icons.admin_panel_settings,
                            title: 'Administration',
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          // Footer with version
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String title,
  }) {
    final isSelected = currentIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.deepOrange : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.deepOrange : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.orange[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      onTap: () {
        onPageSelected(index);
        Navigator.pop(context); // Close drawer
      },
    );
  }
}
