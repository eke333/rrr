import 'package:flutter/material.dart';
import 'package:rrr/plateau/ressources/tile.dart';
import '../../constants/constants.dart';
import '../ressources/la_logique.dart';
import 'build_tile.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late LaLogique gameLogic;

  @override
  void initState() {
    super.initState();
    gameLogic = LaLogique(onStateChange: () {  }); // Initialisation de la logique du jeu
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return DragTarget<Tile>(
              onAcceptWithDetails: (tile) => setState(() => gameLogic.onTileDropped(row, col, tile as Tile, context)),
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: Constants.screenWidth(context) * 0.18,
                  height: Constants.screenWidth(context) * 0.18,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: gameLogic.board[row][col] != null ? Colors.white : Colors.grey[300],
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Center(
                    child: gameLogic.board[row][col] != null
                        ? BuildTile(tile: gameLogic.board[row][col]!, isOnBoard: true)
                        : const SizedBox.shrink(),
                  ),
                );
              },
            );
          }),
        );
      }),
    );
  }
}
