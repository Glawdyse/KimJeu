import 'package:flutter/material.dart';
import 'package:jeuEducatif/services/storageservice.dart';

class GererProfilApprenantPage extends StatefulWidget {
  const GererProfilApprenantPage({super.key});

  @override
  State<GererProfilApprenantPage> createState() => _GererProfilApprenantPageState();
}

class _GererProfilApprenantPageState extends State<GererProfilApprenantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _avatarCtrl = TextEditingController();
  final _classeCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _pwd2Ctrl = TextEditingController();
  final _storage = GameStorage();

  bool _changingPassword = false;
  bool _obscurePwd = true;
  bool _obscurePwd2 = true;

  @override
  void initState() {
    super.initState();
    final u = _storage.getCurrentUser();
    _nameCtrl.text = u?.nomPrenom ?? '';
    _emailCtrl.text = u?.email ?? '';
    _avatarCtrl.text = u?.avatarUrl ?? '';
    _classeCtrl.text = u?.classe ?? '';
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
    if (v != _pwdCtrl.text) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // 1) Sauvegarde locale (nom, avatar, classe)
    await _storage.updateUserProfile(
      nomPrenom: _nameCtrl.text.trim(),
      avatarUrl: _avatarCtrl.text.trim().isEmpty ? null : _avatarCtrl.text.trim(),
      classe: _classeCtrl.text.trim().isEmpty ? null : _classeCtrl.text.trim(),
    );

    // 2) (Optionnel) Appel backend pour persister le profil et le mot de passe
    // final token = _storage.getAuthToken();
    // if (token != null) {
    //   await UserService.updateMyProfile(
    //     token: token,
    //     nomPrenom: _nameCtrl.text.trim(),
    //     avatarUrl: _avatarCtrl.text.trim().isEmpty ? null : _avatarCtrl.text.trim(),
    //     classe: _classeCtrl.text.trim().isEmpty ? null : _classeCtrl.text.trim(),
    //   );
    //   if (_changingPassword && _pwdCtrl.text.isNotEmpty) {
    //     // Implémenter endpoint côté backend pour changer le mot de passe
    //   }
    // }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil enregistré.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _avatarCtrl.dispose();
    _classeCtrl.dispose();
    _pwdCtrl.dispose();
    _pwd2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : _emailCtrl.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer mon profil'),
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
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Email (non modifiable)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _classeCtrl,
              decoration: const InputDecoration(
                labelText: 'Classe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _avatarCtrl,
              decoration: const InputDecoration(
                labelText: 'Avatar URL',
                border: OutlineInputBorder(),
                hintText: 'https://.../photo.png',
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
                controller: _pwdCtrl,
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
                controller: _pwd2Ctrl,
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
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
