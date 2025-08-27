import 'package:flutter/material.dart';

class ListejeuxPage extends StatefulWidget {
  @override
  _ListeJeuxPageState createState() => _ListeJeuxPageState();
}

class _ListeJeuxPageState extends State<ListejeuxPage> {
  final List<String> tousLesJeux = [
    'Puzzle éducatif',
    'Quiz mathématiques',
    'Mémoire visuelle',
    'Jeu de logique',
    'Calcul mental',
    'Lecture rapide',
  ];

  List<String> jeuxFiltres = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    jeuxFiltres = List.from(tousLesJeux);
  }

  void filtrerJeux(String query) {
    setState(() {
      jeuxFiltres = tousLesJeux
          .where((jeu) => jeu.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void effacerRecherche() {
    _searchController.clear();
    filtrerJeux('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des jeux"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Barre de recherche
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un jeu',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: effacerRecherche,
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: filtrerJeux,
            ),
            SizedBox(height: 20),

            // 📋 Liste filtrée
            Expanded(
              child: jeuxFiltres.isNotEmpty
                  ? ListView.builder(
                itemCount: jeuxFiltres.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(jeuxFiltres[index]),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Action à définir
                      },
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  "Aucun jeu trouvé.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
