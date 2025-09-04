// lib/admin/games_admin_page.dart
import 'package:flutter/material.dart';
import '../../services/modelgame.dart';
import '../../services/storageservice.dart';
import 'notifservice.dart';

class GamesAdminPage extends StatefulWidget {
  const GamesAdminPage({super.key});
  @override
  State<GamesAdminPage> createState() => _GamesAdminPageState();
}

class _GamesAdminPageState extends State<GamesAdminPage> {
  final _storage = GameStorage();
  late Future<List<Game>> _future;

  @override
  void initState() {
    super.initState();
    _future = _storage.getAllGames();
  }

  Future<void> _reload() async {
    setState(() => _future = _storage.getAllGames());
  }

  @override
  Widget build(BuildContext context) {
    final history = NotificationsService.instance.history;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Text('Jeux', style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              IconButton(onPressed: _reload, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Game>>(
            future: _future,
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final games = snap.data!;
              if (games.isEmpty) return const Center(child: Text('Aucun jeu.'));
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: games.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final g = games[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.extension),
                      title: Text(g.name),
                      subtitle: Text('${g.numQuestions} questions • ${g.plays.length} partie(s)'),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.campaign_outlined),
                            tooltip: 'Notifier (nouveau jeu)',
                            onPressed: () async {
                              // 🔴 Remplace '1' par l'ID réel de l'admin ou utilisateur cible
                              const int adminId = 1;

                              try {
                                await NotificationsService.instance.notifyNewGame(g, adminId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Notification envoyée.')),
                                );
                                setState(() {}); // pour rafraîchir l'UI si nécessaire
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Impossible d’envoyer la notification : $e')),
                                );
                              }
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await _storage.deleteGame(g.id);
                              _reload();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dernières notifications', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (history.isEmpty) const Text('Aucune notification')
              else ...history.take(5).map((n) => ListTile(
                dense: true,
                leading: Icon(n.type == AdminNotificationType.newGame ? Icons.fiber_new : Icons.campaign),
                title: Text(n.title),
                subtitle: Text('${n.body}\n${n.createdAt.toLocal()}'),
                isThreeLine: true,
              )),
            ],
          ),
        ),
      ],
    );
  }
}