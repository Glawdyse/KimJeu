import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../services/modelgame.dart';

enum AdminNotificationType { newGame, manual }

class AdminNotification {
  final String id;
  final AdminNotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;

  AdminNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  String get formattedDate =>
      "${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}";
}

class NotificationsService {
  NotificationsService._();

  static final NotificationsService instance = NotificationsService._();

  final _controller = StreamController<AdminNotification>.broadcast();
  final List<AdminNotification> _history = [];

  // Limite l'historique en mémoire
  static const int _maxHistory = 100;

  Stream<AdminNotification> get stream => _controller.stream;
  List<AdminNotification> get history => List.unmodifiable(_history);

  /// 🔹 Notifie un nouveau jeu (local + backend)
  Future<void> notifyNewGame(Game game, int userId) async {
    final n = AdminNotification(
      id: game.id,
      type: AdminNotificationType.newGame,
      title: 'Nouveau jeu cree',
      body: '${game.name} — ${game.numQuestions} questions',
      createdAt: DateTime.now(),
    );
    _addNotification(n);

    // ✅ Appel backend Spring Boot
    final response = await http.post(
      Uri.parse("http://localhost:8080/api/notifications/newGame"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "gameId": game.id,
        "title": "Nouveau jeu",
        "message": "${game.name} — ${game.numQuestions} questions",
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur backend: ${response.body}");
    }
  }

  /// 🔹 Notif manuelle envoyée par admin
  Future<void> sendManual(String title, String body, int userId) async {
    final n = AdminNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: AdminNotificationType.manual,
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );
    _addNotification(n);

    // ✅ Appel backend Spring Boot
    final response = await http.post(
      Uri.parse("http://localhost:8080/api/notifications/manual"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "title": title,
        "message": body,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur backend: ${response.body}");
    }
  }

  /// Ajout local (liste + stream)
  void _addNotification(AdminNotification notification) {
    _history.insert(0, notification);
    if (_history.length > _maxHistory) {
      _history.removeLast();
    }
    if (!_controller.isClosed) {
      _controller.add(notification);
    }
  }

  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
