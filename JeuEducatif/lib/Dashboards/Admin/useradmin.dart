// lib/admin/users_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum UserRole { APPRENANT, EDUCATEUR, ADMIN }

String roleToText(UserRole r) =>
    r == UserRole.EDUCATEUR ? 'Éducateur' : r == UserRole.ADMIN ? 'Admin' : 'Apprenant';

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    id: j['id'].toString(),
    name: j['nomPrenom'] ?? '',
    email: j['email'] ?? '',
    role: UserRole.values.byName(j['role'] ?? 'APPRENANT'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nomPrenom': name,
    'email': email,
    'role': role.name,
  };
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final String baseUrl = "http://localhost:8080/api/users"; // adapte selon ton backend
  List<AppUser> _users = [];
  String _query = '';
  UserRole? _filter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        setState(() {
          _users = data.map((e) => AppUser.fromJson(e)).toList();
        });
      } else {
        throw Exception("Erreur serveur (${res.statusCode})");
      }
    } catch (e) {
      debugPrint("Erreur chargement utilisateurs: $e");
    }
  }

  Future<void> _createOrEdit({AppUser? user}) async {
    final name = TextEditingController(text: user?.name ?? '');
    final email = TextEditingController(text: user?.email ?? '');
    UserRole role = user?.role ?? UserRole.APPRENANT;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user == null ? 'Créer un utilisateur' : 'Modifier un utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Nom')),
            const SizedBox(height: 8),
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            DropdownButtonFormField<UserRole>(
              value: role,
              items: const [
                DropdownMenuItem(value: UserRole.APPRENANT, child: Text('Apprenant')),
                DropdownMenuItem(value: UserRole.EDUCATEUR, child: Text('Éducateur')),
                DropdownMenuItem(value: UserRole.ADMIN, child: Text('Admin')),
              ],
              onChanged: (v) => role = v ?? role,
              decoration: const InputDecoration(labelText: 'Rôle'),
            ),
            const SizedBox(height: 12),
            if (user == null)
              const Text(
                "Un mot de passe par défaut sera généré pour l'utilisateur. Il pourra le changer plus tard.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            onPressed: () async {
              if (name.text.trim().isEmpty) return;

              final body = jsonEncode({
                "nomPrenom": name.text.trim(),
                "email": email.text.trim(),
                "role": role.name,
                // pas besoin d'envoyer mot de passe, backend gère le mot de passe par défaut
              });

              try {
                if (user == null) {
                  // Création
                  final res = await http.post(
                    Uri.parse(baseUrl),
                    headers: {"Content-Type": "application/json"},
                    body: body,
                  );
                  if (res.statusCode == 200 || res.statusCode == 201) _load();
                } else {
                  // Modification
                  final res = await http.put(
                    Uri.parse("$baseUrl/${user.id}"),
                    headers: {"Content-Type": "application/json"},
                    body: body,
                  );
                  if (res.statusCode == 200) _load();
                }
              } catch (e) {
                debugPrint("Erreur création/modif utilisateur: $e");
              }

              if (context.mounted) Navigator.pop(context);
            },
            child: Text(user == null ? 'Créer' : 'Enregistrer'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(AppUser u) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/${u.id}"));
      if (res.statusCode == 200) _load();
    } catch (e) {
      debugPrint("Erreur suppression utilisateur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var list = _users;
    if (_filter != null) list = list.where((u) => u.role == _filter).toList();
    if (_query.isNotEmpty) {
      list = list
          .where((u) =>
      u.name.toLowerCase().contains(_query) ||
          u.email.toLowerCase().contains(_query))
          .toList();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 260,
                child: TextField(
                  decoration: const InputDecoration(
                      labelText: 'Rechercher',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder()),
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                ),
              ),
              DropdownButton<UserRole?>(
                value: _filter,
                hint: const Text('Tous les rôles'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Tous')),
                  DropdownMenuItem(value: UserRole.APPRENANT, child: Text('Apprenants')),
                  DropdownMenuItem(value: UserRole.EDUCATEUR, child: Text('Éducateurs')),
                  DropdownMenuItem(value: UserRole.ADMIN, child: Text('Admins')),
                ],
                onChanged: (v) => setState(() => _filter = v),
              ),
              FilledButton.icon(
                  onPressed: () => _createOrEdit(),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Créer')),
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? const Center(child: Text('Aucun utilisateur'))
              : ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, i) {
              final u = list[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(u.name.isEmpty ? '?' : u.name[0])),
                  title: Text(u.name),
                  subtitle: Text('${u.email} • ${roleToText(u.role)}'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _createOrEdit(user: u)),
                      IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _delete(u)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
