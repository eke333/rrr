import 'package:flutter/material.dart';

enum TileType { Royalty, Religion, Neutral }

class Tile {
  final String name;
  final TileType type;
  final IconData icon;
  late final double rotation;
  bool isImmune; // Ajout de l'immunité

  Tile({
    required this.name,
    required this.type,
    required this.icon,
    required this.rotation,
    this.isImmune = false, // Valeur par défaut : non immunisé
  });
}
