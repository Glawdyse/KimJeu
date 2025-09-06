import 'package:flutter/material.dart';

class EducateurHomePage extends StatelessWidget {
  // Exemple de données
  final List<Map<String, dynamic>> learners = [
    {
      'name': 'Alice',
      'games': [
        {'title': 'Jeu 1', 'score': 85},
        {'title': 'Jeu 2', 'score': 90},
      ]
    },
    {
      'name': 'Bob',
      'games': [
        {'title': 'Jeu 1', 'score': 70},
        {'title': 'Jeu 3', 'score': 95},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue monsieur ici vous pouvez gerer vos etudiants '),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: _buildCustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: learners.length,
          itemBuilder: (context, index) {
            final learner = learners[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      learner['name'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: learner['games'].map<Widget>((game) {
                        return Container(
                          width: 150,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(game['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 8),
                              Text('Score: ${game['score']}',
                                  style: TextStyle(fontSize: 14, color: Colors.black87)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Éducateur Yvette'),
              accountEmail: Text('yvette@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('Y', style: TextStyle(fontSize: 24)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Paramètres'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Déconnexion'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
