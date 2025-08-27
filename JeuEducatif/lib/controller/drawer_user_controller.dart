import 'package:flutter/material.dart';
import 'home_drawer.dart';

class DrawerUserController extends StatelessWidget {
  const DrawerUserController({
    Key? key,
    required this.screenIndex,
    required this.drawerWidth,
    required this.onDrawerCall,
    required this.screenView,
  }) : super(key: key);

  final DrawerIndex screenIndex;
  final double drawerWidth;
  final Function(DrawerIndex) onDrawerCall;
  final Widget screenView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: drawerWidth,
        child: HomeDrawer(
          screenIndex: screenIndex,
          callBackIndex: (DrawerIndex index) {
            onDrawerCall(index);
            Navigator.of(context).pop(); // Ferme le menu
          },
        ),
      ),
      body: screenView, // On garde la page fixe
    );
  }
}
