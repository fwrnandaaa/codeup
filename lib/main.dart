import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'navigation/log_observer.dart';

void main() {
  runApp(const CodeUpApp());
}

class CodeUpApp extends StatelessWidget {
  const CodeUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // Rotas nomeadas centralizadas (mapeamento no MaterialApp).
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      // Log da pilha do Navigator raiz (splash/login/principal/configurações).
      navigatorObservers: [LogObserver('Raiz')],
    );
  }
}