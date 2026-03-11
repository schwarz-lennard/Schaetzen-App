import 'player.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class GameController {
  List<Player> players = [];
  int currentRound = 0;
  int maxCards = 10;
  bool ascending = false;
  bool gameFinished = false;

  // Füge Spieler hinzu
  void addPlayer(String name) {
    players.add(Player(name));
  }

  void removePlayer(Player p) {
    players.remove(p);
  }

  void addRoundScores(List<int> estimated, List<int> received) {
    for (int i = 0; i < players.length; i++) {
      int score = 0;
      int e = estimated[i];
      int r = received[i];

      if (e == 0 && r == 0) {
        score = 5;
      } else if (e == r && e != 0) {
        score = e * 10;
      } else if (e > 0 && r == 0) {
        score = e * -10;
      } else {
        score = r;
      }

      players[i].addRoundScore(score);
    }

    currentRound++;
    _nextRound();
  }

  void _nextRound() {
    if (currentRound >= 19) {
      gameFinished = true;
      return;
    }

    if (!ascending) {
      maxCards--;
      if (maxCards <= 1) {
        ascending = true;
        maxCards = 1;
      }
    } else {
      maxCards++;
    }
  }

  void resetGame() {
    currentRound = 0;
    maxCards = 10;
    ascending = false;
    gameFinished = false;
    players.clear();
  }

  // --- Persistenz Methoden ---

  Future<void> saveGame() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'currentRound': currentRound,
      'maxCards': maxCards,
      'ascending': ascending,
      'gameFinished': gameFinished,
      'players': players.map((p) => p.toJson()).toList(),
    };
    prefs.setString('gameData', jsonEncode(data));
    debugPrint("Spielstand gespeichert");
  }

  Future<void> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('gameData');
    if (jsonString == null) return;
    final Map<String, dynamic> data = jsonDecode(jsonString);

    currentRound = data['currentRound'] ?? 0;
    maxCards = data['maxCards'] ?? 10;
    ascending = data['ascending'] ?? false;
    gameFinished = data['gameFinished'] ?? false;

    players.clear();
    if (data['players'] != null) {
      for (var p in data['players']) {
        players.add(Player.fromJson(p));
      }
    }
    debugPrint("Spielstand geladen");
  }
}