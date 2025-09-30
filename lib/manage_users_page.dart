import 'package:flutter/material.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Mame Bamba',
      'email': 'mame@example.com',
      'role': 'Administrateur',
      'status': 'Actif',
      'joinDate': '2024-01-01',
    },
    {
      'id': '2',
      'name': 'Fatou Diop',
      'email': 'fatou@example.com',
      'role': 'Utilisateur',
      'status': 'Actif',
      'joinDate': '2024-01-15',
    },
    {
      'id': '3',
      'name': 'Ibrahima Fall',
      'email': 'ibrahima@example.com',
      'role': 'Modérateur',
      'status': 'Inactif',
      'joinDate': '2024-02-01',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les utilisateurs'),
        backgroundColor: Color.fromARGB(255, 243, 147, 2),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: Implémenter l'ajout d'utilisateur
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un utilisateur...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Liste des utilisateurs
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user['name'][0]),
                    ),
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // TODO: Implémenter la modification
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // TODO: Implémenter la suppression
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 