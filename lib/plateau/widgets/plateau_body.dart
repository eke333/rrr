import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:rrr/constants/rrr_colors.dart';
import 'package:rrr/plateau/ressources/la_logique.dart';
import 'dart:math';
import 'package:rrr/plateau/ressources/les_tuiles.dart';
import 'package:rrr/plateau/ressources/tile.dart';
import 'board.dart';
import 'scrollable_column.dart'; // Import du widget ScrollableColumn
import 'scrollable_row.dart';    // Import du widget ScrollableRow
import 'draggable_tile.dart';    // Import du widget DraggableTile
import 'build_tile.dart';        // Import du widget BuildTile
import '../../constants/constants.dart';

class PlateauBody extends StatefulWidget {
  const PlateauBody({super.key});

  @override
  State<PlateauBody> createState() => _PlateauBodyState();
}

class _PlateauBodyState extends State<PlateauBody> {
  late LaLogique gameLogic;

  @override
  void initState() {
    super.initState();
    gameLogic = LaLogique(onStateChange: () => setState(() {}));
    gameLogic.selectedGrayTiles = gameLogic.selectRandomGrayTiles();
    gameLogic.availableBlueTiles = List.from(LesTuiles().blueTiles);
    gameLogic.availableRedTiles = List.from(LesTuiles().redTiles);
    gameLogic.currentPlayer = Random().nextBool() ? TileType.Religion : TileType.Royalty;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Affichage de l'animation Lottie si un joueur a gagné
          if (gameLogic.showWinnerAnimation)
          // Positionner l'animation en fonction du joueur gagnant
            gameLogic.currentPlayer == TileType.Religion
                ? Container(
              height: Constants.screenWidth(context) * 0.40,
              width: Constants.screenWidth(context) * 0.40,
              child: Lottie.asset('assets/lotties/winner.json'), // Chemin vers l'animation Lottie
            )
                : SizedBox.shrink(),

          // Affichage des tuiles bleues pour Religion
          if (gameLogic.currentPlayer == TileType.Religion)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Religion joue", style: TextStyle(color: RrrColors.rrr_home_icon, fontSize: Constants.screenWidth(context) * 0.045, fontWeight: FontWeight.bold)),
                SizedBox(width: Constants.screenWidth(context) * 0.02),
                Icon(Icons.church, size: Constants.screenWidth(context) * 0.06, color: RrrColors.rrr_home_icon),
              ],
            ),
          ScrollableRow(tiles: gameLogic.availableBlueTiles),  // Remplacer buildScrollableRow

          SizedBox(height: Constants.screenHeight(context) * 0.005),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Board(), // Remplacer buildBoard
              SizedBox(height: Constants.screenWidth(context) * 0.01),
              ScrollableColumn(tiles: gameLogic.selectedGrayTiles), // Remplacer buildScrollableColumn
            ],
          ),

          SizedBox(height: Constants.screenHeight(context) * 0.005),
          ScrollableRow(tiles: gameLogic.availableRedTiles), // Remplacer buildScrollableRow
          SizedBox(height: Constants.screenHeight(context) * 0.005),

          // Affichage des tuiles rouges pour Royaume
          if (gameLogic.currentPlayer == TileType.Royalty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Royaume joue", style: TextStyle(color: Colors.red, fontSize: Constants.screenWidth(context) * 0.045, fontWeight: FontWeight.bold)),
                SizedBox(width: Constants.screenWidth(context) * 0.02),
                Icon(FontAwesomeIcons.crown, size: Constants.screenWidth(context) * 0.05, color: Colors.red),
              ],
            ),
          // Affichage de l'animation Lottie si un joueur a gagné
          if (gameLogic.showWinnerAnimation)
          // Positionner l'animation en fonction du joueur gagnant
            gameLogic.currentPlayer == TileType.Royalty
                ? Container(
              height: Constants.screenWidth(context) * 0.35,
              width: Constants.screenWidth(context) * 0.35,
              child: Lottie.asset('assets/lotties/winner.json'), // Chemin vers l'animation Lottie
            )
                : SizedBox.shrink(),
        ],
      ),
    );
  }
}
