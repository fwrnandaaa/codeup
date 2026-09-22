import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _moedas = 12;
  bool _desafioConcluido = false;

  // Simula os tópicos da trilha vindos da API
  final List<Map<String, dynamic>> _trilha = [
    {'nome': 'Variáveis', 'concluido': true},
    {'nome': 'Tipos de dados', 'concluido': true},
    {'nome': 'Operadores', 'concluido': true},
    {'nome': 'Condicionais', 'concluido': false},
    {'nome': 'Funções', 'concluido': false},
  ];

  // =====================================================
  // EVENTOS — BOTÃO "COMEÇAR" (ação principal + encadeamento)
  // =====================================================

  void _onComecarPressed() {
    // Lida com clique repetido de forma previsível: não deixa ganhar XP 2x
    if (_desafioConcluido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você já concluiu o desafio de hoje! Volte amanhã.'),
          backgroundColor: Colors.blueGrey,
        ),
      );
      return;
    }

    // Encadeamento de eventos:
    // onPressed -> verifica condição -> abre AlertDialog -> confirma -> fecha -> SnackBar + atualiza XP
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Iniciar desafio?'),
        content: const Text('5 questões rápidas sobre Python. Pronto para começar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // fecha o AlertDialog
              setState(() {
                _desafioConcluido = true;
                _moedas += 5;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Desafio concluído! +5 XP'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // EVENTOS — TRILHA (gesto: onTap e onLongPress)
  // =====================================================

  void _onTrilhaTap(String nome, bool concluido) {
    if (concluido) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Revisando: $nome')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complete os passos anteriores para desbloquear "$nome".'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onTrilhaLongPress(String nome, bool concluido) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes da etapa'),
        content: Text(
          concluido
              ? 'Você já concluiu "$nome". Parabéns!'
              : '"$nome" está bloqueada. Complete as etapas anteriores para liberar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // EVENTOS — BADGE DE MOEDAS (gesto: onTap e onLongPress)
  // =====================================================

  void _onMoedasTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você tem $_moedas moedas de XP.')),
    );
  }

  void _onMoedasLongPress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Histórico de XP'),
        content: const Text(
            '+3 XP: Variáveis\n+2 XP: Tipos de dados\n+7 XP: Desafios diários'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BUILD PRINCIPAL
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return _buildMobileLayout();
            } else {
              return _buildDesktopLayout();
            }
          },
        ),
      ),
    );
  }

  // =====================================================
  // LAYOUT MOBILE
  // =====================================================
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildDesafioCard(),
                const SizedBox(height: 24),
                _buildTrilhaSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        _buildBottomNav(),
      ],
    );
  }

  // =====================================================
  // LAYOUT DESKTOP/TABLET
  // =====================================================
  Widget _buildDesktopLayout() {
    return Column(
      children: [
        _buildHeader(),
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
                      Expanded(child: _buildDesafioCard()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildTrilhaSection()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildBottomNav(),
      ],
    );
  }

  // ---------- WIDGETS AUXILIARES ----------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CodeUP',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF16326B)),
              ),
              // ---- ÁREA DE GESTO: onTap e onLongPress ----
              GestureDetector(
                onTap: _onMoedasTap,
                onLongPress: _onMoedasLongPress,
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
                      Text('$_moedas',
                          style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Olá, Juliana!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
              value: 0.45,
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

  Widget _buildDesafioCard() {
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
          const Text('5 questões - 5 minutos', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 16),

          // ---- BOTÃO "COMEÇAR": onPressed com condição + encadeamento ----
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onComecarPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF16326B),
              ),
              child: Text(_desafioConcluido ? 'Concluído ✓' : 'Começar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrilhaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sua trilha',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: _trilha.map((item) {
            final nome = item['nome'] as String;
            final concluido = item['concluido'] as bool;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              // ---- ÁREA DE GESTO: onTap e onLongPress ----
              child: GestureDetector(
                onTap: () => _onTrilhaTap(nome, concluido),
                onLongPress: () => _onTrilhaLongPress(nome, concluido),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor:
                  concluido ? const Color(0xFFE8896B) : Colors.grey[300],
                  child: Icon(
                    concluido ? Icons.check : Icons.lock_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _NavItem(icon: Icons.home, label: 'Home'),
          _NavItem(icon: Icons.map_outlined, label: 'Trilhas'),
          _NavItem(icon: Icons.flag_outlined, label: 'Desafios'),
          _NavItem(icon: Icons.person_outline, label: 'Perfil'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: const Color(0xFF16326B)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}