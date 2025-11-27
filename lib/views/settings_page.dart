// lib/views/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/auth_viewmodel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações'), backgroundColor: Colors.teal),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Botão de Logout para teste
            Provider.of<AuthViewModel>(context, listen: false).logout();
          },
          child: const Text('Sair (Logout)'),
        ),
      ),
    );
  }
}