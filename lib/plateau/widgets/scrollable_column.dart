import 'package:flutter/material.dart';
import '../ressources/tile.dart';
import 'draggable_tile.dart';

class ScrollableRow extends StatefulWidget {
  final List<Tile> tiles;

  const ScrollableRow({Key? key, required this.tiles}) : super(key: key);

  @override
  _ScrollableRowState createState() => _ScrollableRowState();
}

class _ScrollableRowState extends State<ScrollableRow> {
  void removeTile(Tile tile) {
    setState(() {
      widget.tiles.remove(tile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.tiles
              .map((tile) => DraggableTile(tile: tile, onTileDropped: removeTile))
              .toList(),
        ),
      ),
    );
  }
}
