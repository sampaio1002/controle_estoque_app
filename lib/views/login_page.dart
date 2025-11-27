// lib/views/login_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/auth_viewmodel.dart';
import 'package:controle_estoque_app/views/home_page.dart'; // Importa a HomePage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  
  bool _isLogin = true; 
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    // 1. Inicia o Carregamento
    setState(() { _isLoading = true; });

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    bool sucesso = false; // Inicializa a variável sucesso
    String? nome;

    try {
      // Limpa qualquer erro antigo do ViewModel antes de tentar
      authViewModel.clearError(); // Assumindo que você adicionará clearError no AuthViewModel

      // 2. Tenta Login ou Cadastro
      if (_isLogin) {
        sucesso = await authViewModel.login(_emailController.text, _senhaController.text);
      } else {
        nome = _emailController.text.split('@')[0];
        sucesso = await authViewModel.cadastrar(nome, _emailController.text, _senhaController.text);
      }

      // 3. Verifica o Resultado e Navega
      if (sucesso && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (mounted && authViewModel.errorMessage != null) {
        // Mostra SnackBar com mensagem de erro do ViewModel
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authViewModel.errorMessage!)),
        );
      }
    } catch (e) {
      // 4. Captura Exceções Inesperadas (Garantia de Tratamento de Erro)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro inesperado: ${e.toString()}')),
        );
      }
    } finally {
      // 5. GARANTE que o Carregamento Termine (OTIMIZAÇÃO)
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Cadastro'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == null || !value.contains('@')) ? 'Por favor, insira um email válido.' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _senhaController,
                  decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: (value) => (value == null || value.length < 3) ? 'A senha deve ter no mínimo 3 caracteres (Mock).' : null,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(_isLogin ? 'ENTRAR' : 'CADASTRAR'),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () { setState(() { _isLogin = !_isLogin; _formKey.currentState?.reset(); }); },
                  child: Text(_isLogin ? 'Não tem conta? Cadastre-se' : 'Já tenho uma conta. Fazer Login', style: const TextStyle(color: Colors.teal)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}