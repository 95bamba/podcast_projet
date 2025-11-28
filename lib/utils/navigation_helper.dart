import 'package:flutter/material.dart';
import '../home_page.dart';
import '../playlist_page.dart';
import '../favorites_page.dart';
import '../profile_page.dart';
import '../settings_page.dart';
import '../about_page.dart';
import '../admin_dashboard_page.dart';

class NavigationHelper {
  static void navigateToPage(
    BuildContext context,
    String targetPage,
    String currentPage,
  ) {
    if (targetPage == currentPage) {
      // Already on this page
      return;
    }

    Widget? page;

    switch (targetPage) {
      case 'home':
        page = const HomePage();
        break;
      case 'playlist':
        page = const PlaylistPage();
        break;
      case 'favorites':
        page = const FavoritesPage();
        break;
      case 'profile':
        page = const ProfilePage();
        break;
      case 'settings':
        page = const SettingsPage();
        break;
      case 'about':
        page = const AboutPage();
        break;
      case 'admin':
        page = const AdminDashboardPage();
        break;
    }

    if (page != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page!,
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
    }
  }
}
