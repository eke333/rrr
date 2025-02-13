import 'dart:math';
import 'package:flutter/material.dart';
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

  LaLogique({required this.onStateChange});

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
    onStateChange(); // Notifier le widget parent

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
    onStateChange(); // Notifier le widget parent
  }

  Color getTileColor(TileType type) {
    return {
      TileType.Royalty: Colors.red,
      TileType.Religion: RrrColors.rrr_home_icon,
      TileType.Neutral: Colors.grey,
    }[type]!;
  }

  void onTileDropped(int row, int col, Tile tile) {
    if (isGameOver || board[row][col] != null) return;
    if (!isValidMove(tile)) return;
    if (!firstMoveDone && tile.name != "Citoyen") return;

    board[row][col] = tile;
    removeTileFromAvailableList(tile);
    applyTileEffect(row, col, tile);
    firstMoveDone = true;

    if (isBoardFull()) {
      checkWinner();
    } else {
      switchPlayer();
    }

    onStateChange();
  }

  bool isValidMove(Tile tile) {
    if (currentPlayer == TileType.Royalty && tile.type != TileType.Royalty && tile.type != TileType.Neutral) {
      return false;
    } else if (currentPlayer == TileType.Religion && tile.type != TileType.Religion && tile.type != TileType.Neutral) {
      return false;
    }
    return true;
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

  void applyTileEffect(int row, int col, Tile tile) {
    switch (tile.name) {
      case "Pape":
      case "Roi":
        rotateTilesAround(row, col);
        break;
      case "Sorcière":
      case "Assassin":
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
    onStateChange();
  }

  void destroyAdjacentTile(int row, int col) {
    List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3) {
        if (board[newRow][newCol] != null) {
          board[newRow][newCol] = null;
        }
      }
    }
    onStateChange();
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
    onStateChange();
  }
}
