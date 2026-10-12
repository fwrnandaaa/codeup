import 'package:flutter/material.dart';

import '../app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3AFAE), Color(0xFFFFE0A8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'CodeUP',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16326B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aprenda programação de forma prática',
                style: TextStyle(color: Color(0xFF16326B)),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                // pushReplacement: a splash NÃO deve ficar na pilha.
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                child: const Text('Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}