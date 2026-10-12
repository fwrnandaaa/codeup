import 'package:flutter/widgets.dart';

/// Observer que registra (debugPrint) toda operação de pilha de um Navigator.
/// Cada Navigator (raiz + 1 por aba) recebe o seu, com um [tag] próprio, e
/// mantém uma cópia da pilha para exibir "pilha: /a > /b > /c" nos logs.
class LogObserver extends NavigatorObserver {
  LogObserver(this.tag);

  final String tag;
  final List<Route<dynamic>> _pilha = [];

  String _nome(Route<dynamic>? r) =>
      r == null ? '-' : (r.settings.name ?? r.runtimeType.toString());

  void _log(String evento, String detalhe) {
    final pilha = _pilha.map(_nome).join(' > ');
    debugPrint('[NAV][$tag] $evento $detalhe | pilha: [$pilha]');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _pilha.add(route);
    _log('PUSH   ', _nome(route));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _pilha.remove(route);
    _log('POP    ', '${_nome(route)} (volta para ${_nome(previousRoute)})');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final i = oldRoute == null ? -1 : _pilha.indexOf(oldRoute);
    if (i >= 0 && newRoute != null) {
      _pilha[i] = newRoute;
    } else if (newRoute != null) {
      _pilha.add(newRoute);
    }
    _log('REPLACE', '${_nome(oldRoute)} -> ${_nome(newRoute)}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _pilha.remove(route);
    _log('REMOVE ', _nome(route));
  }
}