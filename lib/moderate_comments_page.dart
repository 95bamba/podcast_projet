import 'package:flutter/material.dart';

class ModerateCommentsPage extends StatefulWidget {
  const ModerateCommentsPage({super.key});

  @override
  State<ModerateCommentsPage> createState() => _ModerateCommentsPageState();
}

class _ModerateCommentsPageState extends State<ModerateCommentsPage> {
  final List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'user': 'Mame Bamba',
      'content': 'Excellent podcast ! J\'ai beaucoup appris.',
      'podcast': 'Introduction à la spiritualité',
      'date': '2024-03-01',
      'status': 'En attente',
    },
    {
      'id': '2',
      'user': 'Fatou Diop',
      'content': 'Le son n\'est pas très bon, mais le contenu est intéressant.',
      'podcast': 'Techniques d\'apprentissage',
      'date': '2024-03-02',
      'status': 'Approuvé',
    },
    {
      'id': '3',
      'user': 'Ibrahima Fall',
      'content': 'Contenu inapproprié et offensant.',
      'podcast': 'Définir ses objectifs',
      'date': '2024-03-03',
      'status': 'Rejeté',
    },
  ];

  void _updateCommentStatus(String id, String status) {
    setState(() {
      final index = _comments.indexWhere((comment) => comment['id'] == id);
      if (index != -1) {
        _comments[index]['status'] = status;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modérer les commentaires'),
        backgroundColor: Color.fromARGB(255, 243, 147, 2),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtres
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'Tous',
                    items: ['Tous', 'En attente', 'Approuvé', 'Rejeté']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // TODO: Implémenter le filtrage
                    },
                    decoration: InputDecoration(
                      labelText: 'Statut',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Liste des commentaires
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment['user'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(comment['status']),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                comment['status'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          comment['podcast'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(comment['content']),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment['date'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _updateCommentStatus(comment['id'], 'Approuvé');
                                  },
                                  child: Text('Approuver'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _updateCommentStatus(comment['id'], 'Rejeté');
                                  },
                                  child: Text('Rejeter'),
                                ),
                              ],
                            ),
                          ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En attente':
        return Colors.orange;
      case 'Approuvé':
        return Colors.green;
      case 'Rejeté':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 