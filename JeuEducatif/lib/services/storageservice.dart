import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jeuEducatif/services/modelgame.dart';
import '../models/user.dart';

class GameStorage {
  final String baseUrl = 'http://localhost:8080/api/games';

  static const String _gameBox = 'games';
  static const String _userBox = 'user';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  final GetStorage _gameStorage = GetStorage(_gameBox);
  final GetStorage _userStorage = GetStorage(_userBox);

  // ✅ Méthode pour ajouter un jeu dans la base distante
  Future<void> ajouterJeu(Game game) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Échec de l’ajout du jeu : ${response.statusCode}');
    }
  }

  

  // ✅ Méthode pour récupérer un jeu par son ID depuis le backend
  Future<dynamic> fetchGameById(String gameId) async {
    final url = Uri.parse('$baseUrl/$gameId');
    print('Identifiant du jeu : $gameId');

    final response = await http.get(url);
    final contentType = response.headers['content-type'];

    if (response.statusCode == 200) {
      if (contentType != null && contentType.contains('application/json')) {
        // C'est du JSON → parser en objet Game
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return Game.fromJson(jsonData);
      } else if (contentType != null && contentType.contains('application/pdf')) {
        // C'est un PDF → récupérer les bytes
        final pdfBytes = response.bodyBytes;
        return pdfBytes;
      } else {
        throw Exception('Type de contenu non supporté : $contentType');
      }
    } else {
      throw Exception('Échec de la récupération du jeu : ${response.statusCode}');
    }
  }
  Future<PlayRecord> sendPlayRecord(String gameId, PlayRecord record) async {
    final url = Uri.parse('$baseUrl/api/games/$gameId/plays');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(record.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return PlayRecord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Erreur lors de l’enregistrement du score: ${response.body}');
    }
  }

  // Exemple pour récupérer tous les PlayRecords d'un jeu
  Future<List<PlayRecord>> fetchPlays(String gameId) async {
    final url = Uri.parse('$baseUrl/$gameId/plays');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PlayRecord.fromJson(e)).toList();
    } else {
      throw Exception('Impossible de récupérer les scores: ${response.body}');
    }
  }

  Future<PlayRecord?> addPlay(String gameId, PlayRecord play) async {
    final url = Uri.parse('$baseUrl/$gameId/plays');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(play.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Score enregistré avec succès : ${response.body}");
      final data = jsonDecode(response.body);
      return PlayRecord(
        player: data["player"],
        answers: (data["answers"] as List? ?? [])
            .map((e) => PlayAnswer.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        score: data["score"] is int
            ? data["score"]
            : int.tryParse(data["score"].toString()) ?? 0,
        playedAt: DateTime.tryParse(data["playedAt"] ?? '') ?? DateTime.now(),
      );


  } else {
      print("❌ Erreur lors de l'enregistrement du score : ${response.body}");
      return null;
    }
  }
   static Future<List<Game>> fetchGameNames() async {
     final String baseUrl = 'http://localhost:8080/api/games';

     final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les jeux');
    }
  }
  Future<void> savePlay(String gameId, PlayRecord play) async {
    final url = Uri.parse('$baseUrl/games/$gameId/plays');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(play.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de l\'enregistrement du joueur');
    }
  }


  Future<void> upsertGame(Game game) async {
    await _gameStorage.write(game.id, game.toJson());
  }

  Future<Game?> getGame(String id) async {
    final data = _gameStorage.read(id);
    if (data != null) {
      return Game.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<List<Game>> getAllGames() async {
    final keys = _gameStorage.getKeys();
    final games = <Game>[];
    for (final key in keys) {
      final data = _gameStorage.read(key);
      if (data != null) {
        try {
          games.add(Game.fromJson(Map<String, dynamic>.from(data)));
        } catch (_) {}
      }
    }
    return games;
  }


  Future<List<GameSummary>> getGameSummaries() async {
    final url = Uri.parse('$baseUrl/summaries'); // /api/games/summaries
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => GameSummary.fromJson(e)).toList();
    } else {
      throw Exception("Impossible de charger les jeux");
    }
  }

  Future<void> deleteGame(String id) async {
    await _gameStorage.remove(id);
  }

  Future<void> clearAllGames() async {
    await _gameStorage.erase();
  }


  Future<void> saveAuthToken(String token) async {
    await _userStorage.write(_tokenKey, token);
  }

  String? getAuthToken() {
    return _userStorage.read(_tokenKey);
  }

  Future<void> clearAuthToken() async {
    await _userStorage.remove(_tokenKey);
  }

  Future<void> saveCurrentUser(User user) async {
    await _userStorage.write(_userKey, user.toJson());
  }

  User? getCurrentUser() {
    final data = _userStorage.read(_userKey);
    if (data != null) {
      try {
        return User.fromJson(Map<String, dynamic>.from(data));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> updateUserProfile({String? nomPrenom, String? avatarUrl, String? classe}) async {
    final user = getCurrentUser();
    if (user == null) return;
    final updated = user.copyWith(
      nomPrenom: nomPrenom,
      avatarUrl: avatarUrl,
      classe: classe,
    );
    await saveCurrentUser(updated);
  }

  Future<void> clearCurrentUser() async {
    await _userStorage.remove(_userKey);
  }

  bool isUserLoggedIn() {
    return getAuthToken() != null && getCurrentUser() != null;
  }

  Future<void> logout() async {
    await clearAuthToken();
    await clearCurrentUser();
  }

  String? getCurrentUserId() {
    final user = getCurrentUser();
    return user?.email;
  }

  String? getCurrentUserRole() {
    final user = getCurrentUser();
    return user?.role;
  }

  String getDisplayName() {
    final user = getCurrentUser();
    return user?.nomPrenom.isNotEmpty == true ? user!.nomPrenom : (user?.email ?? 'Utilisateur');
  }

  String? getAvatarUrl() {
    return getCurrentUser()?.avatarUrl;
  }
}
