import 'package:flutter/material.dart';

import 'notifservice.dart';

class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = NotificationsService.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications admin'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<AdminNotification>(
              stream: service.stream,
              builder: (context, snapshot) {
                final items = service.history;
                if (items.isEmpty) {
                  return const Center(
                    child: Text('Aucune notification pour le moment'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final n = items[index];
                    final isNewGame = n.type == AdminNotificationType.newGame;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isNewGame ? Colors.green.shade100 : Colors.blue.shade100,
                        child: Icon(
                          isNewGame ? Icons.sports_esports : Icons.notifications,
                          color: isNewGame ? Colors.green : Colors.blue,
                        ),
                      ),
                      title: Text(n.title),
                      subtitle: Text(n.body),
                      trailing: Text(
                        _formatTime(n.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: items.length,
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {
                        service.sendManual('Message admin', 'Notification test envoyée');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notification de test envoyée')),
                        );
                      },
                      child: const Text('Envoyer une notification de test'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return 'à l\'instant';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
    return '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
