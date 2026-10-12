import 'package:flutter/material.dart';

/// Permite que telas dentro dos Navigators aninhados (abas) abram o Drawer
/// do Scaffold principal, que fica ACIMA dos Navigators das abas.
class ShellScope extends InheritedWidget {
  const ShellScope({
    super.key,
    required this.abrirDrawer,
    required super.child,
  });

  final VoidCallback abrirDrawer;

  static ShellScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ShellScope>();
    assert(scope != null, 'ShellScope não encontrado na árvore de widgets');
    return scope!;
  }

  @override
  bool updateShouldNotify(ShellScope oldWidget) =>
      abrirDrawer != oldWidget.abrirDrawer;
}

/// Botão "hambúrguer" que abre o Drawer principal.
class MenuButton extends StatelessWidget {
  const MenuButton({super.key, this.compacto = false});

  final bool compacto;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: 'Menu',
      padding: compacto ? EdgeInsets.zero : const EdgeInsets.all(8),
      constraints: compacto ? const BoxConstraints() : null,
      onPressed: ShellScope.of(context).abrirDrawer,
    );
  }
}