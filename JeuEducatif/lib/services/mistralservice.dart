import 'dart:convert';
import 'package:http/http.dart' as http;

class MistralService {
  final String apiKey;
  final String model;
  final http.Client _client;

  MistralService({
    required this.apiKey,
    this.model = 'mistral-tiny',
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> generateQuizJson({
    required String gameName,
    required int numQuestions,
    required String sourceText,
  }) async {
    final systemPrompt = '''
Tu es un générateur de quiz. À partir d’un texte source en français et d’un nombre de questions N, produis un QCM avec EXACTEMENT N questions. Chaque question a 3 propositions et EXACTEMENT une bonne réponse. Les propositions doivent être concises, plausibles et non ambiguës. N’invente pas de faits. Retourne UNIQUEMENT un JSON valide et minifié respectant ce schéma:
{"name":"Nom du jeu","numQuestions":N,"questions":[{"id":"q1","question":"...","choices":["A","B","C"],"answerIndex":0}]}
- "questions" a exactement N objets
- "choices" a exactement 3 chaînes
- "answerIndex" ∈ {0,1,2}
''';

    final userPrompt = '''
Génère un quiz à partir de ce contenu:

Nom du jeu: $gameName
Nombre de questions: $numQuestions
Texte source:
$sourceText
''';

    final uri = Uri.parse('https://api.mistral.ai/v1/chat/completions');
    final body = jsonEncode({
      'model': model,
      'temperature': 0.7,
      'max_tokens': 2000,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      // Si supporté par Mistral côté compte, force le JSON
      'response_format': {'type': 'json_object'},
    });

    final res = await _client.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Mistral API error: ${res.statusCode} ${res.body}');
    }

    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List?;
    final content = choices != null && choices.isNotEmpty
        ? (choices.first['message']['content'] as String)
        : null;

    if (content == null || content.trim().isEmpty) {
      throw Exception('Réponse Mistral vide');
    }

    // Si jamais le modèle renvoie autre chose que du JSON pur, essaie d’isoler le JSON
    final String jsonText = _extractJson(content);
    final Map<String, dynamic> quiz = jsonDecode(jsonText) as Map<String, dynamic>;

    // Validations minimales
    if (quiz['questions'] == null || (quiz['questions'] as List).length != numQuestions) {
      throw Exception('Nombre de questions inattendu dans le JSON renvoyé.');
    }
    for (final q in (quiz['questions'] as List)) {
      final m = q as Map<String, dynamic>;
      if ((m['choices'] as List).length != 3) {
        throw Exception('Chaque question doit avoir exactement 3 propositions.');
      }
      final idx = m['answerIndex'] as int;
      if (idx < 0 || idx > 2) {
        throw Exception('"answerIndex" doit être 0, 1 ou 2.');
      }
    }

    return quiz;
  }

  String _extractJson(String input) {
    // Tente d’extraire l’objet JSON principal
    final start = input.indexOf('{');
    final end = input.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return input.substring(start, end + 1);
    }
    return input;
  }

  void close() {
    _client.close();
  }
}