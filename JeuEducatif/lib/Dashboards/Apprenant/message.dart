import 'package:flutter/material.dart';

class AproposPage extends StatelessWidget {
  const AproposPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À propos'),
        backgroundColor: Color(0xFF7E57C2),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Entête avec logo ou image
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png', // logo ou image par défaut
                    width: 120,
                    height: 120,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Jeu Educatif Makon",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[800],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // ✅ Description de l'application
            Text(
              "À propos de l'application",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Cette application éducative permet aux apprenants de découvrir des jeux interactifs "
                  "pour apprendre tout en s'amusant. Les éducateurs peuvent créer et gérer les jeux, "
                  "suivre les progrès des apprenants et envoyer des notifications.",
              style: TextStyle(fontSize: 16, color: Colors.deepPurple[600]),
            ),

            SizedBox(height: 24),

            // ✅ Fonctionnalités clés
            Text(
              "Fonctionnalités clés",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[700],
              ),
            ),
            SizedBox(height: 12),

            Column(
              children: [
                FeatureCard(
                  icon: Icons.play_circle_fill,
                  title: "Jouer à des jeux éducatifs",
                  description:
                  "Accédez à une variété de jeux éducatifs pour tester vos connaissances.",
                ),
                FeatureCard(
                  icon: Icons.add_circle_outline,
                  title: "Créer des jeux",
                  description:
                  "Les éducateurs peuvent créer facilement de nouveaux jeux et quiz.",
                ),
                FeatureCard(
                  icon: Icons.group,
                  title: "Suivi des apprenants",
                  description:
                  "Suivez les progrès des apprenants et identifiez les besoins spécifiques.",
                ),
                FeatureCard(
                  icon: Icons.notifications,
                  title: "Notifications",
                  description:
                  "Recevez ou envoyez des notifications importantes aux utilisateurs.",
                ),
              ],
            ),

            SizedBox(height: 24),

            // ✅ Footer ou contact
            Center(
              child: Text(
                "© 2025 Jeu Educatif Makon. Tous droits réservés.",
                style: TextStyle(color: Colors.deepPurple[400], fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard(
      {super.key,
        required this.icon,
        required this.title,
        required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: Colors.deepPurple[800]),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple[600],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

