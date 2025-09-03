import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Pages/quizformulaire.dart';
import '../../services/modelgame.dart';
import '../Apprenant/jouer.dart';

class GamesListPage extends StatefulWidget {
  const GamesListPage({super.key});

  @override
  State<GamesListPage> createState() => _GamesListPageState();
}

class _GamesListPageState extends State<GamesListPage> {
  List<Map<String, dynamic>> games = [];
  bool isLoading = true;
  final String baseUrl = 'http://localhost:8080/api/games';

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/summaries'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          games = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Erreur lors du chargement des jeux');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> playGame(String gameId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$gameId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> gameJson = jsonDecode(response.body);

        // Convertir Map en Game
        final game = Game.fromJson(gameJson);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizPage(game: game),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de charger le jeu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement du jeu: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des jeux'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : games.isEmpty
          ? Center(child: Text('Aucun jeu disponible'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Desktop : grid 2 colonnes minimum, mobile : 1 colonne
            final crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => playGame(game['id']),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.purple[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.purple[50]!, Colors.purple[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    game['name'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple[800]),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Questions: ${game['numQuestions']}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.deepPurple[600]),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Créé le: ${game['createdAt']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepPurple[400]),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => playGame(game['id']),
                              child: Text('Jouer'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
