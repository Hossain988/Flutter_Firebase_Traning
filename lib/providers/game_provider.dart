import 'package:flutter/material.dart';

String player1 = "Player 1";
String player2 = "Player 2";

class GameProvider extends ChangeNotifier {
  List<String> board = List.filled(9, "");
  String currentTurn = "X";
  String winner = "";

  int xWins = 0;
  int oWins = 0;
  int ties = 0;

  // ✅ MATCH HISTORY LIST
  List<Map<String, dynamic>> history = [];

  void playMove(int index) {
    if (board[index] != "" || winner != "") return;

    board[index] = currentTurn;

    if (_checkWinner(currentTurn)) {
      winner = currentTurn;

      if (currentTurn == "X") {
        xWins++;
      } else {
        oWins++;
      }

      _saveHistory(winner);
    } else if (!board.contains("")) {
      winner = "Tie";
      ties++;
      _saveHistory("Tie");
    } else {
      currentTurn = currentTurn == "X" ? "O" : "X";
    }

    notifyListeners();
  }

  bool _checkWinner(String player) {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return true;
      }
    }
    return false;
  }

  // ✅ SAVE MATCH RESULT WITH TIME
  //void _saveHistory(String result) {
  //history.insert(0, {"result": result, "time": DateTime.now()});
  //}
  void _saveHistory(String result) {
    String winnerName;

    if (result == "X") {
      winnerName = player1;
    } else if (result == "O") {
      winnerName = player2;
    } else {
      winnerName = "Tie";
    }

    history.insert(0, {
      "symbol": result,
      "winner": winnerName,
      "time": DateTime.now(),
    });
  }

  void startNewGame() {
    board = List.filled(9, "");
    winner = "";
    notifyListeners();
  }

  void toggleStartingPlayer() {
    currentTurn = currentTurn == "X" ? "O" : "X";
    startNewGame();
  }
}
