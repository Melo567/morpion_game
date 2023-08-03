import 'package:flutter/material.dart';

class MorpionPage extends StatefulWidget {
  @override
  _MorpionPageState createState() => _MorpionPageState();
}

class _MorpionPageState extends State<MorpionPage> {
  List<List<String>> grid = List.generate(3, (_) => List.filled(3, ""));
  String currentPlayer = "X";
  bool gameOver = false;

  void _onTileTap(int row, int col) {
    if (grid[row][col] == "" && !gameOver) {
      setState(() {
        grid[row][col] = currentPlayer;
        if (_checkWin(row, col)) {
          gameOver = true;
          _showDialog("Joueur $currentPlayer gagne !");
        } else if (_isBoardFull()) {
          gameOver = true;
          _showDialog("Match nul !");
        } else {
          currentPlayer = (currentPlayer == "X") ? "O" : "X";
        }
      });
    }
  }

  bool _checkWin(int row, int col) {
    if (grid[row].every((cell) => cell == currentPlayer)) {
      return true;
    }
    if (grid.every((row) => row[col] == currentPlayer)) {
      return true;
    }
    return false;
  }

  bool _isBoardFull() {
    return grid.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Résultat",
        ),
        content: Text(
          message,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _resetGame();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Rejouer",
            ),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      grid = List.generate(3, (_) => List.filled(3, ""));
      currentPlayer = "X";
      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Morpion Game',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tour du joueur : $currentPlayer',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                int row = index ~/ 3;
                int col = index % 3;
                return Case(
                  value: grid[row][col],
                  onSelectCase: () => _onTileTap(row, col),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Case extends StatelessWidget {
  const Case({
    super.key,
    required this.value,
    required this.onSelectCase,
  });

  final String value;
  final VoidCallback onSelectCase;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectCase,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
