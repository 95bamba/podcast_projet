import 'package:flutter/material.dart';

class AddPodcastPage extends StatefulWidget {
  const AddPodcastPage({super.key});

  @override
  State<AddPodcastPage> createState() => _AddPodcastPageState();
}

class _AddPodcastPageState extends State<AddPodcastPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authorController = TextEditingController();
  final _durationController = TextEditingController();
  String? _selectedCategory;
  String? _selectedImage;
  bool _isLoading = false;

  final List<String> _categories = [
    'Religion et Spiritualité',
    'Éducation et Apprentissage',
    'Motivation et Développement',
    'Actualités',
    'Divertissement',
    'Technologie',
    'Santé et Bien-être',
    'Business',
    'Arts',
    'Sports'
  ];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulation d'un traitement
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Podcast ajouté avec succès'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      
      Navigator.pop(context);
    }
  }

  void _selectImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choisir une image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: Color(0xFFFF6B35)),
              title: Text('Galerie'),
              onTap: () {
                // TODO: Implémenter la sélection depuis la galerie
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(0xFFFF6B35)),
              title: Text('Appareil photo'),
              onTap: () {
                // TODO: Implémenter la prise de photo
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Nouveau Podcast',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFFF6B35),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              SizedBox(height: 32),

              // Formulaire
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFFF6B35).withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            Icons.add_circle_outline,
            color: Color(0xFFFF6B35),
            size: 32,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Créer un nouveau podcast',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Remplissez les informations de votre podcast',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        // Titre
        _buildFormField(
          controller: _titleController,
          label: 'Titre du podcast',
          hintText: 'Entrez le titre de votre podcast',
          icon: Icons.title,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un titre';
            }
            return null;
          },
        ),
        SizedBox(height: 20),

        // Auteur
        _buildFormField(
          controller: _authorController,
          label: 'Auteur',
          hintText: 'Nom de l\'auteur ou de l\'organisation',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un auteur';
            }
            return null;
          },
        ),
        SizedBox(height: 20),

        // Durée - CORRIGÉ : pas de validator requis car optionnel
        _buildFormField(
          controller: _durationController,
          label: 'Durée',
          hintText: 'Ex: 30:15',
          icon: Icons.timer,
          isOptional: true,
        ),
        SizedBox(height: 20),

        // Catégorie
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Catégorie',
              hintText: 'Sélectionnez une catégorie',
              prefixIcon: Icon(Icons.category, color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(
                  category,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez sélectionner une catégorie';
              }
              return null;
            },
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(15),
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey[500]),
          ),
        ),
        SizedBox(height: 20),

        // Description
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Décrivez votre podcast...',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.description, color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une description';
              }
              if (value.length < 50) {
                return 'La description doit contenir au moins 50 caractères';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 20),

        // Upload d'image
        _buildImageUpload(),
        SizedBox(height: 32),

        // Bouton de soumission
        _buildSubmitButton(),
      ],
    );
  }

  // MÉTHODE CORRIGÉE : paramètre validator rendu optionnel
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator, // Rendu optionnel avec ?
    bool isOptional = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label + (isOptional ? ' (optionnel)' : ''),
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator, // Maintenant optionnel
      ),
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image du podcast',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: _selectImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    ),
                  )
                : _buildImagePlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFFF6B35).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add_photo_alternate,
            color: Color(0xFFFF6B35),
            size: 32,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Ajouter une image',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Cliquez pour sélectionner',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF6B35),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Créer le podcast',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}