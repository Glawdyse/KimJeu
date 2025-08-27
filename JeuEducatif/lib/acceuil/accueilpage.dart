import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFB2EBF2), // Fond bleu clair
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF00B8D4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo et slogan
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png', // logo dauphin
                        height: 50,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'nell',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          Text(
                            'Le site de jeux éducatifs en ligne',
                            style: TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                  // Boutons connexion/inscription
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        onPressed: () {},
                        child: const Text('Connexion'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        onPressed: () {},
                        child: const Text('Inscription'),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // BARRE DE NIVEAUX
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.transparent,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...['Maternelle', 'CP', 'CE1', 'CE2', 'CM1', 'CM2', 'Collège']
                      .map((text) => _levelButton(text, Colors.orange)),
                  _levelButton('Fiches', Colors.green),
                ],
              ),
            ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MENU LATERAL
                  Container(
                    width: screenWidth * 0.15,
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _menuButton('MATHÉMATIQUES', Colors.red),
                        _menuButton('FRANÇAIS', Colors.blue),
                        _menuButton('ÉVEIL', Colors.green),
                        _menuButton('THÈMES', Colors.teal),
                      ],
                    ),
                  ),
                  // CONTENU CENTRAL
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Des jeux... au service de la pédagogie !',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.blue.shade100,
                              child: const Text('Bonnes vacances à tous !'),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Les derniers jeux mis à l\'honneur',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _gameCard('assets/casse_tuiles.png',
                                      'Casse-tuiles football'),
                                  _gameCard('assets/foot_flipper.png',
                                      'Foot Flipper de la jungle'),
                                  _gameCard('assets/cut_dunk.png',
                                      'Cut and dunk'),
                                  _gameCard('assets/football_brawl.png',
                                      'Football brawl'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {},
                              child: const Text('Voir tous les derniers jeux'),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Rechercher un jeu :',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                  ),
                                  onPressed: () {},
                                  child: const Text('Rechercher'),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _levelButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _menuButton(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          text,
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static Widget _gameCard(String imagePath, String title) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
