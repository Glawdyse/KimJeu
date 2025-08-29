import 'package:flutter/material.dart';

import '../services/modelgame.dart';

import '../services/storageservice.dart';

class QuizPage extends StatefulWidget {
  final Game game;
  const QuizPage({super.key, required this.game});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<String, int> _selectedPerQuestion = {};
  bool _validated = false;
  int _score = 0;
  final _nameCtrl = TextEditingController(text: 'Anonymous');
  final _storage = GameStorage();

  void _validate() {
    int score = 0;
    for (final q in widget.game.questions) {
      final selected = _selectedPerQuestion[q.id];
      if (selected != null && selected == q.answerIndex) {
        score++;
      }
    }
    setState(() {
      _validated = true;
      _score = score;
    });
  }
  Future<void> _savePlay() async {
    if (!_validated) return; // si les réponses n’ont pas été validées, on arrête

    // transforme les réponses sélectionnées en PlayAnswer
    final List<PlayAnswer> playAnswers = widget.game.questions.map((q) {
      final answerIndex = _selectedPerQuestion[q.id] ?? -1; // -1 si aucune réponse
      return PlayAnswer(questionId: q.id, answer: answerIndex);
    }).toList();

    // construit l'objet PlayRecord
    final playRecord = PlayRecord(
      player: _nameCtrl.text.trim().isEmpty ? 'Anonymous' : _nameCtrl.text.trim(),
      answers: playAnswers,
      score: _score,
      playedAt: DateTime.now(),
    );

    // envoie au backend
    await _storage.addPlay(widget.game.id, playRecord);

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Score enregistré.')));
    }
  }




  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return Scaffold(
      appBar: AppBar(title: Text('Quiz — ${game.name}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!_validated)
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nom du joueur (optionnel)',
                border: OutlineInputBorder(),
              ),
            ),
          if (!_validated) const SizedBox(height: 12),
          ...game.questions.map((q) {
            final selected = _selectedPerQuestion[q.id];
            final isCorrect = selected != null && selected == q.answerIndex;
            final showResult = _validated;

            Color? tileColor;
            if (showResult) {
              tileColor = isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.08);
            }

            final index = game.questions.indexOf(q) + 1;
            return Card(
              color: tileColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(q.question),
                      subtitle: Text('Question $index/${game.numQuestions}'),
                    ),
                    for (int i = 0; i < q.choices.length; i++)
                      RadioListTile<int>(
                        title: Text(q.choices[i]),
                        value: i,
                        groupValue: selected,
                        onChanged: _validated ? null : (v) => setState(() => _selectedPerQuestion[q.id] = v!),
                        secondary: showResult && i == q.answerIndex
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          if (!_validated) FilledButton(onPressed: _validate, child: const Text('Valider')),
          if (_validated) ...[
            Text('Score: $_score / ${game.numQuestions}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton.tonal(onPressed: _savePlay, child: const Text('Enregistrer Jeu')),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Retour')),
              ],
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}