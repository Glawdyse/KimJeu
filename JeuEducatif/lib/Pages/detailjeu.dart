import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameDetailPage extends StatefulWidget {
  final String gameId;

  const GameDetailPage({super.key, required this.gameId});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  Map<String, dynamic>? game;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGameDetail();
  }

  Future<void> fetchGameDetail() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/api/games/${widget.gameId}"),
      );

      if (response.statusCode == 200) {
        setState(() {
          game = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Erreur API: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur de chargement du jeu: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📖 Détails du jeu"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : game == null
          ? const Center(child: Text("Erreur de chargement du jeu"))
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.videogame_asset,
                  size: 80, color: Colors.deepPurple),
            ),
            const SizedBox(height: 20),

            Text(
              game!['name'] ?? "Sans nom",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Identifiant: ${game!['id']}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Description si dispo
            if (game!.containsKey('description'))
              Text(
                game!['description'] ?? "Pas de description",
                style: const TextStyle(fontSize: 16),
              ),

            const Spacer(),

            // 🔹 Bouton Jouer
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  print("➡️ Lancement du jeu ${game!['name']} (${game!['id']})");
                  // Ici tu mets ton JouerPage(gameId: game!['id'])
                  // Navigator.push(context,
                  //   MaterialPageRoute(builder: (_) => JouerPage(gameId: game!['id'])),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text(
                  "Jouer",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
