import 'dart:math';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/rrr_colors.dart';
import 'tile.dart';
import 'les_tuiles.dart';

class LaLogique {
  List<List<Tile?>> board = List.generate(3, (_) => List.filled(3, null));
  bool isGameOver = false;
  bool showWinnerAnimation = false;
  late List<Tile> selectedGrayTiles;
  TileType currentPlayer = TileType.Royalty;
  List<Tile> availableBlueTiles = [];
  List<Tile> availableRedTiles = [];
  bool firstMoveDone = false;
  bool isCitizenPlaced = false;
  List<Tile> discardedTiles = [];

  final VoidCallback onStateChange;

  LaLogique({required this.onStateChange}) {
    resetGame();
  }

  List<Tile> selectRandomGrayTiles() {
    final random = Random();
    List<Tile> allGrayTiles = List.from(LesTuiles().allGrayTiles);
    Tile citizenTile = allGrayTiles.firstWhere((tile) => tile.name == "Citoyen");
    allGrayTiles.remove(citizenTile);
    allGrayTiles.shuffle(random);
    List<Tile> randomGrayTiles = allGrayTiles.take(4).toList();
    randomGrayTiles.add(citizenTile);
    return randomGrayTiles;
  }

  void checkWinner() {
    int royaltyCount = board.expand((row) => row).where((tile) => tile?.type == TileType.Royalty).length;
    int religionCount = board.expand((row) => row).where((tile) => tile?.type == TileType.Religion).length;
    isGameOver = true;
    print(royaltyCount > religionCount ? "Royauté gagne !" : "Religion gagne !");
    showWinnerAnimation = true;
    onStateChange();
    Future.delayed(Duration(seconds: 12), () {
      resetGame();
      showWinnerAnimation = false;
      onStateChange();
    });
  }

  void resetGame() {
    board = List.generate(3, (_) => List.filled(3, null));
    selectedGrayTiles = selectRandomGrayTiles();
    availableBlueTiles = List.from(LesTuiles().blueTiles);
    availableRedTiles = List.from(LesTuiles().redTiles);
    currentPlayer = Random().nextBool() ? TileType.Religion : TileType.Royalty;
    firstMoveDone = false;
    isCitizenPlaced = false;
    isGameOver = false;
    onStateChange();
  }

  void onTileDropped(int row, int col, Tile tile, BuildContext context) {
    if (isGameOver || board[row][col] != null || !isValidMove(tile)) return;
    if (!firstMoveDone && tile.name != "Citoyen") return;

    board[row][col] = tile;
    removeTileFromAvailableList(tile);
    applyTileEffect(row, col, tile, context, currentPlayer != TileType.Royalty); // Passe context ici aussi
    firstMoveDone = true;

    if (isBoardFull()) {
      checkWinner();
    } else {
      switchPlayer();
    }
    onStateChange();
  }

  bool isValidMove(Tile tile) {
    return tile.type == currentPlayer || tile.type == TileType.Neutral;
  }

  void removeTileFromAvailableList(Tile tile) {
    if (tile.type == TileType.Royalty) {
      availableRedTiles.remove(tile);
    } else if (tile.type == TileType.Religion) {
      availableBlueTiles.remove(tile);
    } else {
      selectedGrayTiles.remove(tile);
    }
  }

  Color getTileColor(TileType type) {
    return {
      TileType.Royalty: Colors.red,
      TileType.Religion: RrrColors.rrr_home_icon,
      TileType.Neutral: Colors.grey,
    }[type]!;
  }

  void applyTileEffect(int row, int col, Tile tile, BuildContext context, bool isPlayerOne) {
    switch (tile.name) {
      case "Roi":
      case "Hiérophante":
        promptDestroyOneAdjacentTile(row, col, context, isPlayerOne);
        break;
      case "Reine":
      case "Cardinal":
        rotateTilesInDirection(row, col);
        break;
      case "Princesse":
      case "Saint":
        promptRotationChoice(row, col, context);
        break;
      case "Ministre":
      case "Évêque":
        promptSingleTileRotation(row, col, context);
        break;
      case "Général":
      case "Paladin":
        promptDestroyOrthogonalTile(row, col, context);
        break;
      case "Sorcier":
      case "Moine":
        promptDestroyDiagonalTile(row, col, context);
        break;
      case "Château":
      case "Temple":
        return;
      case "Aventurier":
        moveNeutralTileToPlayerZone();
        break;
      case "Assassin":
        banishOpponentTile(context); // Fais le contraire de ce qu'on lui demainde (la tuile doit être dans zone de jeu de l'adversaire et non sur la grille
        break;
      case "Fée":
        moveRoyaltyTile(context); // Le déplacement n'est pas bien effectué, il fait disparaître la tuile sélection au lieu de le déplacer ailleurs.
        break;
      case "Voyante":
        rotateThreeAdjacentTiles(row, col); // Okay
        break;
      case "Chaman":
        cancelInstantEffects(row, col);
        break;
      case "Samuraï":
        promptBanishOrthogonalTile(row, col, context);
        break;
      case "Barde":
        reactivateInstantEffect(row, col);
        break;
      case "Sage":
        grantShieldToAdjacent(row, col);
        break;
      case "Ermite":
        retrieveDiscardedTile();
        break;
      case "Pirate":
        destroyShieldedTile(row, col, context);
        break;
      case "Faucheuse":
        checkFaucheuseEndGame();
        break;
      case "Dragon":
        rotateAdjacentTiles(row, col, orthogonal: true);
        break;
      case "Sorcière":
        //cancelDiagonalInstantEffects(row, col);
        break;
      case "Ninja":
        banishDiagonalTile(row, col, context);
        break;
      case "Artiste":
        //reactivateDiagonalInstantEffect(row, col);
        break;
      case "Tour":
        coverAllyWithTower(row, col);
        break;
      case "Magicienne":
        retrieveAllyTile(row, col);
        break;
    }
  }



