// lib/admin/services/notification_service.dart
import 'dart:async';

import '../../services/modelgame.dart';


enum AdminNotificationType { newGame, manual }

class AdminNotification {
  final String id;
  final AdminNotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  AdminNotification({required this.id,required this.type,required this.title,required this.body,required this.createdAt});
}

class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();
  final _controller = StreamController<AdminNotification>.broadcast();
  final List<AdminNotification> _history = [];
  Stream<AdminNotification> get stream => _controller.stream;
  List<AdminNotification> get history => List.unmodifiable(_history);

  void notifyNewGame(Game game) {
    final n = AdminNotification(
      id: game.id,
      type: AdminNotificationType.newGame,
      title: 'Nouveau jeu',
      body: '${game.name} — ${game.numQuestions} questions',
      createdAt: DateTime.now(),
    );
    _history.insert(0, n);
    _controller.add(n);
  }

  void sendManual(String title, String body) {
    final n = AdminNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: AdminNotificationType.manual,
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );
    _history.insert(0, n);
    _controller.add(n);
  }

  void dispose() => _controller.close();
}