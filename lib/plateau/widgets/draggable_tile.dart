import 'package:flutter/material.dart';
import '../ressources/tile.dart';
import 'build_tile.dart';

class DraggableTile extends StatefulWidget {
  final Tile tile;
  final Function(Tile) onTileDropped; // Callback pour mettre à jour la liste d'origine

  const DraggableTile({Key? key, required this.tile, required this.onTileDropped}) : super(key: key);

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
      onDragCompleted: () {
        widget.onTileDropped(widget.tile); // Supprime la tuile après placement
      },
    );
  }
}
