import 'package:flutter/material.dart';

import '../models/app_state.dart';

class ConquistasScreen extends StatelessWidget {
  const ConquistasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance;
    final conquistas = <(String, bool)>[
      ('Primeiros passos (ganhe XP)', s.xp > 0),
      ('Sequência de 3 dias', s.streak >= 3),
      ('Nível 2', s.nivel >= 2),
      ('Trilha completa', s.concluidos == s.trilha.length),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(title: const Text('Conquistas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final c in conquistas)
            Card(
              child: ListTile(
                leading: Icon(
                  c.$2 ? Icons.emoji_events : Icons.lock_outline,
                  color: c.$2 ? Colors.amber : Colors.grey,
                ),
                title: Text(c.$1),
              ),
            ),
        ],
      ),
    );
  }
}