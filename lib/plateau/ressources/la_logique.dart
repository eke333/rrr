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
        promptDestroyOneAdjacentTile(row, col, context, isPlayerOne); // Ajout du paramètre manquant
        break;
      case "Reine":
      case "Cardinal":
        rotateTilesInDirection(row, col);
        break;
      case "Princesse":
      case "Saint":
        promptRotationChoice(row, col, context);
        break;
      case "Assassin":
      case "Sorcière":
        destroyAdjacentTile(row, col);
        break;
      case "Pirate":
        destroyShieldedTile(row, col);
        break;
      case "Faucheuse":
        if (isBoardFull()) isGameOver = true;
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
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol] != null) {
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
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3 && board[newRow][newCol] != null) {
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



  void destroyAdjacentTile(int row, int col) {
    List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3) {
        board[newRow][newCol] = null;
      }
    }
  }

  void destroyShieldedTile(int row, int col) {
    List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3) {
        Tile? tile = board[newRow][newCol];
        if (tile != null && tile.name != "Tour") {
          board[newRow][newCol] = null;
        }
      }
    }
  }
}
