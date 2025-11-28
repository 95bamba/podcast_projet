import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcast/bloc/podcast/podcast_bloc.dart';
import 'package:podcast/bloc/podcast/podcast_event.dart';
import 'package:podcast/bloc/podcast/podcast_state.dart';
import 'package:podcast/bloc/category/category_bloc.dart';
import 'package:podcast/bloc/category/category_event.dart';
import 'package:podcast/bloc/category/category_state.dart';
import 'package:podcast/models/podcast.dart';
import 'package:podcast/models/category.dart';
import 'package:podcast/services/media_service.dart';

class AdminPodcastsPage extends StatefulWidget {
  const AdminPodcastsPage({super.key});

  @override
  State<AdminPodcastsPage> createState() => _AdminPodcastsPageState();
}

class _AdminPodcastsPageState extends State<AdminPodcastsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PodcastBloc>().add(PodcastLoadAllRequested());
    context.read<CategoryBloc>().add(CategoryLoadRequested());
  }

  void _showCreatePodcastDialog() {
    showDialog(
      context: context,
      builder: (context) => const _PodcastFormDialog(),
    );
  }

  void _showEditPodcastDialog(Podcast podcast) {
    showDialog(
      context: context,
      builder: (context) => _PodcastFormDialog(podcast: podcast),
    );
  }

  void _deletePodcast(Podcast podcast) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer "${podcast.libelle}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              this.context.read<PodcastBloc>().add(
                    PodcastDeleteRequested(podcast.uuid),
                  );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Podcasts'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PodcastBloc>().add(PodcastLoadAllRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<PodcastBloc, PodcastState>(
        listener: (context, state) {
          if (state is PodcastOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is PodcastError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PodcastLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B35),
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
                    Icon(Icons.podcasts, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    Text(
                      'Aucun podcast',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: podcasts.length,
              itemBuilder: (context, index) {
                final podcast = podcasts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                        image: podcast.imagePath != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  MediaService.getImageUrl(podcast.imagePath),
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: podcast.imagePath == null
                          ? Icon(Icons.podcasts,
                              color: Colors.orange[700], size: 30)
                          : null,
                    ),
                    title: Text(
                      podcast.libelle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      podcast.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditPodcastDialog(podcast),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePodcast(podcast),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePodcastDialog,
        backgroundColor: const Color(0xFFFF6B35),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _PodcastFormDialog extends StatefulWidget {
  final Podcast? podcast;

  const _PodcastFormDialog({this.podcast});

  @override
  State<_PodcastFormDialog> createState() => _PodcastFormDialogState();
}

class _PodcastFormDialogState extends State<_PodcastFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _libelleController;
  late TextEditingController _descriptionController;
  File? _selectedImage;
  Category? _selectedCategory;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _libelleController =
        TextEditingController(text: widget.podcast?.libelle ?? '');
    _descriptionController =
        TextEditingController(text: widget.podcast?.description ?? '');
  }

  @override
  void dispose() {
    _libelleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une catégorie'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (widget.podcast == null) {
        // Create - L'image est obligatoire
        if (_selectedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez sélectionner une image de couverture'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        context.read<PodcastBloc>().add(
              PodcastCreateRequested(
                libelle: _libelleController.text.trim(),
                description: _descriptionController.text.trim(),
                categoryUuid: _selectedCategory!.uuid,
                image: _selectedImage!,
              ),
            );
      } else {
        // Update - L'image est optionnelle
        context.read<PodcastBloc>().add(
              PodcastUpdateRequested(
                uuid: widget.podcast!.uuid,
                libelle: _libelleController.text.trim(),
                description: _descriptionController.text.trim(),
                categoryUuid: _selectedCategory!.uuid,
                image: _selectedImage,
              ),
            );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.podcast != null;

    return AlertDialog(
      title: Text(isEdit ? 'Modifier le podcast' : 'Nouveau podcast'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : (widget.podcast?.imagePath != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  MediaService.getImageUrl(
                                      widget.podcast!.imagePath),
                                ),
                                fit: BoxFit.cover,
                              )
                            : null),
                  ),
                  child: _selectedImage == null &&
                          widget.podcast?.imagePath == null
                      ? Icon(Icons.add_photo_alternate,
                          size: 40, color: Colors.grey[400])
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Libellé
              TextFormField(
                controller: _libelleController,
                decoration: const InputDecoration(
                  labelText: 'Titre du podcast',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le titre est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La description est requise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category selector
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    // Initialiser la catégorie sélectionnée en mode édition
                    if (widget.podcast != null && _selectedCategory == null) {
                      _selectedCategory = state.categories.firstWhere(
                        (cat) => cat.uuid == widget.podcast!.categoryUuid,
                        orElse: () => state.categories.first,
                      );
                    }

                    return DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Catégorie',
                        border: OutlineInputBorder(),
                      ),
                      items: state.categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.libelle),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner une catégorie';
                        }
                        return null;
                      },
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
          ),
          child: Text(isEdit ? 'Modifier' : 'Créer'),
        ),
      ],
    );
  }
}
