import 'package:flutter/material.dart';
import 'package:rrr/plateau/ressources/tile.dart';
import '../../constants/constants.dart';
import '../ressources/la_logique.dart';

class BuildTile extends StatefulWidget {
  final Tile tile;
  final bool isOnBoard;
  final bool isDragging;

  const BuildTile({
    Key? key,
    required this.tile,
    this.isOnBoard = false,
    this.isDragging = false,
  }) : super(key: key);

  @override
  _BuildTileState createState() => _BuildTileState();
}

class _BuildTileState extends State<BuildTile> {

  late LaLogique gameLogic;

  @override
  void initState() {
    super.initState();
    gameLogic = LaLogique(onStateChange: () {  }); // Initialisation de la logique du jeu
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      width: widget.isDragging ? Constants.screenWidth(context) * 0.15 : Constants.screenWidth(context) * 0.125,
      height: widget.isDragging ? Constants.screenWidth(context) * 0.15 : Constants.screenWidth(context) * 0.125,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: widget.isOnBoard ? Colors.black : Colors.blue,
          width: Constants.screenWidth(context) * 0.005,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.tile.icon,
              size: Constants.screenWidth(context) * 0.07,
              color: gameLogic.getTileColor(widget.tile.type)
          ),
          SizedBox(height: Constants.screenHeight(context) * 0.005),
          Text(
            widget.tile.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.tile.textColor,
              fontSize: Constants.screenWidth(context) * 0.024,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
