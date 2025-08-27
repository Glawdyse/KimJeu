// lib/Dashboards/Admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:jeuEducatif/Dashboards/Admin/parametre.dart';   // => doit exposer SettingsPage
import 'package:jeuEducatif/Dashboards/Admin/useradmin.dart';   // => doit exposer UsersPage
import 'package:jeuEducatif/Dashboards/Admin/jeuadmin.dart';    // => doit exposer GamesAdminPage
import 'package:jeuEducatif/Pages/login.dart';                  // => LoginPage
import 'package:jeuEducatif/Dashboards/Admin/notifications_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _idx = 0;

  final List<Widget> _pages = const [
    UsersPage(),        // depuis useradmin.dart
    GamesAdminPage(),   // depuis jeuadmin.dart
    SettingsPage(),     // depuis parametre.dart
  ];

  void _logout() {
    // TODO: effacer le token/session si nécessaire
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
        title: const Text('Administration'),
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