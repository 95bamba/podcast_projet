import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'Comment ajouter un podcast ?',
      'answer': 'Pour ajouter un podcast, allez dans le menu "Ajouter un podcast" et remplissez le formulaire avec les informations requises.',
    },
    {
      'question': 'Comment gérer les utilisateurs ?',
      'answer': 'Dans la section "Gérer les utilisateurs", vous pouvez voir la liste des utilisateurs, ajouter, modifier ou supprimer des utilisateurs.',
    },
    {
      'question': 'Comment modérer les commentaires ?',
      'answer': 'La section "Modérer les commentaires" vous permet d\'approuver, signaler ou supprimer les commentaires des utilisateurs.',
    },
    {
      'question': 'Comment voir les statistiques ?',
      'answer': 'Les statistiques sont disponibles dans la section "Statistiques" où vous pouvez voir les écoutes, les téléchargements et d\'autres métriques.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 147, 2),
        title: Text('Aide'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section FAQ
            Text(
              'Questions fréquentes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ..._faqs.map((faq) {
              return Card(
                margin: EdgeInsets.only(bottom: 15),
                child: ExpansionTile(
                  title: Text(
                    faq['question'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(faq['answer']),
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 30),

            // Section Contact
            Text(
              'Contactez-nous',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email'),
                      subtitle: Text('support@galsenpodcast.com'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Téléphone'),
                      subtitle: Text('+221 77 123 45 67'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Adresse'),
                      subtitle: Text('Dakar, Sénégal'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Section Rapport de bug
            Text(
              'Signaler un problème',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Sujet',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Description du problème',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 243, 147, 2),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        // TODO: Implémenter l'envoi du rapport
                      },
                      child: Text('Envoyer le rapport'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 