  bool isBoardFull() {
    return board.every((row) => row.every((tile) => tile != null));
  }

  void switchPlayer() {
    currentPlayer = currentPlayer == TileType.Royalty ? TileType.Religion : TileType.Royalty;
    if (isCitizenPlaced) {
      firstMoveDone = true;
    }
    onStateChange();
  }

  void promptRotationChoice(int row, int col, BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(
            top: currentPlayer == TileType.Religion ? MediaQuery.of(context).size.height * 0.75 : 0.0,
            bottom: currentPlayer == TileType.Royalty ? MediaQuery.of(context).size.height * 0.65 : 0.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Choisissez le type de pivot", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    rotateAdjacentTiles(row, col, orthogonal: true);
                  },
                  child: Text("Pivoter orthogonalement"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    rotateAdjacentTiles(row, col, orthogonal: false);
                  },
                  child: Text("Pivoter diagonalement"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void rotateAdjacentTiles(int row, int col, {required bool orthogonal}) {
    List<List<int>> directions = orthogonal
        ? [
      [-1, 0], [1, 0], [0, -1], [0, 1]
    ]
        : [
      [-1, -1], [-1, 1], [1, -1], [1, 1]
    ];

    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol] != null&& board[newRow][newCol]!.isImmune == false) {
        Tile tile = board[newRow][newCol]!;
        board[newRow][newCol] = Tile(
          name: tile.name,
          type: tile.type == TileType.Royalty ? TileType.Religion : TileType.Royalty,
          icon: tile.icon,
          rotation: pi,
        );
      }
    }
    onStateChange();
  }

  void rotateTilesAround(int row, int col) {
    List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3&& board[newRow][newCol]!.isImmune == false) {
        Tile? tile = board[newRow][newCol];
        if (tile != null) {
          board[newRow][newCol] = Tile(
            name: tile.name,
            type: tile.type == TileType.Royalty ? TileType.Religion : TileType.Royalty,
            icon: tile.icon,
            rotation: pi,
          );
        }
      }
    }
  }

  void rotateTilesInDirection(int row, int col) {
    List<List<int>> directions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1],         [0, 1],
      [1, -1], [1, 0], [1, 1]
    ];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3) {
        Tile? tile = board[newRow][newCol];
        if (tile != null) {
          board[newRow][newCol] = Tile(
            name: tile.name,
            type: tile.type == TileType.Royalty ? TileType.Religion : TileType.Royalty,
            icon: tile.icon,
            rotation: pi,
          );
        }
      }
    }
  }

  void promptDestroyOneAdjacentTile(int row, int col, BuildContext context, bool isPlayerOne) {
    List<List<int>> directions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1],         [0, 1],
      [1, -1], [1, 0], [1, 1]
    ];

    List<Point<int>> positions = [];
    List<Tile> tiles = [];

    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol] != null && board[newRow][newCol]!.isImmune == false) {
        positions.add(Point(newRow, newCol));
        tiles.add(board[newRow][newCol]!);
      }
    }

    if (positions.isNotEmpty) {
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return Align(
            alignment: isPlayerOne ? Alignment.topCenter : Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                margin: EdgeInsets.only(top: isPlayerOne ? Constants.screenWidth(context) * 0.165 : 0, bottom: isPlayerOne ? 0 : Constants.screenWidth(context) * 0.05),
                padding: EdgeInsets.all(Constants.screenWidth(context) * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Choisissez une tuile à détruire", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: Constants.screenHeight(context) * 0.008),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(tiles.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              board[positions[index].x][positions[index].y] = null;
                              Navigator.of(context).pop();
                              onStateChange();
                            },
                            child: Container(
                              width: Constants.screenWidth(context) * 0.20,
                              height: Constants.screenWidth(context) * 0.15,
                              margin: EdgeInsets.symmetric(horizontal: Constants.screenWidth(context) * 0.165),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Icon(tiles[index].icon, size: Constants.screenWidth(context) * 0.05, color: getTileColor(tiles[index].type)),
                                  SizedBox(height: Constants.screenHeight(context) * 0.005),
                                  Text(tiles[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: Constants.screenWidth(context) * 0.026)),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: Constants.screenHeight(context) * 0.009),
                    Text("Faites défiler pour voir toutes les tuiles", style: TextStyle(fontSize: Constants.screenWidth(context) * 0.026, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void promptSingleTileRotation(int row, int col, BuildContext context) {
    List<List<int>> directions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1],         [0, 1],
      [1, -1], [1, 0], [1, 1]
    ];

    List<Point<int>> positions = [];
    List<Tile> tiles = [];

    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol] != null && board[newRow][newCol]!.isImmune == false) {
        positions.add(Point(newRow, newCol));
        tiles.add(board[newRow][newCol]!);
      }
    }

    if (positions.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choisissez une tuile à pivoter"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(tiles.length, (index) {
                return ElevatedButton(
                  onPressed: () {
                    rotateSingleTile(positions[index].x, positions[index].y);
                    Navigator.of(context).pop();
                  },
                  child: Text(tiles[index].name),
                );
              }),
            ),
          );
        },
      );
    }
  }

  void rotateSingleTile(int row, int col) {
    if (board[row][col] != null) {
      Tile tile = board[row][col]!;
      board[row][col] = Tile(
        name: tile.name,
        type: tile.type == TileType.Royalty ? TileType.Religion : TileType.Royalty,
        icon: tile.icon,
        rotation: pi,
      );
    }
    onStateChange();
  }

  void promptDestroyOrthogonalTile(int row, int col, BuildContext context) {
    List<List<int>> directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1]
    ];

    List<Point<int>> positions = [];
    List<Tile> tiles = [];

    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol] != null && board[newRow][newCol]!.isImmune == false) {
        positions.add(Point(newRow, newCol));
        tiles.add(board[newRow][newCol]!);
      }
    }

    if (positions.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choisissez une tuile à détruire"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(tiles.length, (index) {
                return ElevatedButton(
                  onPressed: () {
                    board[positions[index].x][positions[index].y] = null;
                    Navigator.of(context).pop();
                    onStateChange();
                  },
                  child: Text(tiles[index].name),
                );
              }),
            ),
          );
        },
      );
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


  void promptDestroyDiagonalTile(int row, int col, BuildContext context) {
    List<List<int>> directions = [
      [-1, -1], [-1, 1], [1, -1], [1, 1]
    ];
    destroyTileFromDirections(row, col, directions, context);
  }

  void promptBanishOrthogonalTile(int row, int col, BuildContext context) {
    List<List<int>> directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1]
    ];
    destroyTileFromDirections(row, col, directions, context);
  }

  void destroyTileFromDirections(int row, int col, List<List<int>> directions, BuildContext context) {
    List<Point<int>> positions = [];
    List<Tile> tiles = [];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol] != null && board[newRow][newCol]!.isImmune == false) {
        positions.add(Point(newRow, newCol));
        tiles.add(board[newRow][newCol]!);
      }
    }
    if (positions.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choisissez une tuile à affecter"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(tiles.length, (index) {
                return ElevatedButton(
                  onPressed: () {
                    board[positions[index].x][positions[index].y] = null;
                    Navigator.of(context).pop();
                    onStateChange();
                  },
                  child: Text(tiles[index].name),
                );
              }),
            ),
          );
        },
      );
    }
  }

  void moveNeutralTileToPlayerZone() {
    if (selectedGrayTiles.isNotEmpty) {
      Tile tile = selectedGrayTiles.removeLast();
      if (currentPlayer == TileType.Royalty) {
        availableRedTiles.add(tile);
      } else {
        availableBlueTiles.add(tile);
      }
      onStateChange();
    }
  }

  void cancelInstantEffects(int row, int col) {
    List<List<int>> directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1]
    ];

    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];

      if (newRow >= 0 && newRow < board.length && newCol >= 0 && newCol < board[0].length && board[newRow][newCol] != null) {
        board[newRow][newCol]!.effectIsActivated = false; // Désactiver l'effet
      }
    }

    onStateChange(); // Mettre à jour l'interface
  }



  void reactivateInstantEffect(int row, int col) {
    List<List<int>> directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1]
    ];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol] != null) {
        applyTileEffect(newRow, newCol, board[newRow][newCol]!, BuildContext as BuildContext, currentPlayer == TileType.Religion);
      }
    }
    onStateChange();
  }

  void grantShieldToAdjacent(int row, int col) {
    List<List<int>> directions = [
      [0, -1], [0, 1]
    ];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol] != null) {
        board[newRow][newCol]!.isImmune = true;
      }
    }
    onStateChange();
  }

  void banishOpponentTile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choisissez une tuile à bannir"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(board.length, (row) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(board[row].length, (col) {
                  Tile? tile = board[row][col];
                  if (tile != null && tile.type != currentPlayer) {
                    return ElevatedButton(
                      onPressed: () {
                        board[row][col] = Tile(
                          name: "Banni",
                          type: tile.type,
                          icon: Icons.close,
                          rotation: tile.rotation,
                        );
                        onStateChange();
                        Future.delayed(Duration(seconds: 1), () {
                          board[row][col] = null;
                          onStateChange();
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(tile.name),
                    );
                  }
                  return SizedBox.shrink();
                }),
              );
            }),
          ),
        );
      },
    );
  }

  void moveRoyaltyTile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choisissez une tuile à déplacer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(board.length, (row) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(board[row].length, (col) {
                  Tile? tile = board[row][col];
                  if (tile != null && tile.type == TileType.Royalty) {
                    return ElevatedButton(
                      onPressed: () {
                        board[row][col] = null;
                        onStateChange();
                        Navigator.of(context).pop();
                      },
                      child: Text(tile.name),
                    );
                  }
                  return SizedBox.shrink();
                }),
              );
            }),
          ),
        );
      },
    );
  }

  void rotateThreeAdjacentTiles(int row, int col) {
    List<List<int>> directions = [
      [-1, 0],  // Tuile au-dessus (orthogonale)
      [-1, -1], // Tuile en haut à gauche (diagonale)
      [-1, 1]   // Tuile en haut à droite (diagonale)
    ];

    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];

      if (newRow >= 0 && newRow < board.length && newCol >= 0 && newCol < board[0].length && board[newRow][newCol] != null) {
        board[newRow][newCol] = Tile(
          name: board[newRow][newCol]!.name,
          type: board[newRow][newCol]?.type == TileType.Royalty ? TileType.Religion : TileType.Royalty,
          icon: board[newRow][newCol]!.icon,
          rotation: (board[newRow][newCol]!.rotation + pi) % (2 * pi),
        );
      }
    }

    onStateChange();
  }

  void retrieveDiscardedTile() {
    if (discardedTiles.isNotEmpty) {
      Tile tile = discardedTiles.removeLast();
      if (currentPlayer == TileType.Royalty) {
        availableRedTiles.add(tile);
      } else {
        availableBlueTiles.add(tile);
      }
      onStateChange();
    }
  }


  //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void destroyShieldedTile(int row, int col, BuildContext context) {
    List<List<int>> directions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1],         [0, 1],
      [1, -1], [1, 0], [1, 1]
    ];
    destroyTileFromDirections(row, col, directions, context);
  }

  void checkFaucheuseEndGame() {
    if (availableBlueTiles.contains(Tile(name: "Faucheuse", type: TileType.Neutral, icon: Icons.hourglass_empty, rotation: 0)) ||
        availableRedTiles.contains(Tile(name: "Faucheuse", type: TileType.Neutral, icon: Icons.hourglass_empty, rotation: 0))) {
      isGameOver = true;
    }
  }

  // void cancelDiagonalInstantEffects(int row, int col) {
  //   List<List<int>> directions = [
  //     [-1, -1], [-1, 1],
  //     [1, -1], [1, 1]
  //   ];
  //   cancelInstantEffectsFromDirections(row, col, directions);
  // }

  void banishDiagonalTile(int row, int col, BuildContext context) {
    List<List<int>> directions = [
      [-1, -1], [-1, 1],
      [1, -1], [1, 1]
    ];
    destroyTileFromDirections(row, col, directions, context);
  }

  // void reactivateDiagonalInstantEffect(int row, int col) {
  //   List<List<int>> directions = [
  //     [-1, -1], [-1, 1],
  //     [1, -1], [1, 1]
  //   ];
  //   reactivateInstantEffectFromDirections(row, col, directions);
  // }

  void coverAllyWithTower(int row, int col) {
    if (board[row][col] != null) {
      board[row][col]!.isImmune = true;
    }
    onStateChange();
  }

  void retrieveAllyTile(int row, int col) {
    if (board[row][col] != null && board[row][col]!.type != currentPlayer) {
      if (currentPlayer == TileType.Royalty) {
        availableRedTiles.add(board[row][col]!);
      } else {
        availableBlueTiles.add(board[row][col]!);
      }
      board[row][col] = null;
      onStateChange();
    }
  }

  //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


  void destroyAdjacentTile(int row, int col) {
    List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol]!.isImmune == false) {
        board[newRow][newCol] = null;
      }
    }
  }
}
