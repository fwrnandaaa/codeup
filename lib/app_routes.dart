import 'package:flutter/material.dart';

import 'models/app_state.dart';
import 'screens/conquistas_screen.dart';
import 'screens/conteudo_screen.dart';
import 'screens/desafio_screen.dart';
import 'screens/desafios_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/perfil_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/trilhas_screen.dart';

/// Rotas nomeadas CENTRALIZADAS. Este mapa é a única fonte de verdade:
///  - o MaterialApp (Navigator raiz) o usa em `routes:`;
///  - cada Navigator aninhado (uma por aba) o usa em `onGenerateRoute:`.
class AppRoutes {
  AppRoutes._();

  // ---- Navigator raiz ----
  static const splash = '/';
  static const login = '/login';
  static const principal = '/principal'; // shell: Drawer + BottomNavigationBar
  static const configuracoes = '/configuracoes';

  // ---- Navigators das abas ----
  static const home = '/home';
  static const trilhas = '/trilhas';
  static const trilhaConteudo = '/trilhas/conteudo'; // recebe arguments
  static const desafios = '/desafios';
  static const desafio = '/desafio'; // recebe arguments e devolve resultado
  static const perfil = '/perfil';
  static const conquistas = '/perfil/conquistas';

  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    principal: (_) => const MainShell(),
    configuracoes: (_) => const SettingsScreen(),
    home: (_) => const HomeScreen(),
    trilhas: (_) => const TrilhasScreen(),
    trilhaConteudo: (ctx) => ConteudoScreen(item: _args<TrilhaItem>(ctx)),
    desafios: (_) => const DesafiosScreen(),
    desafio: (ctx) => DesafioScreen(args: _args<DesafioArgs>(ctx)),
    perfil: (_) => const PerfilScreen(),
    conquistas: (_) => const ConquistasScreen(),
  };

  /// Lê os `arguments` passados em Navigator.pushNamed(..., arguments: x).
  static T _args<T>(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments as T;

  /// Usado pelos Navigators aninhados das abas (mesmo mapa do MaterialApp).
  static Route<dynamic>? onGenerateTabRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder == null) return null;
    return MaterialPageRoute<dynamic>(settings: settings, builder: builder);
  }
}