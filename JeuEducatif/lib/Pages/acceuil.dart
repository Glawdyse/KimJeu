import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> topGames = [];

  @override
  void initState() {
    super.initState();
    loadTopGames();
  }

  // 🔹 Récupérer les 5 premiers jeux
  Future<void> loadTopGames() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/api/games/top?count=5"),
      );

      if (response.statusCode == 200) {
        setState(() {
          topGames = jsonDecode(response.body);
        });
      } else {
        throw Exception("Erreur API: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur de chargement: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("🎮 Quelques Jeux pour vous"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: topGames.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: topGames.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 colonnes
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4, // ratio largeur/hauteur
          ),
          itemBuilder: (context, index) {
            final game = topGames[index];
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image ou icône par défaut
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: game['imageUrl'] != null &&
                          game['imageUrl'].isNotEmpty
                          ? Image.network(
                        game['imageUrl'],
                        height: 80,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 80,
                        width: 80,
                        color: Colors.deepPurple.shade100,
                        child: const Icon(
                          Icons.videogame_asset,
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      game['title'] ?? "Sans titre",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "ID: ${game['id']}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                GameDetailPage(gameId: game['id']),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Jouer"),
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
}

// Page détails du jeu
class GameDetailPage extends StatelessWidget {
  final String gameId;
  const GameDetailPage({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du jeu"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text("Page détails pour le jeu ID: $gameId"),
      ),
    );
  }
}
