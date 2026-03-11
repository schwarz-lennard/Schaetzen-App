import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_controller.dart';

class RoundInputScreen extends StatefulWidget {
  final GameController controller;
  final VoidCallback? onRoundFinished;
  const RoundInputScreen({super.key, required this.controller, this.onRoundFinished});

  @override
  State<RoundInputScreen> createState() => _RoundInputScreenState();
}

class _RoundInputScreenState extends State<RoundInputScreen> {
  final Map<String, TextEditingController> estimatedControllers = {};
  final Map<String, TextEditingController> receivedControllers = {};

  @override
  void initState() {
    super.initState();
    for (var p in widget.controller.players) {
      estimatedControllers[p.name] = TextEditingController();
      receivedControllers[p.name] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var c in estimatedControllers.values) {
      c.dispose();
    }
    for (var c in receivedControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool _isNumeric(String s) => RegExp(r'^\d+$').hasMatch(s);

  void _confirmRound(List<int> est, List<int> rec) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning, color: Colors.red, size: 36),
        title: const Text("Runde abschließen?"),
        content: const Text(
            "Die Werte können nach dem Abschließen nicht mehr geändert werden."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Abbrechen")),
          FilledButton(
            onPressed: () {
              setState(() {
                widget.controller.addRoundScores(est, rec);
                widget.onRoundFinished?.call();
                for (var c in estimatedControllers.values) {
                  c.clear();
                }
                for (var c in receivedControllers.values) {
                  c.clear();
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text("Bestätigen"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.gameFinished) {
      return const Center(
        child: Text("Das Spiel ist beendet.",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text("Runde ${widget.controller.currentRound + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.blue.shade100,
              ),
              Chip(
                label: Text("Karten: ${widget.controller.maxCards}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green.shade100,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: widget.controller.players.map((p) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(p.name, style: const TextStyle(fontSize: 16))),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: estimatedControllers[p.name],
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              labelText: "Schätzung",
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: receivedControllers[p.name],
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              labelText: "Bekommen",
                              filled: true,
                              fillColor: Colors.green.shade50,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          FilledButton(
            onPressed: () {
              List<int> est = [];
              List<int> rec = [];

              for (var p in widget.controller.players) {
                String estText = estimatedControllers[p.name]!.text;
                String recText = receivedControllers[p.name]!.text;

                if (!_isNumeric(estText)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ungültige Eingabe bei ${p.name} (Schätzung). Nur Zahlen erlaubt."),
                        backgroundColor: Colors.red),
                  );
                  return;
                }
                if (!_isNumeric(recText)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ungültige Eingabe bei ${p.name} (Bekommen). Nur Zahlen erlaubt."),
                        backgroundColor: Colors.red),
                  );
                  return;
                }

                est.add(int.parse(estText));
                rec.add(int.parse(recText));
              }

              int sumReceived = rec.reduce((a, b) => a + b);

              if (sumReceived != widget.controller.maxCards) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Fehler: Die Summe der bekommenen Stiche muss ${widget.controller.maxCards} sein."),
                      backgroundColor: Colors.red),
                );
                return;
              }

              _confirmRound(est, rec);
            },
            child: const Text("Runde abschließen"),
          )
        ],
      ),
    );
  }
}