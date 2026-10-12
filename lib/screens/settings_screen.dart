import 'package:flutter/material.dart';

import '../models/app_state.dart';

/// Aberta com PUSH pelo Drawer, no Navigator raiz (cobre as abas).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _lembrete = true;

  Future<void> _escolherMeta() async {
    // showDialog devolve o valor passado em Navigator.pop(context, valor).
    final meta = await showDialog<int>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Meta diária (questões)'),
        children: [
          for (final m in [3, 5, 10])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, m),
              child: Text('$m questões'),
            ),
        ],
      ),
    );
    if (meta != null) {
      debugPrint('[NAV] Meta diária escolhida (pop com valor): $meta');
      AppState.instance.definirMeta(meta);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) => ListView(
          children: [
            SwitchListTile(
              title: const Text('Lembrete diário'),
              value: _lembrete,
              onChanged: (v) => setState(() => _lembrete = v),
            ),
            ListTile(
              title: const Text('Meta diária'),
              subtitle: Text('${AppState.instance.metaDiaria} questões'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _escolherMeta,
            ),
          ],
        ),
      ),
    );
  }
}