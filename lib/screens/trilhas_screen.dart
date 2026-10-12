import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_state.dart';
import '../navigation/shell_scope.dart';

/// Aba "Trilhas": lista -> Conteúdo -> Desafio (3 níveis de pilha na aba).
class TrilhasScreen extends StatelessWidget {
  const TrilhasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFFF7FBFF),
        appBar: AppBar(
          leading: const MenuButton(),
          title: const Text('Python - Seu aprendizado'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '${state.trilha.length} conteúdos nessa trilha • '
                  '${state.concluidos} concluídos',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < state.trilha.length; i++)
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: state.trilha[i].concluido
                        ? const Color(0xFFE8896B)
                        : Colors.grey[300],
                    child: Icon(
                      state.trilha[i].concluido
                          ? Icons.check
                          : (state.desbloqueado(i)
                          ? Icons.play_arrow
                          : Icons.lock_outline),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(state.trilha[i].nome),
                  subtitle: Text(state.trilha[i].concluido
                      ? 'Concluído'
                      : (state.desbloqueado(i) ? 'Disponível' : 'Bloqueado')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    if (state.desbloqueado(i)) {
                      // PUSH com arguments (o próprio TrilhaItem).
                      Navigator.of(context).pushNamed(
                        AppRoutes.trilhaConteudo,
                        arguments: state.trilha[i],
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Complete as etapas anteriores.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}