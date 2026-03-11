import 'package:flutter/material.dart';

class GameDescriptionScreen extends StatelessWidget {
  const GameDescriptionScreen({super.key});

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number.",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialPoint(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star, color: Colors.orange, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spielbeschreibung"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Schätzen",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              _buildStep(1,
                  "Bevor die Karten an die Spieler verteilt werden, muss eine Farbe als Trumpf festgelegt werden."),
              _buildStep(2,
                  "Danach werden die Karten an die Spieler verteilt. Die Anzahl der Karten ist der App zu entnehmen."),
              _buildStep(3,
                  "Nachdem jeder Spieler die Karten erhalten hat, schätzt er, wie viele Stiche er gewinnen wird. Alle Spieler schätzen gleichzeitig, z. B. durch Handzeichen."),
              _buildStep(4,
                  "Nachdem die Schätzungen eingetragen wurden, beginnt das Spiel. Die Person mit der niedrigsten Punktzahl beginnt."),
              _buildStep(5, "Nacheinander werden die Karten ausgespielt."),
              _buildStep(6,
                  "Die Farbe der ersten gespielten Karte gewinnt, sofern kein Trumpf gespielt wird. Wenn ein Spieler diese Farbe hat, muss er sie bedienen. Andernfalls kann eine andere Farbe gespielt werden."),
              _buildStep(7,
                  "Den Stich gewinnt die Person, die die höchste Karte in der ausliegenden Farbe spielt. Trumpfkarten übertrumpfen unabhängig von der Zahl alle anderen Karten."),
              const SizedBox(height: 20),
              const Text(
                "Zwei Besonderheiten:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              _buildSpecialPoint(
                "Trumpf gewinnt immer. Wer die Farbe des Stichs nicht bedienen kann, darf eine andere Farbe spielen. Trumpfkarten schlagen unabhängig von der Höhe aller anderen Karten. Sind mehrere Trumpfkarten im Stich, gewinnt die höhere Zahl.",
              ),
              _buildSpecialPoint(
                "Wenn nur eine Karte im Einsatz ist, werden die Karten so verteilt, dass jeder Spieler nur die Karten der Mitspieler sieht, nicht jedoch die eigenen. Jeder Spieler schätzt, ob er den Stich gewinnt, anhand der sichtbaren Karten. Wenn niemand Trumpf hat, gilt die Farbe des Spiels mit der niedrigsten Punktzahl. Das Spiel wird dann nach Festlegung des Trumpfs fortgesetzt.",
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Viel Spaß beim Spielen!",
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}