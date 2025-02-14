import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:rrr/constants/rrr_colors.dart';
import 'package:rrr/plateau/ressources/la_logique.dart';
import 'dart:math';
import 'package:rrr/plateau/ressources/les_tuiles.dart';
import 'package:rrr/plateau/ressources/tile.dart';

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
              height: Constants.screenWidth(context)*0.40,
              width: Constants.screenWidth(context)*0.40,
              child: Lottie.asset('assets/lotties/winner.json'), // Chemin vers l'animation Lottie
            )
                : SizedBox.shrink(),

          // Affichage des tuiles bleues pour Religion
          if (gameLogic.currentPlayer == TileType.Religion)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Religion joue", style: TextStyle(color: RrrColors.rrr_home_icon, fontSize: Constants.screenWidth(context)*0.045, fontWeight: FontWeight.bold)),
                SizedBox(width: Constants.screenWidth(context)*0.02),
                Icon(Icons.church, size: Constants.screenWidth(context)*0.06, color: RrrColors.rrr_home_icon),
              ],
            ),
          buildScrollableRow(gameLogic.availableBlueTiles),

          SizedBox(height: Constants.screenHeight(context)*0.005),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildBoard(),
              SizedBox(height: Constants.screenWidth(context)*0.01),
              buildScrollableColumn(gameLogic.selectedGrayTiles),
            ],
          ),

          SizedBox(height: Constants.screenHeight(context)*0.005),
          buildScrollableRow(gameLogic.availableRedTiles),
          SizedBox(height: Constants.screenHeight(context)*0.005),

          // Affichage des tuiles rouges pour Royaume
          if (gameLogic.currentPlayer == TileType.Royalty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Royaume joue", style: TextStyle(color: Colors.red, fontSize: Constants.screenWidth(context)*0.045, fontWeight: FontWeight.bold)),
                SizedBox(width: Constants.screenWidth(context)*0.02),
                Icon(FontAwesomeIcons.crown, size: Constants.screenWidth(context)*0.05, color: Colors.red),
              ],
            ),
          // Affichage de l'animation Lottie si un joueur a gagné
          if (gameLogic.showWinnerAnimation)
          // Positionner l'animation en fonction du joueur gagnant
            gameLogic.currentPlayer == TileType.Royalty
                ? Container(
              height: Constants.screenWidth(context)*0.35,
              width: Constants.screenWidth(context)*0.35,
              child: Lottie.asset('assets/lotties/winner.json'), // Chemin vers l'animation Lottie
            )
                : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget buildBoard() {
    return Column(
      children: List.generate(3, (row) {
        return Row(
          children: List.generate(3, (col) {
            return DragTarget<Tile>(
              onAccept: (tile) => gameLogic.onTileDropped(row, col, tile, context), // Passe le context ici
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: Constants.screenWidth(context) * 0.18,
                  height: Constants.screenWidth(context) * 0.18,
                  margin: EdgeInsets.all(4.0),
                  color: gameLogic.board[row][col] != null ? Colors.white : Colors.grey[300],
                  child: Center(
                    child: gameLogic.board[row][col] != null
                        ? buildTile(gameLogic.board[row][col]!, isOnBoard: true)
                        : Container(),
                  ),
                );
              },
            );
          }),
        );
      }),
    );
  }


  Widget buildScrollableRow(List<Tile> tiles) {
    return SizedBox(
      height: Constants.screenHeight(context)*0.1,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tiles.map((tile) => buildDraggableTile(tile)).toList(),
        ),
      ),
    );
  }

  Widget buildScrollableColumn(List<Tile> tiles) {
    return SizedBox(
      width: Constants.screenWidth(context)*0.20,
      height: Constants.screenHeight(context)*0.315,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: tiles.map((tile) => buildDraggableTile(tile)).toList(),
        ),
      ),
    );
  }

  Widget buildDraggableTile(Tile tile) {
    return Draggable<Tile>(
      data: tile,
      feedback: buildTile(tile, isDragging: true),
      childWhenDragging: Opacity(opacity: 0.5, child: buildTile(tile)),
      child: buildTile(tile),
    );
  }

  Widget buildTile(Tile tile, {bool isOnBoard = false, bool isDragging = false}) {
    return Container(
      margin: EdgeInsets.all(2),
      width: isDragging ? Constants.screenWidth(context)*0.15 : Constants.screenWidth(context)*0.125,
      height: isDragging ? Constants.screenWidth(context)*0.15 : Constants.screenWidth(context)*0.125,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isOnBoard ? Colors.black : Colors.blue,
          width: Constants.screenWidth(context)*0.005,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(tile.icon, size: Constants.screenWidth(context)*0.03, color: gameLogic.getTileColor(tile.type)),
          SizedBox(height: Constants.screenHeight(context)*0.0025),
          Text(tile.name, textAlign: TextAlign.center, style: TextStyle(fontSize: Constants.screenWidth(context)*0.024, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}