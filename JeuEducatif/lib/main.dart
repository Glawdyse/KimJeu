import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Erreur lors du chargement du fichier .env : $e');
  }

  runApp(const NellyLearnApp());
}

class NellyLearnApp extends StatelessWidget {
  const NellyLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NellyLearn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white24,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black87),
          labelLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🖼️ Image de fond
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // 🧊 Couche sombre pour lisibilité
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // 📋 Contenu principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🖼️ Logo + Nom
                  Column(
                    children: [
                      Image.asset('assets/images/logo.png', height: 100),
                      const SizedBox(height: 12.0),
                      const Text(
                        'NellyLearn',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),

                  // 🧠 Titre principal
                  const Text(
                    'Bienvenue sur NellyLearn',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),

                  // 📘 Description
                  const Text(
                    'Testez vos connaissances avec des quiz éducatifs adaptés aux apprenants et éducateurs ! '
                        'Choisissez un texte, un PDF ou un thème (programmation, analyse, culture générale) '
                        'pour générer un quiz interactif.',
                    style: TextStyle(fontSize: 16.0, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),

                  // 🎓 Icône éducative
                  const Icon(Icons.school, size: 80.0, color: Colors.white),
                  const SizedBox(height: 32.0),

                  // 🚀 Bouton d’accès au quiz
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    icon: const Icon(Icons.quiz),
                    label: const Text('Commencer un Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // 📄 À propos
                  Card(
                    color: Colors.white.withOpacity(0.85),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'À propos de NellyLearn',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Une application éducative pour explorer le domaine informatique et ses dérivés : '
                                'analyse, programmation, culture générale et bien plus encore !',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                 // const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
