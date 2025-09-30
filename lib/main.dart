import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

// Import des pages
import 'home_page.dart' as home;
import 'playlist_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'about_page.dart';
import 'widgets/hamburger_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure l'audio session
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galsen Podcast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const home.HomePage(),
    const PlaylistPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleSearchTap(BuildContext context) {
    showSearch(
      context: context,
      delegate: PodcastSearchDelegate(),
    );
  }

  void _handleCategoryTap(BuildContext context, String category) {
    // Navigation vers la page de catégorie
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(category: category),
      ),
    );
  }

  void _handlePodcastTap(BuildContext context, String podcastId) {
    // Navigation vers la page de détail du podcast
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PodcastDetailPage(podcastId: podcastId),
      ),
    );
  }

  void _handlePlaylistTap(BuildContext context, String playlistId) {
    // Navigation vers la page de détail de la playlist
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistDetailPage(playlistId: playlistId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Playlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Classe pour la recherche de podcasts
class PodcastSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Afficher les résultats de recherche
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.audio_file),
          title: Text('Résultat de recherche $index'),
          onTap: () {
            // Navigation vers le podcast
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Afficher les suggestions de recherche
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text('Suggestion $index'),
          onTap: () {
            query = 'Suggestion $index';
          },
        );
      },
    );
  }
}

// Page de catégorie
class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.audio_file),
            title: Text('Podcast $index'),
            subtitle: Text('Catégorie: $category'),
            onTap: () {
              // Navigation vers le podcast
            },
          );
        },
      ),
    );
  }
}

// Page de détail du podcast
class PodcastDetailPage extends StatelessWidget {
  final String podcastId;

  const PodcastDetailPage({super.key, required this.podcastId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Podcast'),
      ),
      body: Center(
        child: Text('Détails du podcast $podcastId'),
      ),
    );
  }
}

// Page de détail de la playlist
class PlaylistDetailPage extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Playlist'),
      ),
      body: Center(
        child: Text('Détails de la playlist $playlistId'),
      ),
    );
  }
}