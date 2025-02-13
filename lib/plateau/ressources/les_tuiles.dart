import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tile.dart';

class LesTuiles {
  final List<Tile> blueTiles = [
    Tile(type: TileType.Religion, name: "Pape", icon: FontAwesomeIcons.cross, rotation: pi),
    Tile(type: TileType.Religion, name: "Cardinal", icon: FontAwesomeIcons.church, rotation: pi),
    Tile(type: TileType.Religion, name: "Évêque", icon: FontAwesomeIcons.hatCowboy, rotation: pi),
    Tile(type: TileType.Religion, name: "Prêtre", icon: FontAwesomeIcons.personPraying, rotation: pi),
    Tile(type: TileType.Religion, name: "Moine", icon: FontAwesomeIcons.bookBible, rotation: pi),
    Tile(type: TileType.Religion, name: "Nonne", icon: FontAwesomeIcons.handsPraying, rotation: pi),
    Tile(type: TileType.Religion, name: "Temple", icon: FontAwesomeIcons.kaaba, rotation: pi),
  ];

  final List<Tile> redTiles = [
    Tile(type: TileType.Royalty, name: "Roi", icon: FontAwesomeIcons.crown, rotation: 0),
    Tile(type: TileType.Royalty, name: "Reine", icon: FontAwesomeIcons.chessQueen, rotation: 0),
    Tile(type: TileType.Royalty, name: "Prince", icon: FontAwesomeIcons.solidStar, rotation: 0),
    Tile(type: TileType.Royalty, name: "Princesse", icon: FontAwesomeIcons.solidStarHalfStroke, rotation: 0),
    Tile(type: TileType.Royalty, name: "Général", icon: FontAwesomeIcons.shieldHalved, rotation: 0),
    Tile(type: TileType.Royalty, name: "Chevalier", icon: FontAwesomeIcons.chessKnight, rotation: 0),
    Tile(type: TileType.Royalty, name: "Château", icon: FontAwesomeIcons.fortAwesome, rotation: 0),
  ];

  final List<Tile> allGrayTiles = [
    Tile(type: TileType.Neutral, name: "Citoyen", icon: FontAwesomeIcons.user, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Sorcière", icon: FontAwesomeIcons.hatWizard, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Chaman", icon: FontAwesomeIcons.feather, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Assassin", icon: FontAwesomeIcons.skullCrossbones, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Pirate", icon: FontAwesomeIcons.anchor, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Faucheuse", icon: FontAwesomeIcons.skull, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Marchand", icon: FontAwesomeIcons.bagShopping, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Mendiant", icon: FontAwesomeIcons.handshakeAngle, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Hérétique", icon: FontAwesomeIcons.bolt, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Espion", icon: FontAwesomeIcons.userSecret, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Traître", icon: FontAwesomeIcons.userSlash, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Garde", icon: FontAwesomeIcons.shieldDog, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Tour", icon: FontAwesomeIcons.towerObservation, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Bibliothécaire", icon: FontAwesomeIcons.bookOpen, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Alchimiste", icon: FontAwesomeIcons.flask, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Prophète", icon: FontAwesomeIcons.eye, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Sage", icon: FontAwesomeIcons.userGraduate, rotation: 3 * pi / 2),
    Tile(type: TileType.Neutral, name: "Oracle", icon: FontAwesomeIcons.circle, rotation: 3 * pi / 2),
  ];
}
