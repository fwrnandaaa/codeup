import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_routes.dart';
import '../navigation/log_observer.dart';
import '../navigation/shell_scope.dart';
import '../widgets/app_drawer.dart';

class _Aba {
  const _Aba(this.titulo, this.rota, this.icone, this.iconeAtivo);
  final String titulo;
  final String rota; // rota inicial do Navigator da aba
  final IconData icone;
  final IconData iconeAtivo;
}

/// Tela principal: Drawer + BottomNavigationBar + um Navigator POR ABA dentro
/// de um IndexedStack.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _abas = [
    _Aba('Home', AppRoutes.home, Icons.home_outlined, Icons.home),
    _Aba('Trilhas', AppRoutes.trilhas, Icons.map_outlined, Icons.map),
    _Aba('Desafios', AppRoutes.desafios, Icons.flag_outlined, Icons.flag),
    _Aba('Perfil', AppRoutes.perfil, Icons.person_outline, Icons.person),
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Uma chave por Navigator => acesso à pilha de cada aba (canPop/pop/popUntil).
  final List<GlobalKey<NavigatorState>> _navKeys =
  List.generate(_abas.length, (_) => GlobalKey<NavigatorState>());

  // Um observer (log) por Navigator.
  late final List<LogObserver> _observers = [
    for (final aba in _abas) LogObserver('Aba ${aba.titulo}'),
  ];

  int _index = 0;

  void _abrirDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _onTabTap(int i) {
    if (i == _index) {
      // Tocar na aba já ativa volta para a raiz DA PRÓPRIA aba.
      final nav = _navKeys[i].currentState;
      if (nav != null && nav.canPop()) {
        debugPrint('[NAV] aba ${_abas[i].titulo} reselecionada: popUntil(raiz)');
        nav.popUntil((route) => route.isFirst);
      }
      return;
    }
    debugPrint('[NAV] troca de aba: ${_abas[_index].titulo} -> '
        '${_abas[i].titulo} (pilhas preservadas pelo IndexedStack)');
    setState(() => _index = i);
  }

  /// Botão voltar do sistema. canPop=false no PopScope nos dá o controle:
  ///  1) drawer aberto  -> fecha o drawer
  ///  2) aba tem histórico -> pop no Navigator DA ABA ATUAL
  ///  3) está na raiz de uma aba != Home -> volta para a aba Home
  ///  4) raiz da Home   -> fecha o app
  void _onBack(bool didPop, Object? result) {
    if (didPop) return;

    final scaffold = _scaffoldKey.currentState;
    if (scaffold != null && scaffold.isDrawerOpen) {
      debugPrint('[NAV] voltar: fechando o Drawer');
      scaffold.closeDrawer();
      return;
    }

    final nav = _navKeys[_index].currentState;
    if (nav != null && nav.canPop()) {
      debugPrint('[NAV] voltar: pop na pilha da aba ${_abas[_index].titulo}');
      nav.pop();
      return;
    }

    if (_index != 0) {
      debugPrint('[NAV] voltar: raiz da aba ${_abas[_index].titulo}, '
          'indo para a aba Home');
      setState(() => _index = 0);
      return;
    }

    debugPrint('[NAV] voltar: raiz da Home, fechando o app');
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onBack,
      child: ShellScope(
        abrirDrawer: _abrirDrawer,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(),
          // IndexedStack mantém TODOS os Navigators vivos; só um é exibido.
          body: IndexedStack(
            index: _index,
            children: [
              for (var i = 0; i < _abas.length; i++)
                Navigator(
                  key: _navKeys[i],
                  observers: [_observers[i]],
                  initialRoute: _abas[i].rota,
                  // Evita que o Navigator tente criar rotas pai ("/" etc.)
                  // a partir de initialRoute com barras.
                  onGenerateInitialRoutes: (navigator, initialRoute) => [
                    AppRoutes.onGenerateTabRoute(
                        RouteSettings(name: initialRoute))!,
                  ],
                  onGenerateRoute: AppRoutes.onGenerateTabRoute,
                ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _index,
            selectedItemColor: const Color(0xFF16326B),
            unselectedItemColor: Colors.grey,
            onTap: _onTabTap,
            items: [
              for (final aba in _abas)
                BottomNavigationBarItem(
                  icon: Icon(aba.icone),
                  activeIcon: Icon(aba.iconeAtivo),
                  label: aba.titulo,
                ),
            ],
          ),
        ),
      ),
    );
  }
}