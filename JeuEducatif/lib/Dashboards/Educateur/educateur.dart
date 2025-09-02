import 'package:flutter/material.dart';
import 'package:jeuEducatif/Game_page.dart';

import '../Apprenant/jouer.dart';
import 'Profil.dart';

import 'evaluation.dart';
import 'listes.dart';
import 'message.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light, // Forcer le mode clair
      scaffoldBackgroundColor: Colors.white, // Fond blanc
    ),
    home: EDUCATEURDashboard(user: {
      'id': 1,
      'nomPrenom': 'Alice Dupont',
      'email': 'alice@example.com',
      'role': 'APPRENANT',
    },),));

}

class EDUCATEURDashboard extends StatefulWidget {

  final Map<String, dynamic> user; // <-- ajouter ceci

  const EDUCATEURDashboard({super.key ,required this.user});

  @override
  State<EDUCATEURDashboard> createState() => _EDUCATEURDashboardState();
}

class _EDUCATEURDashboardState extends State<EDUCATEURDashboard> {
  Widget currentScreen = Center(
    child: Text(
      'Contenu principal ici',
      style: TextStyle(fontSize: 24),
    ),
  );

  void changeScreen(Widget screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar toujours visible
          Container(
            width: 250,
            color: Colors.grey[300],
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      widget.user['nomPrenom'], // ← nom dynamique
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    SidebarButton(
                      icon: Icons.home,
                      label: 'Home',
                      selected: currentScreen is Center,
                      onTap: () => changeScreen(
                        Center(child: Text('Accueil', style: TextStyle(fontSize: 24))),
                      ),
                    ),
                    SidebarButton(
                      icon: Icons.help_outline,
                      label: 'Gerer son profil',
                      onTap: () => changeScreen(ProfilPage()),
                    ),
                    SidebarButton(
                      icon: Icons.feedback_outlined,
                      label: 'Listes de jeux disponibles',
                      onTap: () => changeScreen(GamesListPage()),
                    ),
                    SidebarButton(
                      icon: Icons.group_add_outlined,
                      label: 'Jouer',
                      onTap: () => changeScreen(JouerPage(quizData: {})),
                    ),
                    SidebarButton(
                      icon: Icons.star_border,
                      label: 'Generer un jeu',
                      onTap: () => changeScreen(GamePage()),
                    ),
                    SidebarButton(
                      icon: Icons.info_outline,
                      label: 'Messages',
                      onTap: () => changeScreen(NotificationsPage()),
                    ),
                    SizedBox(height: 30),

                    SidebarButton(
                      icon: Icons.info_outline,
                      label: 'lancer evaluation',
                      onTap: () => changeScreen(EvaluationLauncherPage()),
                    ),
                    SizedBox(height: 30),
                    SidebarButton(
                      icon: Icons.power_settings_new,
                      label: 'Sign Out',
                      iconColor: Colors.red,
                      onTap: () {
                        // Déconnexion
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Contenu principal qui change
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(24.0),
              child: currentScreen,
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color? iconColor;
  final VoidCallback? onTap;

  const SidebarButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? Colors.blue[100] : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.black),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}
