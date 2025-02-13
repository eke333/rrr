import 'package:flutter/material.dart';

enum TileType { Royalty, Religion, Neutral }

class Tile {
  late final TileType type;
  final String name;
  final IconData icon;
  final double rotation; // Ajout du champ rotation

  Tile({
    required this.type,
    required this.name,
    required this.icon,
    required this.rotation,
  });
}