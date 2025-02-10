import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rrr/constants/rrr_colors.dart';
import 'dart:math';
import 'package:rrr/plateau/ressources/les_tuiles.dart';
import 'package:rrr/plateau/widgets/tuile.dart';

class PlateauBody extends StatefulWidget {
  const PlateauBody({super.key});

  @override
  State<PlateauBody> createState() => _PlateauBodyState();
}

class _PlateauBodyState extends State<PlateauBody> {
  List<List<Tile?>> board = List.generate(3, (_) => List.filled(3, null));
  late List<Tile> selectedGrayTiles;
  TileType currentPlayer = TileType.Royalty;
  bool isGameOver = false;
  List<Tile> availableBlueTiles = [];
  List<Tile> availableRedTiles = [];
  bool firstMoveDone = false;
  bool isCitizenPlaced = false;
  bool showWinnerAnimation = false;

  @override
  void initState() {
    super.initState();
    selectedGrayTiles = _selectRandomGrayTiles();
    availableBlueTiles = List.from(LesTuiles().blueTiles);
    availableRedTiles = List.from(LesTuiles().redTiles);
    currentPlayer = Random().nextBool() ? TileType.Religion : TileType.Royalty;
  }

  List<Tile> _selectRandomGrayTiles() {
    final random = Random();
    List<Tile> allGrayTiles = List.from(LesTuiles().allGrayTiles);
    Tile citizenTile = allGrayTiles.firstWhere((tile) => tile.name == "Citoyen");
    allGrayTiles.remove(citizenTile);
    allGrayTiles.shuffle(random);
    List<Tile> randomGrayTiles = allGrayTiles.take(4).toList();
    randomGrayTiles.add(citizenTile);
    return randomGrayTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Affichage de l'animation Lottie si un joueur a gagné
          if (showWinnerAnimation)
          // Positionner l'animation en fonction du joueur gagnant
            currentPlayer == TileType.Religion
                ? Container(
              height: 150,
              width: 150,
              child: Lottie.asset('assets/lotties/winner.json'), // Chemin vers l'animation Lottie
            )
                : SizedBox.shrink(),

          // Affichage des tuiles bleues pour Religion
          if (currentPlayer == TileType.Religion)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Religion joue", style: TextStyle(color: RrrColors.rrr_home_icon, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Icon(Icons.church, size: 24, color: RrrColors.rrr_home_icon),
              ],
            ),
          buildScrollableRow(availableBlueTiles),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildBoard(),
              SizedBox(width: 10),
              buildScrollableColumn(selectedGrayTiles),
            ],
          ),

          SizedBox(height: 20),
          buildScrollableRow(availableRedTiles),
          SizedBox(height: 10),

          // Affichage des tuiles rouges pour Royaume
          if (currentPlayer == TileType.Royalty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Royaume joue", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Icon(Icons.diamond, size: 24, color: Colors.red),
              ],
            ),
          // Affichage de l'animation Lottie si un joueur a gagné
          if (showWinnerAnimation)
          // Positionner l'animation en fonction du joueur gagnant
            currentPlayer == TileType.Royalty
                ? Container(
              height: 150,
              width: 150,
              child: Lottie.asset('assets/lotties/winner.json'), // Chemin vers l'animation Lottie
            )
                : SizedBox.shrink(),
        ],
      ),
    );
  }


  void checkWinner() {
    int royaltyCount = board.expand((row) => row).where((tile) => tile?.type == TileType.Royalty).length;
    int religionCount = board.expand((row) => row).where((tile) => tile?.type == TileType.Religion).length;
    isGameOver = true;
    print(royaltyCount > religionCount ? "Royauté gagne !" : "Religion gagne !");
    setState(() {
      showWinnerAnimation = true;
    });
    Future.delayed(Duration(seconds: 12), () {
      setState(() {
        resetGame();
        showWinnerAnimation = false;
      });
    });
  }

  void resetGame() {
    board = List.generate(3, (_) => List.filled(3, null));
    selectedGrayTiles = _selectRandomGrayTiles();
    availableBlueTiles = List.from(LesTuiles().blueTiles);
    availableRedTiles = List.from(LesTuiles().redTiles);
    currentPlayer = Random().nextBool() ? TileType.Religion : TileType.Royalty;
    firstMoveDone = false;
    isCitizenPlaced = false;
    isGameOver = false;
  }

  Widget buildBoard() {
    return Column(
      children: List.generate(3, (row) {
        return Row(
          children: List.generate(3, (col) {
            return DragTarget<Tile>(
              onAccept: (tile) => onTileDropped(row, col, tile),
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(4.0),
                  color: board[row][col] != null ? Colors.white : Colors.grey[300],
                  child: Center(
                    child: board[row][col] != null
                        ? buildTile(board[row][col]!, isOnBoard: true)
                        : Container(),
                  ),
                );
              },
            );
          }),
        );
      }),
    );
  }

  Widget buildScrollableRow(List<Tile> tiles) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tiles.map((tile) => buildDraggableTile(tile)).toList(),
        ),
      ),
    );
  }

  Widget buildScrollableColumn(List<Tile> tiles) {
    return SizedBox(
      width: 80,
      height: 300,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: tiles.map((tile) => buildDraggableTile(tile)).toList(),
        ),
      ),
    );
  }

  Widget buildDraggableTile(Tile tile) {
    return Draggable<Tile>(
      data: tile,
      feedback: buildTile(tile, isDragging: true),
      childWhenDragging: Opacity(opacity: 0.5, child: buildTile(tile)),
      child: buildTile(tile),
    );
  }

  Widget buildTile(Tile tile, {bool isOnBoard = false, bool isDragging = false}) {
    return Container(
      margin: EdgeInsets.all(4),
      width: isDragging ? 70 : 60,
      height: isDragging ? 70 : 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isOnBoard ? Colors.black : Colors.blue,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(tile.icon, size: 24, color: _getTileColor(tile.type)),
          SizedBox(height: 4),
          Text(tile.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Color _getTileColor(TileType type) {
    return {
      TileType.Royalty: Colors.red,
      TileType.Religion: RrrColors.rrr_home_icon,
      TileType.Neutral: Colors.grey,
    }[type]!;
  }

  void onTileDropped(int row, int col, Tile tile) {
    // Vérification si le jeu est terminé ou si la case est déjà occupée
    if (isGameOver || board[row][col] != null) return;

    // Vérification si c'est le bon joueur qui joue et si la tuile est valide
    if (!isValidMove(tile)) {
      // Si ce n'est pas le tour du joueur actuel, la tuile retourne à sa position d'origine
      return;
    }

    if (!firstMoveDone && tile.name != "Citoyen") return;

    setState(() {
      board[row][col] = tile;
      removeTileFromAvailableList(tile);
      applyTileEffect(row, col, tile);
      firstMoveDone = true;
      if (isBoardFull()) {
        checkWinner();
      } else {
        switchPlayer();
      }
    });
  }

  bool isValidMove(Tile tile) {
    // Un joueur peut déplacer ses propres tuiles ou les tuiles neutres
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
    // If the first move is done, alternate players on each turn
    currentPlayer = currentPlayer == TileType.Royalty ? TileType.Religion : TileType.Royalty;
    // If "Citoyen" has been placed, disable further moves for that turn
    if (isCitizenPlaced) {
      firstMoveDone = true; // Lock the ability to play "Citoyen"
    }
  }

  void rotateTilesAround(int row, int col) {
    List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3) {
        Tile? tile = board[newRow][newCol];
        if (tile != null) {
          setState(() {
            board[newRow][newCol] = Tile(
              name: tile.name,
              type: tile.type == TileType.Royalty ? TileType.Religion : TileType.Royalty,
              icon: tile.icon,
              rotation: pi,
            );
          });
        }
      }
    }
  }

  void destroyAdjacentTile(int row, int col) {
    List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    for (var dir in directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < 3 && newCol >= 0 && newCol < 3) {
        if (board[newRow][newCol] != null) {
          setState(() {
            board[newRow][newCol] = null;
          });
        }
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
        if (tile != null && tile.name != "Tour") { // Tour est immunisée
          setState(() {
            board[newRow][newCol] = null;
          });
        }
      }
    }
  }
}