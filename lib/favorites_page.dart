import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/bloc/auth/auth_bloc.dart';
import 'package:podcast/bloc/auth/auth_state.dart';
import 'package:podcast/models/favorite.dart';
import 'package:podcast/services/favorite_service.dart';
import 'package:podcast/services/api_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Favorite> _favorites = [];
  List<Favorite> _filteredFavorites = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration position = Duration.zero;
  int? currentEpisodeIndex;

  late FavoriteService _favoriteService;
  bool _isLoading = false;
  String? _errorMessage;
  String? _userLogin;

  @override
  void initState() {
    super.initState();
    _favoriteService = FavoriteService(ApiService());
    _initAudioPlayer();
    _loadUserAndFavorites();
  }

  void _loadUserAndFavorites() async {
    // Get user from AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.user != null) {
      _userLogin = authState.user!.login;
      await _loadFavoriteEpisodes();
    } else {
      setState(() {
        _errorMessage = 'Utilisateur non connecté';
      });
    }
  }

  Future<void> _loadFavoriteEpisodes() async {
    if (_userLogin == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _favoriteService.getAllFavorites(_userLogin!);

      if (result['success'] == true) {
        setState(() {
          _favorites = result['favorites'] ?? [];
          _filteredFavorites = _favorites;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Erreur lors du chargement';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: ${e.toString()}';
        _isLoading = false;
      });
    }
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

  Future<void> _playEpisode(int index) async {
    try {
      if (index >= 0 && index < _filteredFavorites.length) {
        final favorite = _filteredFavorites[index];
        final audioUrl = favorite.episode?.audioPath;

        if (audioUrl != null && audioUrl.isNotEmpty) {
          // Build full URL if needed
          final fullUrl = audioUrl.startsWith('http')
              ? audioUrl
              : '${ApiService.baseUrl}/files/getAudio?audioFileUuid=$audioUrl';

          await _audioPlayer.setUrl(fullUrl);
          await _audioPlayer.play();
          setState(() {
            currentEpisodeIndex = index;
            isPlaying = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error playing episode: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la lecture audio'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _playNextEpisode() async {
    if (currentEpisodeIndex != null && currentEpisodeIndex! < _filteredFavorites.length - 1) {
      await _playEpisode(currentEpisodeIndex! + 1);
    } else if (currentEpisodeIndex != null && currentEpisodeIndex! == _filteredFavorites.length - 1) {
      await _playEpisode(0);
    }
  }

  Future<void> _playPreviousEpisode() async {
    if (currentEpisodeIndex != null && currentEpisodeIndex! > 0) {
      await _playEpisode(currentEpisodeIndex! - 1);
    } else if (currentEpisodeIndex != null && currentEpisodeIndex! == 0) {
      await _playEpisode(_filteredFavorites.length - 1);
    }
  }

  void _filterEpisodes(String query) {
    setState(() {
      _filteredFavorites = _favorites
          .where((favorite) {
            final title = favorite.episode?.title ?? '';
            return title.toLowerCase().contains(query.toLowerCase());
          })
          .toList();
    });
  }

  Future<void> _removeFavorite(int index) async {
    if (index < 0 || index >= _filteredFavorites.length) return;

    final favorite = _filteredFavorites[index];

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _favoriteService.deleteFavorite(favorite.uuid);

      if (result['success'] == true) {
        // Reload favorites
        await _loadFavoriteEpisodes();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Épisode retiré des favoris'),
            backgroundColor: Colors.deepOrangeAccent,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erreur lors de la suppression'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Mes ", style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold
                        )),
                        Text("Favoris", style: TextStyle(
                          color: Color(0xFFFF6B35), 
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

                    // Titre et statistiques
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mes Favoris',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_filteredFavorites.length} épisodes',
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Barre de recherche
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterEpisodes,
                        decoration: InputDecoration(
                          hintText: 'Rechercher dans mes favoris...',
                          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey[600], size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterEpisodes('');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),

                    SizedBox(height: 25),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Loading indicator
                    if (_isLoading)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                          ),
                        ),
                      )
                    // Liste des favoris - NOUVEAU DESIGN
                    else if (_filteredFavorites.isEmpty)
                      Container(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucun favori',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ajoutez des épisodes à vos favoris',
                              style: TextStyle(
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredFavorites.length,
                        itemBuilder: (context, index) {
                          final favorite = _filteredFavorites[index];
                          final episode = favorite.episode;
                          final isCurrentEpisode = currentEpisodeIndex == index;

                          // Default values if episode is null
                          final title = episode?.title ?? 'Episode sans titre';
                          final duration = episode?.duration ?? '--:--';
                          final Color episodeColor = Colors.deepOrangeAccent;
                          
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isCurrentEpisode ? episodeColor : Colors.grey[200]!,
                                width: isCurrentEpisode ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon placeholder instead of image
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: episodeColor.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    Icons.music_note,
                                    color: episodeColor,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),

                                // Contenu de l'épisode
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        episode?.description ?? '',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: episodeColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              duration,
                                              style: TextStyle(
                                                color: episodeColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          // Boutons d'action
                                          Row(
                                            children: [
                                              // Bouton play
                                              GestureDetector(
                                                onTap: () => _playEpisode(index),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: episodeColor,
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Icon(
                                                    isCurrentEpisode && isPlaying ? Icons.pause : Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              // Bouton supprimer
                                              GestureDetector(
                                                onTap: () => _removeFavorite(index),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}