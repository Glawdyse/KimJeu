// lib/admin/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  String _keyPreview() {
    final k = dotenv.env['MISTRAL_API_KEY'] ?? '';
    if (k.isEmpty) return '(non configurée)';
    return k.length <= 8 ? k : '${k.substring(0, 4)}...${k.substring(k.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: const Text('Clé API Mistral'),
          subtitle: Text(_keyPreview()),
          leading: const Icon(Icons.lock_outline),
        ),
        const Divider(),
        const ListTile(
          title: Text('Rôles et modération'),
          subtitle: Text('Gérés localement dans cette démo. Branchez un backend pour la prod.'),
        ),
        const ListTile(
          title: Text('Notifications'),
          subtitle: Text('Diffusées dans l’app (sans push). Branchez FCM si besoin.'),
        ),
      ],
    );
  }
}