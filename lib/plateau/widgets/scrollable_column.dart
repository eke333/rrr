import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../ressources/tile.dart';
import 'draggable_tile.dart'; // Assurez-vous que cette classe existe

class ScrollableColumn extends StatefulWidget {
  final List<Tile> tiles;

  const ScrollableColumn({Key? key, required this.tiles}) : super(key: key);

  @override
  State<ScrollableColumn> createState() => _ScrollableColumnState();
}

class _ScrollableColumnState extends State<ScrollableColumn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Constants.screenWidth(context) * 0.20,
      height: Constants.screenHeight(context) * 0.315,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: widget.tiles.map((tile) => DraggableTile(tile: tile)).toList(),
        ),
      ),
    );
  }
}
