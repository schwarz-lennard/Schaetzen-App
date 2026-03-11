class Player {
  final String name;
  int totalScore = 0;
  List<int> scoreHistory = [];

  Player(this.name);

  void addRoundScore(int score) {
    totalScore += score;
    scoreHistory.add(score);
  }

  void reset() {
    totalScore = 0;
    scoreHistory.clear();
  }

  // JSON für Persistenz
  Map<String, dynamic> toJson() => {
        'name': name,
        'totalScore': totalScore,
        'scoreHistory': scoreHistory,
      };

  static Player fromJson(Map<String, dynamic> json) {
    Player p = Player(json['name']);
    p.totalScore = json['totalScore'] ?? 0;
    p.scoreHistory = List<int>.from(json['scoreHistory'] ?? []);
    return p;
  }
}