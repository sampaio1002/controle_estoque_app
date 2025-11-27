// lib/viewmodels/auth_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:controle_estoque_app/models/usuario.dart';
import 'package:controle_estoque_app/services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  // O Serviço (que faz a simulação de login)
  final AuthService _authService = AuthService();
  
  // O estado do usuário logado
  Usuario? _usuarioLogado;

  // Getters para a UI
  bool get estaLogado => _usuarioLogado != null;
  Usuario? get usuarioLogado => _usuarioLogado;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // =========================================================
  // CORREÇÃO: Método adicionado para limpar a mensagem de erro 
  // antes de uma nova tentativa de login/cadastro.
  void clearError() {
    _errorMessage = null;
    // Não precisa de notifyListeners() aqui, pois a view de login
    // já lida com o estado de carregamento e erro através do setState.
  }
  // =========================================================

  // Lógica de Login
  Future<bool> login(String email, String senha) async {
    try {
      _errorMessage = null;
      // Chamada simulada
      final usuario = await _authService.login(email, senha);
      _usuarioLogado = usuario;
      notifyListeners();
      return usuario != null;
    } catch (e) {
      _errorMessage = 'Erro de Login: Usuário ou senha inválidos.';
      notifyListeners();
      return false;
    }
  }

  // Lógica de Cadastro
  Future<bool> cadastrar(String nome, String email, String senha) async {
    try {
      _errorMessage = null;
      await _authService.cadastrar(nome, email, senha);
      return await login(email, senha); // Tenta logar após cadastrar
    } catch (e) {
      _errorMessage = 'Erro ao cadastrar: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Lógica de Logout
  void logout() {
    _usuarioLogado = null;
    notifyListeners();
  }
}