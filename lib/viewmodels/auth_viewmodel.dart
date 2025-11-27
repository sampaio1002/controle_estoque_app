import 'package:flutter/material.dart';
import 'package:controle_estoque_app/models/usuario.dart';
import 'package:controle_estoque_app/services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  
  final AuthService _authService = AuthService();
  
  Usuario? _usuarioLogado;

  
  bool get estaLogado => _usuarioLogado != null;
  Usuario? get usuarioLogado => _usuarioLogado;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  
  void clearError() {
    _errorMessage = null;
    
  }
  
  Future<bool> login(String email, String senha) async {
    try {
      _errorMessage = null;
      
      final usuario = await _authService.login(email, senha);
      _usuarioLogado = usuario;
      notifyListeners();
      return usuario != null;
    } catch (e) {
      
      if (e.toString().contains('Credenciais inválidas')) {
          _errorMessage = 'Usuário ou senha inválidos.';
      } else {
          _errorMessage = 'Erro de Login inesperado.';
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> cadastrar(String nome, String email, String senha) async {
    try {
      _errorMessage = null;
      await _authService.cadastrar(nome, email, senha);
      
      
      return await login(email, senha);
    } catch (e) {
      
      _errorMessage = e.toString().contains('já está cadastrado') 
                      ? 'Este e-mail já está cadastrado.'
                      : 'Erro desconhecido ao cadastrar.';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _usuarioLogado = null;
    notifyListeners();
  }
}