import 'package:flutter/material.dart';
import '../ressources/tile.dart';
import 'build_tile.dart';

class DraggableTile extends StatefulWidget {
  final Tile tile;

  const DraggableTile({Key? key, required this.tile}) : super(key: key);

  @override
  State<DraggableTile> createState() => _DraggableTileState();
}

class _DraggableTileState extends State<DraggableTile> {
  @override
  Widget build(BuildContext context) {
    return Draggable<Tile>(
      data: widget.tile,
      feedback: BuildTile(tile: widget.tile, isDragging: true),
      childWhenDragging: Opacity(opacity: 0.5, child: BuildTile(tile: widget.tile)),
      child: BuildTile(tile: widget.tile),
    );
  }
}
