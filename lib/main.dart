import 'package:flutter/material.dart';
import 'player_input_screen.dart';
import 'scoreboard_screen.dart';
import 'round_input_screen.dart';
import 'game_controller.dart';
import 'game_description_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schätzen LS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade700,
          primary: Colors.blue.shade700,
          secondary: Colors.orange.shade600,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GameController controller = GameController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.loadGame().then((_) => setState(() {}));
  }

  void _saveAndUpdate() {
    controller.saveGame();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = PlayerInputScreen(controller: controller, onChanged: _saveAndUpdate);
        break;
      case 1:
        body = RoundInputScreen(controller: controller, onRoundFinished: _saveAndUpdate);
        break;
      case 2:
      default:
        body = ScoreboardScreen(players: controller.players);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Schätzen LS"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: "Spielbeschreibung",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GameDescriptionScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: "Spiel zurücksetzen",
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  icon: const Icon(Icons.warning, color: Colors.red, size: 36),
                  title: const Text("Spiel zurücksetzen?"),
                  content: const Text(
                      "Alle Spieler und Punkte werden gelöscht. Dies kann nicht rückgängig gemacht werden."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Abbrechen"),
                    ),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          controller.resetGame();
                          _selectedIndex = 0;
                        });
                        controller.saveGame();
                        Navigator.pop(ctx);
                      },
                      child: const Text("Zurücksetzen"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() => _selectedIndex = index);
                },
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(icon: Icon(Icons.person_add), label: Text("Spieler")),
                  NavigationRailDestination(icon: Icon(Icons.edit), label: Text("Runde")),
                  NavigationRailDestination(icon: Icon(Icons.show_chart), label: Text("Scoreboard")),
                ],
              );
            } else {
              return BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (int index) => setState(() => _selectedIndex = index),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.person_add), label: "Spieler"),
                  BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Runde"),
                  BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Scoreboard"),
                ],
              );
            }
          }),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}