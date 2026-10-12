import 'package:flutter/material.dart';

import '../models/app_state.dart';
import '../navigation/navigation_helpers.dart';

/// Recebe um [TrilhaItem] via `arguments` da rota nomeada.
class ConteudoScreen extends StatelessWidget {
  const ConteudoScreen({super.key, required this.item});

  final TrilhaItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(title: Text(item.nome)), // seta de voltar automática
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.nome,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(item.descricao, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => abrirDesafio(context, item.nome),
                child: Text('Fazer desafio de ${item.nome}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}