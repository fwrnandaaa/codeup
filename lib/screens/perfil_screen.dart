import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_state.dart';
import '../navigation/shell_scope.dart';

/// Aba "Perfil": Perfil -> Conquistas (2 níveis de pilha).
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFFF7FBFF),
        appBar: AppBar(
          leading: const MenuButton(),
          title: const Text('Perfil'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
              const SizedBox(height: 12),
              Text(state.userName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Nível ${state.nivel} • ${state.xp} XP • '
                  '${state.streak} dias seguidos'),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.emoji_events),
                title: const Text('Conquistas'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.conquistas),
              ),
            ],
          ),
        ),
      ),
    );
  }
}