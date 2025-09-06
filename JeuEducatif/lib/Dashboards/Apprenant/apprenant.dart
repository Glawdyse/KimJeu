import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jeuEducatif/Pages/login.dart';
import '../../Game_page.dart';
import '../../Pages/acceuil.dart';
import '../Educateur/jouer.dart';
import 'Profil.dart';
import 'gerer_profil.dart';
import 'listes.dart';
import 'message.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF7E57C2),
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
    ),
    home: APPRENANTDashboard(user: {
      'id': 1,
      'nomPrenom': 'Alice Dupont',
      'email': 'alice@example.com',
      'role': 'APPRENANT',
    }),
  ));
}

class APPRENANTDashboard extends StatefulWidget {
  final Map<String, dynamic> user;

  const APPRENANTDashboard({super.key, required this.user});

  @override
  State<APPRENANTDashboard> createState() => _APPRENANTDashboardState();
}

class _APPRENANTDashboardState extends State<APPRENANTDashboard> {
  Widget currentScreen = HomePage(); // 🔹 Page d’accueil par défaut

  Color avatarColor = Colors.deepPurple;
  late Timer colorTimer;

  @override
  void initState() {
    super.initState();
    // Changer la couleur de l'avatar toutes les secondes
    colorTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        avatarColor =
            Colors.purple[100 + Random().nextInt(400)] ?? Colors.deepPurple;
      });
    });
  }

  @override
  void dispose() {
    colorTimer.cancel();
    super.dispose();
  }

  void changeScreen(Widget screen) {
    setState(() {
      currentScreen = screen;
    });
    Navigator.of(context).pop(); // Ferme le drawer après sélection
  }

  String getInitial() {
    return widget.user['nomPrenom'].substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: avatarColor,
              child: Text(
                getInitial(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                color: Color(0xFF7E57C2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.user['nomPrenom'],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: avatarColor,
                      child: Text(
                        getInitial(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    DrawerButton(
                      icon: Icons.home,
                      label: 'Accueil',
                      onTap: () => changeScreen(HomePage()),
                    ),
                    DrawerButton(
                      icon: Icons.help_outline,
                      label: 'Gérer son profil',
                      onTap: () => changeScreen(GererProfilApprenantPage()),
                    ),
                    DrawerButton(
                      icon: Icons.feedback_outlined,
                      label: 'Listes de jeux disponibles',
                      onTap: () => changeScreen(GamesListPage()),
                    ),
                    DrawerButton(
                        icon: Icons.play_circle_fill,
                      label: 'Jouer',
                      onTap: () => changeScreen(JouerPage(quizData: {})),
                    ),
                    DrawerButton(
                       icon: Icons.add_circle_outline,
                      label: 'Générer un jeu',
                      onTap: () => changeScreen(GamePage()),
                    ),
                    DrawerButton(
                      icon: Icons.info_outline,
                      label: 'Apropos',
                      onTap: () => changeScreen(AproposPage()),
                    ),
                    Divider(color: Colors.grey[400]),
                    DrawerButton(
                      icon: Icons.power_settings_new,
                      label: 'Déconnexion',
                      iconColor: Colors.redAccent,
                      onTap: () => changeScreen(LoginPage()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.purple[50],
        padding: EdgeInsets.all(16.0),
        child: currentScreen,
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;

  const DrawerButton({
    required this.icon,
    required this.label,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: iconColor ?? Colors.deepPurple),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          color: Colors.deepPurple[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.purple[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
