import 'package:flutter/material.dart';
import '../Dashboards/Apprenant/colors.dart';

enum DrawerIndex { HOME, Help, FeedBack, Invite }

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
    required this.screenIndex,
    required this.callBackIndex,
  }) : super(key: key);

  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.nearlyWhite,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.nearlyBlue,
            ),
            child: const Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _drawerItem(Icons.home, 'Accueil', DrawerIndex.HOME),
          _drawerItem(Icons.help, 'Aide', DrawerIndex.Help),
          _drawerItem(Icons.feedback, 'Feedback', DrawerIndex.FeedBack),
          _drawerItem(Icons.group_add, 'Inviter un ami', DrawerIndex.Invite),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, DrawerIndex index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: screenIndex == index,
      onTap: () => callBackIndex(index),
    );
  }
}
