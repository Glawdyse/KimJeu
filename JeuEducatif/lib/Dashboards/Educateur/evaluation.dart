import 'package:flutter/material.dart';
import 'package:jeuEducatif/services/modelgame.dart';
import 'package:jeuEducatif/services/storageservice.dart';
import 'package:jeuEducatif/Pages/quizformulaire.dart';

class EvaluationLauncherPage extends StatefulWidget {
  const EvaluationLauncherPage({super.key});

  @override
  State<EvaluationLauncherPage> createState() => _EvaluationLauncherPageState();
}

class _EvaluationLauncherPageState extends State<EvaluationLauncherPage> {
  final _emailCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  final _storage = GameStorage();

  List<Game> _allGames = [];
  Game? _selectedGame;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() => _loading = true);
    try {
      final games = await _storage.getAllGames();
      setState(() {
        _allGames = games;
        if (_allGames.isNotEmpty) {
          _selectedGame = _allGames.first;
        }
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  List<Game> get _filteredGames {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _allGames;
    return _allGames.where((g) => g.name.toLowerCase().contains(q)).toList();
  }

  void _launchEvaluation() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _snack('Entrez l\'email de l\'apprenant.');
      return;
    }
    if (_selectedGame == null) {
      _snack('Choisissez un jeu.');
      return;
    }

    // Pour l\'instant, on démarre localement l\'évaluation pour l\'apprenant choisi.
    // Intégration backend: envoyer une demande d\'évaluation ciblée.
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => QuizPage(game: _selectedGame!)),
    );
    _snack('Évaluation lancée pour $email');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lancer une évaluation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email de l\'apprenant',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                labelText: 'Rechercher un jeu',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_filteredGames.isEmpty)
              const Expanded(
                child: Center(child: Text('Aucun jeu disponible')),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final game = _filteredGames[index];
                    final selected = _selectedGame?.id == game.id;
                    return ListTile(
                      title: Text(game.name),
                      subtitle: Text('${game.numQuestions} questions'),
                      trailing: selected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                      onTap: () => setState(() => _selectedGame = game),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: _filteredGames.length,
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _loading ? null : _launchEvaluation,
                child: const Text('Lancer l\'évaluation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
