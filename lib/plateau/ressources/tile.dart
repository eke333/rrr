import 'package:flutter/material.dart';

enum TileType { Royalty, Religion, Neutral }

class Tile {
  final String name;
  final TileType type;
  final IconData icon;
  final double rotation;
  late final bool isImmune; // Immunité contre les effets
  bool effectIsActivated; // Pouvoir instantané activé ou non

  Tile({
    required this.name,
    required this.type,
    required this.icon,
    required this.rotation,
    this.isImmune = false, // Par défaut, non immunisé
    this.effectIsActivated = true, // Par défaut, pouvoir actif
  });

  // Détermine dynamiquement la couleur du texte
  Color get textColor => effectIsActivated ? Colors.black : Colors.orange;
}
