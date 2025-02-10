import 'package:flutter/material.dart';
import 'package:rrr/constants/rrr_colors.dart';

class RrrAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titre;

  const RrrAppBar({
    super.key,
    required this.titre,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white), // Définit la couleur de l'icône retour en blanc
      title: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Text(
          titre,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: RrrColors.theme_app_bar,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
