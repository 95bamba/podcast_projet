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
  String? _selectedCategory;
  String? _selectedImage;

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un podcast'),
        backgroundColor: Color.fromARGB(255, 243, 147, 2),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre du podcast',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Auteur
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Auteur',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un auteur';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Catégorie
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
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
              ),
              SizedBox(height: 20),

              // Image
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _selectedImage != null
                    ? Image.network(_selectedImage!, fit: BoxFit.cover)
                    : Center(
                        child: TextButton.icon(
                          icon: Icon(Icons.add_photo_alternate),
                          label: Text('Ajouter une image'),
                          onPressed: () {
                            // TODO: Implémenter la sélection d'image
                          },
                        ),
                      ),
              ),
              SizedBox(height: 30),

              // Bouton de soumission
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Implémenter la logique de sauvegarde
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Podcast ajouté avec succès')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 243, 147, 2),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Ajouter le podcast',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 