import 'package:flutter/material.dart';
import '../../models/notifications.dart';
import '../../services/notificationService.dart';


class AdminNotificationsPage extends StatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  State<AdminNotificationsPage> createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = NotificationService().fetchNotifications();
  }

  Future<void> _refresh() async {
    setState(() {
      _notificationsFuture = NotificationService().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text('Aucune notification pour le moment'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = notifications[index];
              final isNewGame = n.typeNotif.toLowerCase().contains("game");

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isNewGame ? Colors.green.shade100 : Colors.blue.shade100,
                  child: Icon(
                    isNewGame ? Icons.sports_esports : Icons.notifications,
                    color: isNewGame ? Colors.green : Colors.blue,
                  ),
                ),
                title: Text(n.typeNotif),
                subtitle: Text("${n.message}\nCréé par: ${n.userName}"),
                isThreeLine: true,
                trailing: Text(
                  _formatTime(n.dateNotif),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(String dateStr) {
    try {
      final t = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(t);
      if (diff.inMinutes < 1) return 'à l\'instant';
      if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
      return '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')} '
          '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
