import 'package:flutter/material.dart';

class JouerPage extends StatefulWidget {
  final Map<String, dynamic> quizData;

  const JouerPage({super.key, required this.quizData});

  @override
  State<JouerPage> createState() => _JouerPageState();
}

class _JouerPageState extends State<JouerPage> {
  int _currentQuestionIndex = 0;
  int _selectedChoiceIndex = -1;
  int _score = 0;

  void _validerReponse() {
    if (_selectedChoiceIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une réponse.')),
      );
      return;
    }

    final currentQuestion = widget.quizData['quiz'][_currentQuestionIndex];
    final selectedAnswer = ['A', 'B', 'C'][_selectedChoiceIndex];

    if (selectedAnswer == currentQuestion['correct']) {
      _score++;
    }

    setState(() {
      if (_currentQuestionIndex < widget.quizData['quiz'].length - 1) {
        _currentQuestionIndex++;
        _selectedChoiceIndex = -1;
      } else {
        _afficherResultatFinal();
      }
    });
  }

  void _afficherResultatFinal() {
    final total = widget.quizData['quiz'].length;
    final pourcentage = (_score / total * 100).toInt();

    String message;
    if (pourcentage >= 80) {
      message = '🥇 Excellent ! Tu maîtrises très bien ce sujet.';
    } else if (pourcentage >= 50) {
      message = '💡 Bien joué ! Tu as les bases, continue à progresser.';
    } else {
      message = '📘 Il te reste des notions à renforcer. Revois ton cours.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Résultat final'),
        content: Text('Score : $_score/$total\n$message'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _selectedChoiceIndex = -1;
                _score = 0;
              });
            },
            child: const Text('Recommencer'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quizData['quiz'][_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jouer au Quiz'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${widget.quizData['quiz'].length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ...List.generate(3, (index) {
              return RadioListTile<int>(
                title: Text(question['choices'][index]),
                value: index,
                groupValue: _selectedChoiceIndex,
                onChanged: (value) {
                  setState(() {
                    _selectedChoiceIndex = value!;
                  });
                },
              );
            }),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _validerReponse,
                icon: const Icon(Icons.check),
                label: const Text('Valider'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
