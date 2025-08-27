// lib/admin/users_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { learner, educator, admin }
String roleToText(UserRole r) => r == UserRole.educator ? 'Éducateur' : r == UserRole.admin ? 'Admin' : 'Apprenant';

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool isActive;
  AppUser({required this.id, required this.name, required this.email, required this.role, required this.isActive});
  AppUser copyWith({String? name, String? email, UserRole? role, bool? isActive}) => AppUser(
    id: id, name: name ?? this.name, email: email ?? this.email, role: role ?? this.role, isActive: isActive ?? this.isActive,
  );
  Map<String, dynamic> toJson() => {'id': id,'name': name,'email': email,'role': role.name,'isActive': isActive};
  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    id: j['id'], name: j['name'], email: j['email'] ?? '', role: UserRole.values.byName(j['role'] ?? 'learner'),
    isActive: (j['isActive'] as bool?) ?? true,
  );
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  static const _prefsKey = 'admin_users';
  List<AppUser> _users = [];
  String _query = '';
  UserRole? _filter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return setState(() => _users = []);
    final list = (jsonDecode(raw) as List).map((e) => AppUser.fromJson(Map<String, dynamic>.from(e))).toList();
    setState(() => _users = list);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_users.map((u) => u.toJson()).toList()));
  }

  void _createOrEdit({AppUser? user}) {
    final name = TextEditingController(text: user?.name ?? '');
    final email = TextEditingController(text: user?.email ?? '');
    UserRole role = user?.role ?? UserRole.learner;

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
                DropdownMenuItem(value: UserRole.learner, child: Text('Apprenant')),
                DropdownMenuItem(value: UserRole.educator, child: Text('Éducateur')),
                DropdownMenuItem(value: UserRole.admin, child: Text('Admin')),
              ],
              onChanged: (v) => role = v ?? role,
              decoration: const InputDecoration(labelText: 'Rôle'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            onPressed: () async {
              if (name.text.trim().isEmpty) return;
              setState(() {
                if (user == null) {
                  _users.add(AppUser(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name.text.trim(),
                    email: email.text.trim(),
                    role: role,
                    isActive: true,
                  ));
                } else {
                  final idx = _users.indexWhere((u) => u.id == user.id);
                  _users[idx] = user.copyWith(name: name.text.trim(), email: email.text.trim(), role: role);
                }
              });
              await _save();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(user == null ? 'Créer' : 'Enregistrer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var list = _users;
    if (_filter != null) list = list.where((u) => u.role == _filter).toList();
    if (_query.isNotEmpty) {
      list = list.where((u) => u.name.toLowerCase().contains(_query) || u.email.toLowerCase().contains(_query)).toList();
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
                  decoration: const InputDecoration(labelText: 'Rechercher', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                ),
              ),
              DropdownButton<UserRole?>(
                value: _filter,
                hint: const Text('Tous les rôles'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Tous')),
                  DropdownMenuItem(value: UserRole.learner, child: Text('Apprenants')),
                  DropdownMenuItem(value: UserRole.educator, child: Text('Éducateurs')),
                  DropdownMenuItem(value: UserRole.admin, child: Text('Admins')),
                ],
                onChanged: (v) => setState(() => _filter = v),
              ),
              FilledButton.icon(onPressed: () => _createOrEdit(), icon: const Icon(Icons.person_add), label: const Text('Créer')),
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
                  subtitle: Text('${u.email} • ${roleToText(u.role)}${u.isActive ? '' : ' • inactif'}'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: Icon(u.isActive ? Icons.toggle_on : Icons.toggle_off),
                        onPressed: () async {
                          setState(() => _users[_users.indexWhere((x) => x.id == u.id)] = u.copyWith(isActive: !u.isActive));
                          await _save();
                        },
                      ),
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _createOrEdit(user: u)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          setState(() => _users.removeWhere((x) => x.id == u.id));
                          await _save();
                        },
                      ),
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