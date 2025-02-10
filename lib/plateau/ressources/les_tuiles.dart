import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/tuile.dart';

class LesTuiles {
  final List<Tile> blueTiles = [
    Tile(type: TileType.Religion, name: "Pape", icon: Icons.account_balance, rotation: pi),
    Tile(type: TileType.Religion, name: "Cardinal", icon: Icons.flag, rotation: pi),
    Tile(type: TileType.Religion, name: "Évêque", icon: Icons.military_tech, rotation: pi),
    Tile(type: TileType.Religion, name: "Prêtre", icon: Icons.self_improvement, rotation: pi),
    Tile(type: TileType.Religion, name: "Moine", icon: Icons.spa, rotation: pi),
    Tile(type: TileType.Religion, name: "Nonne", icon: Icons.volunteer_activism, rotation: pi),
    Tile(type: TileType.Religion, name: "Temple", icon: Icons.temple_buddhist, rotation: pi),
  ];

  final List<Tile> redTiles = [
    Tile(type: TileType.Royalty, name: "Roi", icon: Icons.workspace_premium, rotation: 0),
    Tile(type: TileType.Royalty, name: "Reine", icon: Icons.diamond, rotation: 0),
    Tile(type: TileType.Royalty, name: "Prince", icon: Icons.star, rotation: 0),
    Tile(type: TileType.Royalty, name: "Princesse", icon: Icons.auto_awesome, rotation: 0),
    Tile(type: TileType.Royalty, name: "Général", icon: Icons.shield, rotation: 0),
    Tile(type: TileType.Royalty, name: "Chevalier", icon: Icons.security, rotation: 0),
    Tile(type: TileType.Royalty, name: "Château", icon: Icons.castle, rotation: 0),
  ];

  final List<Tile> allGrayTiles = [
    Tile(type: TileType.Neutral, name: "Citoyen", icon: Icons.person, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Sorcière", icon: Icons.wb_sunny, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Chaman", icon: Icons.brightness_7, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Assassin", icon: Icons.hiking, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Pirate", icon: Icons.anchor, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Faucheuse", icon: Icons.heart_broken, rotation: 3 * pi / 2), // Remplacement ici
    Tile(type: TileType.Neutral, name: "Marchand", icon: Icons.shopping_cart, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Mendiant", icon: Icons.card_giftcard, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Hérétique", icon: Icons.flash_on, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Espion", icon: Icons.remove_red_eye, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Traître", icon: Icons.arrow_back, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Garde", icon: Icons.security, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Tour", icon: Icons.business, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Bibliothécaire", icon: Icons.book, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Alchimiste", icon: Icons.science, rotation: 3 * pi / 2), // Remplacement ici
    Tile(type: TileType.Neutral, name: "Prophète", icon: Icons.lightbulb, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Sage", icon: Icons.account_circle, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Oracle", icon: Icons.visibility, rotation: 3 * pi / 2),
  ];
}
