import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import services
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'repositories/category_repository.dart';
import 'repositories/podcast_repository.dart';
import 'repositories/episode_repository.dart';

// Import BLoCs
import 'bloc/auth/auth_bloc.dart';
import 'bloc/category/category_bloc.dart';
import 'bloc/podcast/podcast_bloc.dart';
import 'bloc/episode/episode_bloc.dart';

// Import des pages
import 'login_page.dart';
import 'home_page.dart' as home;
import 'playlist_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'about_page.dart';
import 'admin_dashboard_page.dart';
import 'widgets/app_drawer.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/auth/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Configure l'audio session
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final apiService = ApiService();
    final authService = AuthService(apiService);
    final categoryRepository = CategoryRepository(apiService);
    final podcastRepository = PodcastRepository(apiService);
    final episodeRepository = EpisodeRepository(apiService);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: apiService),
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: categoryRepository),
        RepositoryProvider.value(value: podcastRepository),
        RepositoryProvider.value(value: episodeRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authService),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(categoryRepository),
          ),
          BlocProvider(
            create: (context) => PodcastBloc(podcastRepository),
          ),
          BlocProvider(
            create: (context) => EpisodeBloc(episodeRepository),
          ),
        ],
        child: MaterialApp(
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
          home: const AuthChecker(),
        ),
      ),
    );
  }
}

// Widget pour vérifier l'authentification au démarrage
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  StreamSubscription<void>? _tokenExpirationSubscription;

  @override
  void initState() {
    super.initState();
    // Vérifier l'authentification au démarrage
    context.read<AuthBloc>().add(AuthCheckRequested());

    // Listen for token expiration
    _tokenExpirationSubscription = ApiService.onTokenExpired.listen((_) {
      _handleTokenExpired();
    });
  }

  @override
  void dispose() {
    _tokenExpirationSubscription?.cancel();
    super.dispose();
  }

  void _handleTokenExpired() {
    if (!mounted) return;

    // Show message to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre session a expiré. Veuillez vous reconnecter.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    // Trigger logout through BLoC
    context.read<AuthBloc>().add(AuthLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          // Afficher un splash screen pendant la vérification
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          return const MainScreen();
        }

        return const LoginPage();
      },
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
  StreamSubscription<void>? _tokenExpirationSubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const home.HomePage(),      // 0 - Accueil
    const PlaylistPage(),       // 1 - Playlist
    const FavoritesPage(),      // 2 - Favoris
    const ProfilePage(),        // 3 - Profil
    const SettingsPage(),       // 4 - Paramètres
    const AboutPage(),          // 5 - À propos
    const AdminDashboardPage(), // 6 - Administration
  ];

  @override
  void initState() {
    super.initState();
    // Listen for token expiration
    _tokenExpirationSubscription = ApiService.onTokenExpired.listen((_) {
      _handleTokenExpired();
    });
  }

  @override
  void dispose() {
    _tokenExpirationSubscription?.cancel();
    super.dispose();
  }

  void _handleTokenExpired() {
    if (!mounted) return;

    // Show message to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre session a expiré. Veuillez vous reconnecter.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    // Trigger logout through BLoC
    context.read<AuthBloc>().add(AuthLogoutRequested());

    // Navigate to login page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onDrawerPageSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if current page should show bottom nav
    // Bottom nav only shown for primary 4 pages (Home, Playlist, Favorites, Profile)
    final showBottomNav = _selectedIndex < 4;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Galsen ',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Podcast',
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Handle notifications
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        currentIndex: _selectedIndex,
        onPageSelected: _onDrawerPageSelected,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? BottomNavigationBar(
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
            )
          : null,
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
