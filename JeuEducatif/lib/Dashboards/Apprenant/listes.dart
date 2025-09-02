import 'package:flutter/material.dart';
import '../../Pages/quizformulaire.dart';
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
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = _storage.getAllGames();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _storage.getAllGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des jeux'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _reload, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: 'Rechercher un jeu',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _query = '');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Game>>(
              future: _future,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final games = snap.data!
                    .where((g) =>
                _query.isEmpty ||
                    g.name.toLowerCase().contains(_query))
                    .toList();
                if (games.isEmpty) {
                  return const Center(child: Text('Aucun jeu enregistré.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: games.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return ListTile(
                      title: Text(game.name),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Jouer'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => QuizPage(game: game),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
