import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tile.dart';

class LesTuiles {

  //Les tuiles de la Réligion
  final List<Tile> blueTiles = [
    Tile(type: TileType.Religion, name: "Hiérophante", icon: FontAwesomeIcons.cross, rotation: pi, isImmune: false),
    Tile(type: TileType.Religion, name: "Cardinal", icon: FontAwesomeIcons.church, rotation: pi, isImmune: false),
    Tile(type: TileType.Religion, name: "Saint", icon: FontAwesomeIcons.personPraying, rotation: pi, isImmune: false),
    Tile(type: TileType.Religion, name: "Évêque", icon: FontAwesomeIcons.hatCowboy, rotation: pi, isImmune: false),
    Tile(type: TileType.Religion, name: "Paladin", icon: FontAwesomeIcons.handsPraying, rotation: pi, isImmune: false),
    Tile(type: TileType.Religion, name: "Moine", icon: FontAwesomeIcons.bookBible, rotation: pi, isImmune: false),
    Tile(type: TileType.Religion, name: "Temple", icon: FontAwesomeIcons.kaaba, rotation: pi, isImmune: true),
  ];

  //Les tuiles de la royauté
  final List<Tile> redTiles = [
    Tile(type: TileType.Royalty, name: "Roi", icon: FontAwesomeIcons.crown, rotation: 0, isImmune: false),
    Tile(type: TileType.Royalty, name: "Reine", icon: FontAwesomeIcons.chessQueen, rotation: 0, isImmune: false),
    Tile(type: TileType.Royalty, name: "Princesse", icon: FontAwesomeIcons.solidStarHalfStroke, rotation: 0, isImmune: false),
    Tile(type: TileType.Royalty, name: "Ministre", icon: FontAwesomeIcons.solidStar, rotation: 0, isImmune: false),
    Tile(type: TileType.Royalty, name: "Général", icon: FontAwesomeIcons.shieldHalved, rotation: 0, isImmune: false),
    Tile(type: TileType.Royalty, name: "Sorcier", icon: FontAwesomeIcons.chessKnight, rotation: 0, isImmune: false),
    Tile(type: TileType.Royalty, name: "Château", icon: FontAwesomeIcons.fortAwesome, rotation: 0, isImmune: true),
  ];


  //Les tuiles neutres
  final List<Tile> allGrayTiles = [
    Tile(type: TileType.Neutral, name: "Citoyen", icon: FontAwesomeIcons.user, rotation: 3 * pi / 2, isImmune: false),
    Tile(type: TileType.Neutral, name: "Aventurier", icon: FontAwesomeIcons.hatWizard, rotation: 3 * pi / 2, isImmune: false),
    Tile(type: TileType.Neutral, name: "Assassin", icon: FontAwesomeIcons.skullCrossbones, rotation: 3 * pi / 2, isImmune: false),
    //Tile(type: TileType.Neutral, name: "Pirate", icon: FontAwesomeIcons.anchor, rotation: 3 * pi / 2, isImmune: false),
    //Tile(type: TileType.Neutral, name: "Fée", icon: FontAwesomeIcons.feather, rotation: 3 * pi / 2, isImmune: false),
    Tile(type: TileType.Neutral, name: "Faucheuse", icon: FontAwesomeIcons.skull, rotation: 3 * pi / 2, isImmune: false),
    //Tile(type: TileType.Neutral, name: "Voyante", icon: FontAwesomeIcons.eye, rotation: 3 * pi / 2, isImmune: false),
    Tile(type: TileType.Neutral, name: "Dragon", icon: FontAwesomeIcons.userSecret, rotation: 3 * pi / 2, isImmune: false),
    //Tile(type: TileType.Neutral, name: "Chaman", icon: FontAwesomeIcons.flask, rotation: 3 * pi / 2, isImmune: false),
    //Tile(type: TileType.Neutral, name: "Sorcière", icon: FontAwesomeIcons.userSlash, rotation: 3 * pi / 2, isImmune: false),
    Tile(type: TileType.Neutral, name: "Samuraï", icon: FontAwesomeIcons.bagShopping, rotation: 3 * pi / 2, isImmune: false),
    Tile(type: TileType.Neutral, name: "Ninja", icon: FontAwesomeIcons.shieldDog, rotation: 3 * pi / 2, isImmune: false),
    //Tile(type: TileType.Neutral, name: "Barde", icon: FontAwesomeIcons.handshakeAngle, rotation: 3 * pi / 2, isImmune: false),
    //Tile(type: TileType.Neutral, name: "Artiste", icon: FontAwesomeIcons.bookOpen, rotation: 3 * pi / 2, isImmune: false),
    Tile(type: TileType.Neutral, name: "Sage", icon: FontAwesomeIcons.userGraduate, rotation: 3 * pi / 2, isImmune: false),
    Tile(type: TileType.Neutral, name: "Tour", icon: FontAwesomeIcons.towerObservation, rotation: 3 * pi / 2, isImmune: false),
    //Tile(type: TileType.Neutral, name: "Ermite", icon: FontAwesomeIcons.bolt, rotation: 3 * pi / 2, isImmune: false),
    //Tile(type: TileType.Neutral, name: "Magicienne", icon: FontAwesomeIcons.circle, rotation: 3 * pi / 2, isImmune: false),
  ];
}
