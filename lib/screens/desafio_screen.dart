import 'package:flutter/material.dart';

import '../models/app_state.dart';

/// Quiz. Recebe [DesafioArgs] por `arguments` e DEVOLVE um [DesafioResultado]
/// com Navigator.pop(context, resultado) ao concluir.
class DesafioScreen extends StatefulWidget {
  const DesafioScreen({super.key, required this.args});

  final DesafioArgs args;

  @override
  State<DesafioScreen> createState() => _DesafioScreenState();
}

class _DesafioScreenState extends State<DesafioScreen> {
  late final TrilhaItem _item =
  AppState.instance.trilhaPorNome(widget.args.tema);

  int _atual = 0;
  int _acertos = 0;
  int? _escolhida;
  bool _fim = false;

  List<Questao> get _questoes => _item.questoes;
  Questao get _questao => _questoes[_atual];

  void _escolher(int i) {
    if (_escolhida != null) return;
    setState(() {
      _escolhida = i;
      if (i == _questao.correta) _acertos++;
    });
  }

  void _proxima() {
    setState(() {
      if (_atual < _questoes.length - 1) {
        _atual++;
        _escolhida = null;
      } else {
        _fim = true;
      }
    });
  }

  void _concluir() {
    Navigator.of(context).pop(
      DesafioResultado(
        tema: _item.nome,
        acertos: _acertos,
        total: _questoes.length,
      ),
    );
  }

  Color? _corOpcao(int i) {
    if (_escolhida == null) return null;
    if (i == _questao.correta) return Colors.green.shade100;
    if (i == _escolhida) return Colors.red.shade100;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(title: Text('Desafio: ${_item.nome}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _fim ? _buildResultado() : _buildPergunta(),
      ),
    );
  }

  Widget _buildPergunta() {
    final q = _questao;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < _questoes.length; i++)
                Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i <= _atual
                          ? const Color(0xFFE8896B)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Questão ${_atual + 1} de ${_questoes.length}',
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          Text(q.enunciado,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (q.codigo != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE8896B), width: 2),
              ),
              child: Text(
                q.codigo!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          for (var i = 0; i < q.opcoes.length; i++)
            Card(
              color: _corOpcao(i),
              child: ListTile(
                title: Text(q.opcoes[i]),
                onTap: () => _escolher(i),
              ),
            ),
          const SizedBox(height: 8),
          if (_escolhida != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proxima,
                child: Text(_atual < _questoes.length - 1
                    ? 'Próxima'
                    : 'Ver resultado'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultado() {
    final aprovado = _acertos * 2 > _questoes.length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(aprovado ? Icons.emoji_events : Icons.replay,
            size: 72, color: const Color(0xFFE8896B)),
        const SizedBox(height: 16),
        Text(
          'Você acertou $_acertos de ${_questoes.length}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '+$_acertos XP',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _concluir, // pop COM VALOR
          child: const Text('Concluir'),
        ),
      ],
    );
  }
}