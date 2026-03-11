import 'package:flutter/material.dart';
import 'player.dart';
import 'line_chart.dart';

class ScoreboardScreen extends StatelessWidget {
  final List<Player> players;
  const ScoreboardScreen({super.key, required this.players});

  static const List<Color> playerColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.pink,
  ];

  List<List<int>> getCumulativeScores() {
    return players.map((p) {
      List<int> cum = [];
      int sum = 0;
      for (var s in p.scoreHistory) {
        sum += s;
        cum.add(sum);
      }
      return cum;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Player> sorted = List.from(players);
    sorted.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    List<int> ranks = List.filled(sorted.length, 1);
    for (int i = 1; i < sorted.length; i++) {
      ranks[i] = (sorted[i].totalScore == sorted[i - 1].totalScore) ? ranks[i - 1] : i + 1;
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text("Rangliste", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, index) {
                Player p = sorted[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: playerColors[index % playerColors.length],
                      child: Text('${ranks[index]}',
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(p.name),
                    subtitle: LinearProgressIndicator(
                      value: ((p.totalScore > 0 ? p.totalScore / 100 : 0).clamp(0, 1)).toDouble(),
                      color: playerColors[index % playerColors.length],
                      backgroundColor: Colors.grey.shade200,
                    ),
                    trailing: Text("${p.totalScore} Punkte"),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const Text("Spielverlauf", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: LineChart(
              allScores: getCumulativeScores(),
              colors: playerColors,
            ),
          ),
        ],
      ),
    );
  }
}