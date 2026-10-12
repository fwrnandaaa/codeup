import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_state.dart';

/// Drawer com ações COMPLEMENTARES (não são seções do app):
///  - Configurações -> push (empilha uma nova tela por cima de tudo)
///  - Sobre         -> diálogo modal simples
///  - Sair          -> pushReplacement para o login (descarta o app inteiro)
///
/// O `context` deste widget está ACIMA dos Navigators das abas, então
/// Navigator.of(context) é o Navigator RAIZ. Por isso Configurações cobre
/// inclusive a BottomNavigationBar.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListenableBuilder(
              listenable: state,
              builder: (context, _) => UserAccountsDrawerHeader(
                accountName: Text(state.userName),
                accountEmail: Text('Python • Nível ${state.nivel}'),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                final nav = Navigator.of(context);
                nav.pop(); // fecha o drawer
                nav.pushNamed(AppRoutes.configuracoes); // PUSH
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.of(context).pop(); // fecha o drawer
                showAboutDialog(
                  context: context,
                  applicationName: 'CodeUP',
                  applicationVersion: '1.0.0',
                  children: const [
                    Text('App para iniciantes aprenderem programação com '
                        'pequenos desafios diários.'),
                  ],
                );
              },
            ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () => _sair(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sair(BuildContext context) async {
    final nav = Navigator.of(context);
    // showDialog devolve o valor passado em Navigator.pop(context, valor).
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      // PUSHREPLACEMENT: troca a tela principal pelo login. Não há "voltar"
      // para o app depois do logout.
      nav.pushReplacementNamed(AppRoutes.login);
    }
  }
}