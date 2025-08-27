import 'package:flutter/material.dart';
import 'package:jeuEducatif/services/storageservice.dart';

class UserProfilePage extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  /// 'learner' | 'educator' | 'admin'
  final String initialRole;
  /// Optionnel: mot de passe actuel (non affiché). L’utilisateur pourra en définir un nouveau.
  final String? initialPassword;

  /// Callback si tu veux gérer l’enregistrement toi-même.
  /// Sinon, la page fera: Navigator.pop(context, {...})
  final void Function({
  required String name,
  required String email,
  required String role,
  String? newPassword,
  String? avatarUrl,
  String? classe,
  })? onSaved;

  const UserProfilePage({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialRole,
    this.initialPassword,
    this.onSaved,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordConfirmCtrl = TextEditingController();
  final _avatarCtrl = TextEditingController();
  final _classeCtrl = TextEditingController();
  final _storage = GameStorage();

  late String _role; // 'learner' | 'educator' | 'admin'
  bool _changingPassword = false;
  bool _obscurePwd = true;
  bool _obscurePwd2 = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.initialName;
    _emailCtrl.text = widget.initialEmail;
    _role = _normalizeRole(widget.initialRole);
    final u = _storage.getCurrentUser();
    _avatarCtrl.text = u?.avatarUrl ?? '';
    _classeCtrl.text = u?.classe ?? '';
  }

  String _normalizeRole(String v) {
    final s = v.toLowerCase().trim();
    if (s.contains('educator') || s.contains('prof') || s.contains('enseign')) return 'educator';
    if (s.contains('admin')) return 'admin';
    return 'learner';
  }

  String _roleLabel(String v) {
    switch (v) {
      case 'educator':
        return 'Éducateur';
      case 'admin':
        return 'Admin';
      default:
        return 'Apprenant';
    }
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email obligatoire';
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) return 'Email invalide';
    return null;
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nom obligatoire';
    if (v.trim().length < 2) return 'Nom trop court';
    return null;
  }

  String? _validatePassword(String? v) {
    if (!_changingPassword) return null;
    final value = v ?? '';
    if (value.length < 6) return 'Mot de passe: 6+ caractères';
    return null;
  }

  String? _validatePasswordConfirm(String? v) {
    if (!_changingPassword) return null;
    if (v != _passwordCtrl.text) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      'name': _nameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'role': _role, // 'learner' | 'educator' | 'admin'
      'newPassword': _changingPassword ? _passwordCtrl.text : null,
      'avatarUrl': _avatarCtrl.text.trim().isEmpty ? null : _avatarCtrl.text.trim(),
      'classe': _classeCtrl.text.trim().isEmpty ? null : _classeCtrl.text.trim(),
    };

    // Mise à jour stockage local pour affichage nom/photo dans le dashboard
    await _storage.updateUserProfile(
      nomPrenom: payload['name'] as String,
      avatarUrl: payload['avatarUrl'] as String?,
      classe: payload['classe'] as String?,
    );

    if (widget.onSaved != null) {
      widget.onSaved!(
        name: payload['name'] as String,
        email: payload['email'] as String,
        role: payload['role'] as String,
        newPassword: payload['newPassword'] as String?,
        avatarUrl: payload['avatarUrl'] as String?,
        classe: payload['classe'] as String?,
      );
      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) Navigator.pop(context, payload);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    _avatarCtrl.dispose();
    _classeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roles = const [
      ('learner', 'Apprenant'),
      ('educator', 'Éducateur'),
      ('admin', 'Admin'),
    ];

    final displayName = _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : _emailCtrl.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil utilisateur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Enregistrer',
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: (_avatarCtrl.text.trim().isNotEmpty)
                      ? NetworkImage(_avatarCtrl.text.trim())
                      : null,
                  child: (_avatarCtrl.text.trim().isEmpty)
                      ? Text(
                          (displayName.isNotEmpty ? displayName[0] : '?').toUpperCase(),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateName,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _role,
              items: roles
                  .map((r) => DropdownMenuItem<String>(
                value: r.$1,
                child: Text(r.$2),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _role = v ?? 'learner'),
              decoration: const InputDecoration(
                labelText: 'Rôle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _classeCtrl,
              decoration: const InputDecoration(
                labelText: 'Classe (optionnel)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _avatarCtrl,
              decoration: const InputDecoration(
                labelText: 'Avatar URL (optionnel)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _changingPassword,
              onChanged: (v) => setState(() => _changingPassword = v),
              title: const Text('Modifier le mot de passe'),
            ),
            if (_changingPassword) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePwd,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePwd ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePwd = !_obscurePwd),
                  ),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordConfirmCtrl,
                obscureText: _obscurePwd2,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePwd2 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePwd2 = !_obscurePwd2),
                  ),
                ),
                validator: _validatePasswordConfirm,
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}