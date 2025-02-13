import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../ressources/tile.dart';
import 'draggable_tile.dart';

class ScrollableRow extends StatefulWidget {
  final List<Tile> tiles;

  const ScrollableRow({Key? key, required this.tiles}) : super(key: key);

  @override
  _ScrollableRowState createState() => _ScrollableRowState();
}

class _ScrollableRowState extends State<ScrollableRow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Constants.screenHeight(context) * 0.1,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.tiles.map((tile) => DraggableTile(tile: tile)).toList(),
        ),
      ),
    );
  }
}
