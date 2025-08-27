import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jeuEducatif/services/modelgame.dart';
import 'package:jeuEducatif/services/storageservice.dart';

import '../services/game_service.dart';
import 'Dashboards/Admin/notifservice.dart' as admin_notif;

import 'Dashboards/Apprenant/listes.dart';
import 'Pages/quizformulaire.dart';



class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _nomController = TextEditingController();
  final _texteController = TextEditingController();
  final _typeQuizController = TextEditingController();
  final _nombreQuestionsController = TextEditingController(text: '10');

  String? _cheminPdf;
  String? _pdfName;
  Uint8List? _pdfBytes;

  bool _chargement = false;
  Game? _dernierJeu;
  final _storage = GameStorage();

  bool get _hasText => _texteController.text.trim().isNotEmpty;
  bool get _hasPdf => _pdfBytes != null || (_cheminPdf != null && _cheminPdf!.isNotEmpty);
  bool get _hasType => _typeQuizController.text.trim().isNotEmpty;

  bool get _isExclusiveMode => [
    _hasText ? 1 : 0,
    _hasPdf ? 1 : 0,
    _hasType ? 1 : 0,
  ].where((e) => e == 1).length == 1;

  int get _questionCount {
    final n = int.tryParse(_nombreQuestionsController.text.trim()) ?? 10;
    if (n < 5) return 5;
    if (n > 20) return 20;
    return n;
  }

  String _currentModeLabel() {
    if (_hasText) return 'Texte';
    if (_hasPdf) return 'PDF';
    if (_hasType) return 'Thème';
    return 'Indéfini';
    }

  @override
  void dispose() {
    _nomController.dispose();
    _texteController.dispose();
    _typeQuizController.dispose();
    _nombreQuestionsController.dispose();
    super.dispose();
  }

  Future<void> _selectionnerPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // <— important: bytes pour Android 11+/Windows
    );
    if (result != null) {
      final file = result.files.single;
      final bytes = file.bytes;
      final path = file.path;
      final name = file.name;

      // Vérification taille
      final ok = await verifierTaillePdf(
        cheminPdf: path ?? '',
        bytes: bytes,
      );
      if (!ok) {
        _snack('PDF trop volumineux (>10 Mo)');
        return;
      }

      setState(() {
        _pdfBytes = bytes;     // on privilégie les bytes si présents
        _cheminPdf = path;     // peut être null selon plateforme
        _pdfName = name;
        _texteController.clear();
        _typeQuizController.clear();
      });
    }
  }

  void _clearPdf() {
    setState(() {
      _pdfBytes = null;
      _cheminPdf = null;
      _pdfName = null;
    });
  }

  Future<void> _genererQuiz() async {
    FocusScope.of(context).unfocus();

    if (!_isExclusiveMode) {
      _snack('Choisis un seul mode: texte OU PDF OU type de quiz.');
      return;
    }

    final n = _questionCount;

    setState(() => _chargement = true);
    try {
      final game = await genererJeu(
        nomJeu: _nomController.text.trim().isEmpty ? 'Quiz' : _nomController.text.trim(),
        nombreQuestions: n,
        texte: _texteController.text,
        cheminPdf: _cheminPdf ?? '',
        pdfBytes: _pdfBytes,          // <— passe les bytes
        pdfFileName: _pdfName,        // <— pour affichage
        typeQuiz: _typeQuizController.text,
      );
      if (game == null) {
        _snack('Génération du jeu échouée');
        return;
      }
      setState(() => _dernierJeu = game);
      // Notifier l'admin qu'un nouveau jeu a été créé
      admin_notif.NotificationsService.instance.notifyNewGame(game);
      _snack('Jeu généré. Tu peux jouer ou enregistrer.');
    } catch (e) {
      _snack('Erreur: $e');
    } finally {
      setState(() => _chargement = false);
    }
  }

  Future<void> _enregistrerJeu() async {

     final st= GameStorage();

    if (_dernierJeu == null) {
      _snack('Rien à enregistrer.');
      return;
    }else{

      st.ajouterJeu(_dernierJeu!);
    //await _storage.upsertGame(_dernierJeu!);

    _snack('Jeu enregistré.');
    }
  }
  void _jouer(String gameId) async {

    final st= GameStorage();

    if (_dernierJeu == null) {
      _snack('Génère un jeu d’abord.');
      return;
    }

    try {
      final game = await st.fetchGameById(gameId);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => QuizPage(game: game)),
      );
    } catch (e) {
      _snack('Erreur lors du chargement du jeu : $e');
    }
  }



  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final canGenerate = _isExclusiveMode && !_chargement;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Générer un Quiz'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GamesListPage()),
            ),
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              maxLength: 50,
              decoration: const InputDecoration(labelText: 'Nom du jeu', border: OutlineInputBorder(), counterText: ''),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Chip(
                  label: Text('Mode: ${_currentModeLabel()}'),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('Questions: $_questionCount'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _texteController,
              decoration: InputDecoration(
                labelText: 'Entrez le texte',
                border: const OutlineInputBorder(),
                suffixIcon: _hasText
                    ? IconButton(
                        tooltip: 'Effacer le texte',
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _texteController.clear()),
                      )
                    : null,
              ),
              maxLines: 4,
              onChanged: (v) {
                if (v.isNotEmpty) {
                  setState(() {
                    _cheminPdf = null;
                    _pdfName = null;
                    _pdfBytes = null;
                    _typeQuizController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _typeQuizController,
              decoration:
              InputDecoration(
                labelText: 'Type de quiz (thème/sujet)',
                border: const OutlineInputBorder(),
                suffixIcon: _hasType
                    ? IconButton(
                        tooltip: 'Effacer',
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _typeQuizController.clear()),
                      )
                    : null,
              ),
              onChanged: (v) {
                if (v.isNotEmpty) {
                  setState(() {
                    _cheminPdf = null;
                    _pdfName = null;
                    _pdfBytes = null;
                    _texteController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nombreQuestionsController,
              decoration:
              const InputDecoration(labelText: 'Nombre de questions (5-20)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selectionnerPdf,
                    icon: const Icon(Icons.upload_file),
                    label: Text(_pdfName == null ? 'Choisir un PDF' : 'PDF : $_pdfName'),
                  ),
                ),
                if (_hasPdf) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Retirer le PDF',
                    onPressed: _clearPdf,
                    icon: const Icon(Icons.close),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 16),
            if (_dernierJeu != null)
              Card(
                child: ListTile(
                  title: Text(_dernierJeu!.name),
                  subtitle: Text('${_dernierJeu!.numQuestions} questions'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(onPressed: _enregistrerJeu, child: const Text('Enregistrer')),
                      FilledButton.tonal(
                        onPressed: () {
                          _jouer(_dernierJeu!.id);
                        },
                        child: Text('Jouer'),
                      )

                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            _chargement
                ? const CircularProgressIndicator()
                : FilledButton(
                    onPressed: canGenerate ? _genererQuiz : null,
                    child: const Text('Générer le quiz'),
                  ),
          ],
        ),
      ),
    );
  }
}