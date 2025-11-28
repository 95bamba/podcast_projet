import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:podcast/services/api_service.dart';

class AddEpisodePage extends StatefulWidget {
  final String? podcastUuid;
  final String? podcastName;

  const AddEpisodePage({super.key, this.podcastUuid, this.podcastName});

  @override
  State<AddEpisodePage> createState() => _AddEpisodePageState();
}

class _AddEpisodePageState extends State<AddEpisodePage> {
  final _formKey = GlobalKey<FormState>();
  final _libelleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _podcastDisplayController = TextEditingController();

  File? _selectedAudioFile;
  String? _audioFileName;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  String? _podcastUuid;

  @override
  void initState() {
    super.initState();
    if (widget.podcastUuid != null) {
      _podcastUuid = widget.podcastUuid;
      // Afficher le nom du podcast si disponible, sinon l'UUID
      _podcastDisplayController.text = widget.podcastName ?? widget.podcastUuid!;
    }
    _apiService.loadToken();
  }

  @override
  void dispose() {
    _libelleController.dispose();
    _descriptionController.dispose();
    _podcastDisplayController.dispose();
    super.dispose();
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'wav', 'aac', 'ogg', 'flac'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedAudioFile = File(result.files.single.path!);
          _audioFileName = result.files.single.name;
        });
      }
    } catch (e) {
      _showErrorDialog('Erreur lors de la sélection du fichier: $e');
    }
  }

  Future<void> _createEpisode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAudioFile == null) {
      _showErrorDialog('Veuillez sélectionner un fichier audio');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.uploadFile(
        '/episode/createEpisode',
        {
          'libelle': _libelleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'podcast_uuid': _podcastUuid ?? '',
        },
        _selectedAudioFile,
        fileFieldName: 'file',
        method: 'POST',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog('Épisode créé avec succès !');
      } else {
        _showErrorDialog(
          'Erreur lors de la création: ${response.data?.toString() ?? "Erreur inconnue"}',
        );
      }
    } catch (e) {
      _showErrorDialog('Erreur: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('Succès'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer le dialog
              Navigator.pop(context, true); // Retourner à la page précédente avec succès
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('Erreur'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ajouter un épisode',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Illustration
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),

                // Champ Libellé
                Text(
                  'Nom de l\'épisode',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _libelleController,
                  decoration: InputDecoration(
                    hintText: 'Ex: Épisode 1 - Introduction',
                    prefixIcon: Icon(Icons.title, color: Color(0xFFFF6B35)),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le nom de l\'épisode est requis';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Champ Description
                Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Décrivez votre épisode...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(Icons.description, color: Color(0xFFFF6B35)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La description est requise';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Champ Podcast
                Text(
                  'Podcast',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _podcastDisplayController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Sélectionnez un podcast',
                    prefixIcon: Icon(Icons.podcasts, color: Color(0xFFFF6B35)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (_podcastUuid == null || _podcastUuid!.isEmpty) {
                      return 'Le podcast est requis';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Sélection du fichier audio
                Text(
                  'Fichier Audio',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: _pickAudioFile,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedAudioFile != null
                            ? Color(0xFFFF6B35)
                            : Colors.grey[300]!,
                        width: _selectedAudioFile != null ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _selectedAudioFile != null
                              ? Icons.audio_file
                              : Icons.cloud_upload,
                          size: 48,
                          color: _selectedAudioFile != null
                              ? Color(0xFFFF6B35)
                              : Colors.grey[400],
                        ),
                        SizedBox(height: 12),
                        Text(
                          _audioFileName ?? 'Cliquez pour sélectionner un fichier audio',
                          style: TextStyle(
                            color: _selectedAudioFile != null
                                ? Colors.black87
                                : Colors.grey[600],
                            fontWeight: _selectedAudioFile != null
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_selectedAudioFile != null) ...[
                          SizedBox(height: 8),
                          Text(
                            'Formats acceptés: MP3, M4A, WAV, AAC, OGG, FLAC',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Bouton Créer
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createEpisode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Color(0xFFFF6B35).withOpacity(0.3),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Créer l\'épisode',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
    );
  }
}
