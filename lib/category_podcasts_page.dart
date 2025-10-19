import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/podcast/podcast_bloc.dart';
import 'bloc/podcast/podcast_event.dart';
import 'bloc/podcast/podcast_state.dart';
import 'models/category.dart';
import 'models/podcast.dart';
import 'podcast_detail_page.dart';

class CategoryPodcastsPage extends StatefulWidget {
  final Category category;

  const CategoryPodcastsPage({super.key, required this.category});

  @override
  State<CategoryPodcastsPage> createState() => _CategoryPodcastsPageState();
}

class _CategoryPodcastsPageState extends State<CategoryPodcastsPage> {
  @override
  void initState() {
    super.initState();
    // Charger les podcasts de cette catégorie
    context.read<PodcastBloc>().add(
          PodcastLoadByCategoryRequested(widget.category.uuid),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.category.libelle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PodcastBloc>().add(
                    PodcastLoadByCategoryRequested(widget.category.uuid),
                  );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description de la catégorie
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Liste des podcasts
          Expanded(
            child: BlocBuilder<PodcastBloc, PodcastState>(
              builder: (context, state) {
                if (state is PodcastLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                }

                if (state is PodcastError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 60, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Erreur de chargement',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<PodcastBloc>().add(
                                    PodcastLoadByCategoryRequested(
                                        widget.category.uuid),
                                  );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Réessayer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is PodcastLoaded) {
                  final podcasts = state.podcasts;

                  if (podcasts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.podcasts,
                              size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun podcast dans cette catégorie',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: podcasts.length,
                    itemBuilder: (context, index) {
                      final podcast = podcasts[index];
                      return _buildPodcastCard(podcast);
                    },
                  );
                }

                return const Center(
                  child: Text('Chargement...'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcastCard(Podcast podcast) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers la page de détail du podcast
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PodcastDetailPageWithAudio(podcast: podcast),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image du podcast
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.podcasts,
                color: Colors.orange[700],
                size: 32,
              ),
            ),
            const SizedBox(width: 15),

            // Informations du podcast
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast.libelle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    podcast.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Icône play
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.orange[700],
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
