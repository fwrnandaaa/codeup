import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_state.dart';
import '../navigation/navigation_helpers.dart';
import '../navigation/shell_scope.dart';

/// Aba "Home". Mantém o layout/gestos da versão anterior; agora a navegação
/// inferior fica no MainShell e os dados vêm do AppState compartilhado.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  AppState get _state => AppState.instance;

  void _onComecarPressed(BuildContext context) {
    final proxima = _state.proximo;

    if (proxima == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você já completou toda a trilha disponível!'),
          backgroundColor: Colors.blueGrey,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Iniciar desafio?'),
        content: Text('Próxima etapa: ${proxima.nome}. Deseja começar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // PUSH com arguments + aguarda resultado (pop com valor).
              abrirDesafio(context, proxima.nome);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _onTrilhaTap(BuildContext context, int index) {
    final item = _state.trilha[index];
    if (_state.desbloqueado(index)) {
      // PUSH na pilha da aba Home: Home -> Conteúdo (-> Desafio).
      Navigator.of(context)
          .pushNamed(AppRoutes.trilhaConteudo, arguments: item);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Complete os passos anteriores para desbloquear "${item.nome}".'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onTrilhaLongPress(BuildContext context, int index) {
    final item = _state.trilha[index];
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Detalhes da etapa'),
        content: Text(item.concluido
            ? 'Você já concluiu "${item.nome}". Parabéns!'
            : '"${item.nome}" ainda não foi concluída.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _onMoedasTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você tem ${_state.xp} moedas de XP.')),
    );
  }

  void _onMoedasLongPress(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Histórico de XP'),
        content: Text(_state.historico.take(5).join('\n')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _state,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFFF7FBFF),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return _buildMobileLayout(context);
              } else {
                return _buildDesktopLayout(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildDesafioCard(context),
                const SizedBox(height: 24),
                _buildTrilhaSection(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildDesafioCard(context)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildTrilhaSection(context)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const MenuButton(compacto: true),
              const SizedBox(width: 12),
              const Text(
                'CodeUP',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF16326B)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _onMoedasTap(context),
                onLongPress: () => _onMoedasLongPress(context),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('${_state.xp}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Olá, ${_state.userName}!',
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildTag('Python'),
              const SizedBox(width: 8),
              _buildTag('Iniciante'),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Sua jornada',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _state.progresso,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation(Color(0xFFE8896B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildDesafioCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3AFAE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Desafio de hoje',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('3 questões - 5 minutos', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _onComecarPressed(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF16326B),
              ),
              child: const Text('Começar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrilhaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sua trilha',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < _state.trilha.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                // ---- ÁREA DE GESTO: onTap e onLongPress ----
                child: GestureDetector(
                  onTap: () => _onTrilhaTap(context, i),
                  onLongPress: () => _onTrilhaLongPress(context, i),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: _state.trilha[i].concluido
                        ? const Color(0xFFE8896B)
                        : Colors.grey[300],
                    child: Icon(
                      _state.trilha[i].concluido
                          ? Icons.check
                          : (_state.desbloqueado(i)
                          ? Icons.play_arrow
                          : Icons.lock_outline),
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}