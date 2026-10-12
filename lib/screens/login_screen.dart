import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _nome =
  TextEditingController(text: AppState.instance.userName);

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  void _entrar() {
    AppState.instance.definirNome(_nome.text);
    // pushReplacement: o login sai da pilha, então "voltar" não retorna a ele.
    Navigator.of(context).pushReplacementNamed(AppRoutes.principal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'CodeUP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF16326B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nome,
                    decoration: const InputDecoration(
                      labelText: 'Seu nome',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _entrar(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _entrar,
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}