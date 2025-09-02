// lib/Dashboards/Admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:jeuEducatif/Dashboards/Admin/parametre.dart';
import 'package:jeuEducatif/Dashboards/Admin/useradmin.dart';
import 'package:jeuEducatif/Dashboards/Admin/jeuadmin.dart';
import 'package:jeuEducatif/Pages/login.dart';
import 'package:jeuEducatif/Dashboards/Admin/notifications_page.dart';

class AdminDashboard extends StatefulWidget {
  final Map<String, dynamic> user; // <-- ajouter le paramètre user

  const AdminDashboard({super.key, required this.user});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _idx = 0;

  final List<Widget> _pages = const [
    UsersPage(),
    GamesAdminPage(),
    SettingsPage(),
  ];

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AdminNotificationsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // <-- afficher le nom de l'utilisateur connecté
        title: Text('Bienvenue, ${widget.user['nomPrenom']}'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: _openNotifications,
          ),
          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            label: 'Utilisateurs',
          ),
          NavigationDestination(
            icon: Icon(Icons.extension_outlined),
            label: 'Jeux',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}
