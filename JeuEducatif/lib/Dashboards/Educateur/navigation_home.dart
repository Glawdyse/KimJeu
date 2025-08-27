import 'package:flutter/material.dart';
import '../../controller/drawer_user_controller.dart';
import '../../controller/home_drawer.dart';
import '../Apprenant/colors.dart';
import '../Apprenant/listes.dart';
import '../Educateur/Profil.dart';
import '../Educateur/jouer.dart';
import '../Educateur/message.dart';
import 'evaluation.dart';
import 'package:jeuEducatif/services/storageservice.dart';
import 'package:jeuEducatif/Dashboards/Apprenant/Profil.dart' as profile_edit;

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView = const ProfilPage();
  DrawerIndex drawerIndex = DrawerIndex.HOME;
  final _storage = GameStorage();

  Future<void> _openEditProfile() async {
    final u = _storage.getCurrentUser();
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => profile_edit.UserProfilePage(
          initialName: u?.nomPrenom ?? '',
          initialEmail: u?.email ?? '',
          initialRole: u?.role ?? 'educator',
        ),
      ),
    );
    if (result is Map) {
      await _storage.updateUserProfile(
        nomPrenom: (result['name'] as String?)?.trim(),
        avatarUrl: (result['avatarUrl'] as String?)?.trim(),
        classe: (result['classe'] as String?)?.trim(),
      );
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _storage.getAvatarUrl();
    final displayName = _storage.getDisplayName();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                  ? NetworkImage(avatarUrl)
                  : null,
              child: (avatarUrl == null || avatarUrl.isEmpty)
                  ? Text(
                      (displayName.isNotEmpty ? displayName[0] : '?').toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Gérer profil',
            icon: const Icon(Icons.edit),
            onPressed: _openEditProfile,
          ),
        ],
      ),
      backgroundColor: AppTheme.nearlyWhite,
      body: DrawerUserController(
        screenIndex: drawerIndex,
        drawerWidth: MediaQuery.of(context).size.width * 0.75,
        onDrawerCall: changeIndex,
        screenView: screenView,
      ),
      floatingActionButton: drawerIndex == DrawerIndex.FeedBack
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EvaluationLauncherPage()),
              ),
              icon: const Icon(Icons.assignment_turned_in_outlined),
              label: const Text('Évaluation'),
            )
          : null,
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      setState(() {
        drawerIndex = drawerIndexdata;
        switch (drawerIndex) {
          case DrawerIndex.HOME:
            screenView = const ProfilPage();
            break;
          case DrawerIndex.Help:
            screenView = NotificationsPage();
            break;
          case DrawerIndex.FeedBack:
            screenView = GamesListPage();
            break;
          case DrawerIndex.Invite:
            screenView = JouerPage(quizData: {});
            break;
          default:
            screenView = const ProfilPage();
        }
      });
    }
  }
}
