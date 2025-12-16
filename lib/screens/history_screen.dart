import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final history = game.history;

    return Scaffold(
      appBar: AppBar(title: const Text("Match History"), centerTitle: true),
      body: history.isEmpty
          ? const Center(
              child: Text(
                "No matches played yet",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final match = history[index];
                final DateTime time = match["time"];
                //final String result = match["result"];
                final String symbol = match["symbol"];
                final String winner = match["winner"];

                return Card(
                  child: ListTile(
                    //leading: Icon(
                    //result == "X"
                    // ? Icons.close
                    //: result == "O"
                    //? Icons.circle_outlined
                    //: Icons.handshake,
                    // ),
                    //title: Text(
                    // result == "Tie" ? "Match Tied" : "Winner: $result",
                    // ),
                    leading: Icon(
                      symbol == "X"
                          ? Icons.close
                          : symbol == "O"
                          ? Icons.circle_outlined
                          : Icons.handshake,
                    ),
                    title: Text(
                      winner == "Tie" ? "Match Tied" : "Winner: $winner",
                    ),

                    subtitle: Text(
                      "${time.day}-${time.month}-${time.year}  "
                      "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
