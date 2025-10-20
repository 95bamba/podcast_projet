import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  final String currentPage;
  final Function(String) onPageChange;
  final bool isMenuOpen;
  final Function(bool) onMenuToggle;

  const HamburgerMenu({
    Key? key,
    required this.currentPage,
    required this.onPageChange,
    required this.isMenuOpen,
    required this.onMenuToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: isMenuOpen ? 0 : -300,
      top: 0,
      bottom: 0,
      width: 300,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.orange,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => onMenuToggle(false),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    context,
                    'Accueil',
                    'home',
                    Icons.home,
                  ),
                  _buildMenuItem(
                    context,
                    'Playlists',
                    'playlist',
                    Icons.playlist_play,
                  ),
                  _buildMenuItem(
                    context,
                    'Favoris',
                    'favorites',
                    Icons.favorite,
                  ),
                  _buildMenuItem(
                    context,
                    'Profil',
                    'profile',
                    Icons.person,
                  ),
                  _buildMenuItem(
                    context,
                    'Paramètres',
                    'settings',
                    Icons.settings,
                  ),
                  _buildMenuItem(
                    context,
                    'À propos',
                    'about',
                    Icons.info,
                  ),
                  const Divider(),
                  _buildMenuItem(
                    context,
                    'Administration',
                    'admin',
                    Icons.admin_panel_settings,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String pageName,
    IconData icon,
  ) {
    final isSelected = currentPage == pageName;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.orange : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.orange : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        onPageChange(pageName);
        onMenuToggle(false);
      },
    );
  }
} 