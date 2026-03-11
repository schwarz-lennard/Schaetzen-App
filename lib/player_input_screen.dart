import 'package:flutter/material.dart';
import 'game_controller.dart';

class PlayerInputScreen extends StatefulWidget {
  final GameController controller;
  final VoidCallback? onChanged;
  const PlayerInputScreen({super.key, required this.controller, this.onChanged});

  @override
  State<PlayerInputScreen> createState() => _PlayerInputScreenState();
}

class _PlayerInputScreenState extends State<PlayerInputScreen> {
  final TextEditingController _nameController = TextEditingController();

  static const List<Color> avatarColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Spielername",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text("Spieler hinzufügen"),
            onPressed: () {
              String name = _nameController.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  widget.controller.addPlayer(name);
                  _nameController.clear();
                  widget.onChanged?.call();
                });
              }
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: widget.controller.players.length,
              itemBuilder: (context, index) {
                final player = widget.controller.players[index];
                final color = avatarColors[index % avatarColors.length];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color,
                      child: Text(player.name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(player.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          widget.controller.removePlayer(player);
                          widget.onChanged?.call();
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}