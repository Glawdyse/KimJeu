// lib/services/game_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jeuEducatif/services/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'modelgame.dart';


Future<bool> verifierTaillePdf({String? cheminPdf, Uint8List? bytes}) async {
  try {
    if (bytes != null) {
      const maxSizeInBytes = 10 * 1024 * 1024;
      return bytes.lengthInBytes <= maxSizeInBytes;
    }
    if (cheminPdf != null && cheminPdf.isNotEmpty) {
      final file = File(cheminPdf);
      final sizeInBytes = await file.length();
      const maxSizeInBytes = 10 * 1024 * 1024;
      return sizeInBytes <= maxSizeInBytes;
    }
  } catch (_) {}
  return true;
}

Future<String> extraireTextePdf({String? cheminPdf, Uint8List? pdfBytes}) async {
  try {
    if (pdfBytes != null) {
      return await PdfUtils.extractTextFromBytes(pdfBytes);
    }
    if (cheminPdf != null && cheminPdf.isNotEmpty) {
      return await PdfUtils.extractTextFromPath(cheminPdf);
    }
    throw Exception('Aucune source PDF fournie.');
  } catch (e) {
    throw Exception(e.toString());
  }
}

String normalizeForPrompt(String text) {
  final cleaned = text.replaceAll(RegExp(r'[^\x09\x0A\x0D\x20-\x7E\u0080-\uFFFF]'), ' ');
  return cleaned.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
}

String _stripCodeFences(String input) {
  var t = input.trim();
  // Retire ```json ... ``` ou ``` ... ```
  if (t.startsWith('```')) {
    t = t.replaceFirst(RegExp(r'^```(?:json)?'), '');
    if (t.endsWith('```')) {
      t = t.substring(0, t.length - 3);
    }
  }
  return t.trim();
}

String _toValidJson(String raw) {
  // 1) Retire code fences et isole l’objet principal
  var t = _stripCodeFences(raw);
  final start = t.indexOf('{');
  final end = t.lastIndexOf('}');
  if (start != -1 && end != -1 && end > start) {
    t = t.substring(start, end + 1);
  }

  // 2) Normalise guillemets typographiques
  t = t.replaceAll('“', '"').replaceAll('”', '"').replaceAll('’', "'");

  // 3) Retire commentaires potentiels
  t = t.replaceAll(RegExp(r'//.*'), '');
  t = t.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');

  // 4) Supprime virgules finales avant ] ou }
  t = t.replaceAll(RegExp(r',(\s*[\]\}])'), r'$1');

  // 5) Nettoyage et validation
  t = t.trim();
  try {
    jsonDecode(t);
    return t;
  } catch (_) {
    // Dernier filet: caractères non imprimables
    t = t.replaceAll(RegExp(r'[^\x09\x0A\x0D\x20-\x7E\u0080-\uFFFF]'), ' ').trim();
    jsonDecode(t);
    return t;
  }
}

Future<Game?> genererJeu({
  required String nomJeu,
  required int nombreQuestions,
  String texte = '',
  String cheminPdf = '',
  Uint8List? pdfBytes,
  String typeQuiz = '',
  String? pdfFileName,
}) async {
  final apiKey = dotenv.env['MISTRAL_API_KEY']?.trim().isNotEmpty == true
      ? dotenv.env['MISTRAL_API_KEY']!.trim()
      : const String.fromEnvironment('MISTRAL_API_KEY');

  if (apiKey.isEmpty) {
    throw Exception('Clé API Mistral manquante (.env ou --dart-define)');
  }

  int n = nombreQuestions;
  if (n < 5) n = 5;
  if (n > 20) n = 20;

  String sourceText = texte.trim();
  String? filename;
  String sourceType = 'text';

  if (pdfBytes != null || cheminPdf.isNotEmpty) {
    final ok = await verifierTaillePdf(cheminPdf: cheminPdf.isNotEmpty ? cheminPdf : null, bytes: pdfBytes);
    if (!ok) throw Exception('PDF trop volumineux (>10 Mo)');

    final extracted = await extraireTextePdf(
      cheminPdf: cheminPdf.isNotEmpty ? cheminPdf : null,
      pdfBytes: pdfBytes,
    );
    sourceText = extracted.trim();
    filename = pdfFileName ?? (cheminPdf.isNotEmpty ? cheminPdf.split('/').last : null);
    sourceType = 'pdf';
  } else if (sourceText.isEmpty && typeQuiz.isNotEmpty) {
    sourceText = 'Sujet du quiz: $typeQuiz';
  }
  if (sourceText.isEmpty) {
    throw Exception('Fournir un texte, un PDF ou un type de quiz.');
  }

  sourceText = normalizeForPrompt(sourceText);

  final systemPrompt = '''
Tu es un générateur de quiz. À partir d’un texte source (saisi ou extrait d’un PDF) et d’un nombre de questions N, produis un QCM avec EXACTEMENT N questions. Chaque question a 3 propositions et EXACTEMENT une bonne réponse. Propositions concises et plausibles. N'invente pas.
Retourne UNIQUEMENT un JSON valide et minifié, sans Markdown, sans commentaires et SANS virgules finales, conforme à:
{"name":"Nom du jeu","numQuestions":N,"questions":[{"id":"q1","question":"...","choices":["A","B","C"],"answerIndex":0}]}
Contraintes:
- "questions" a exactement N objets
- "choices" a exactement 3 chaînes
- "answerIndex" ∈ {0,1,2}
''';

  final userPrompt = '''
Génère un quiz à partir du texte source ci-dessous.

Nom du jeu: ${nomJeu.isEmpty ? 'Quiz' : nomJeu}
Nombre de questions: $n
Origine du texte: ${sourceType == 'pdf' ? 'extrait d’un PDF${filename != null ? ' ($filename)' : ''}' : 'texte saisi'}
Texte source:
$sourceText
''';

  final uri = Uri.parse('https://api.mistral.ai/v1/chat/completions');
  final payload = {
    'model': 'mistral-small-latest',
    'temperature': 0.2,
    'max_tokens': 2000,
    'messages': [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': userPrompt},
    ],
    'response_format': {'type': 'json_object'},
  };

  final res = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
    },
    body: utf8.encode(jsonEncode(payload)),
  );

  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw Exception('Mistral API error: ${res.statusCode} ${res.body}');
  }

  final bodyText = utf8.decode(res.bodyBytes);
  final decoded = jsonDecode(bodyText) as Map<String, dynamic>;
  final choices = decoded['choices'] as List?;
  final content =
  choices != null && choices.isNotEmpty ? (choices.first['message']['content'] as String) : null;

  if (content == null || content.trim().isEmpty) {
    throw Exception('Réponse Mistral vide');
  }

  final jsonText = _toValidJson(content);
  final quiz = jsonDecode(jsonText) as Map<String, dynamic>;

  if (quiz['questions'] == null || (quiz['questions'] as List).length != n) {
    throw Exception('Nombre de questions inattendu');
  }
  for (final q in (quiz['questions'] as List)) {
    final m = q as Map<String, dynamic>;
    if ((m['choices'] as List).length != 3) {
      throw Exception('Chaque question doit avoir 3 propositions');
    }
    final idx = m['answerIndex'] as int;
    if (idx < 0 || idx > 2) {
      throw Exception('"answerIndex" doit être 0, 1 ou 2');
    }
  }

  final id = const Uuid().v4();
  final prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  final game = Game.fromMistralJson(id, quiz, {
    'type': sourceType,
    'content': sourceText,
    'filename': filename,
  }
    ,email);
  return game;
}