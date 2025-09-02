import 'package:flutter/material.dart';
import '../../services/modelgame.dart';
import '../../services/storageservice.dart';

class GamesListPage extends StatefulWidget {
  const GamesListPage({super.key});

  @override
  State<GamesListPage> createState() => _GamesListPageState();
}

class _GamesListPageState extends State<GamesListPage> {
  final _storage = GameStorage();
  late Future<List<Game>> _future;

  @override
  void initState() {
    super.initState();
    _future = _storage.getAllGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des jeux'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Game>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun jeu enregistré.'));
          }

          final games = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: games.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final game = games[index];

              return ListTile(
                title: Text(game.name),
                subtitle: Text(
                  'Créé le: ${game.createdAt.toLocal().toString().split(' ')[0]} | Questions: ${game.numQuestions}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
