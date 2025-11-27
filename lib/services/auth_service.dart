// lib/services/auth_service.dart

import 'package:controle_estoque_app/models/usuario.dart';

class AuthService {
  
  // Simula um banco de dados de usuários para autenticação local
  // Note: Você pode se logar com 'teste@app.com' e '123'
  final List<Usuario> _usuariosMock = [
    Usuario(id: '1', email: 'teste@app.com', nome: 'Usuário Padrão')
  ];
  
  // ----------------------------------------------------
  // Login: Simula a verificação de credenciais
  // ----------------------------------------------------
  Future<Usuario?> login(String email, String senha) async {
    // 1. Verifica as credenciais de teste padrão
    if (email == 'teste@app.com' && senha == '123') {
      return _usuariosMock.first;
    }

    // 2. Tenta encontrar um usuário cadastrado
    try {
      final user = _usuariosMock.firstWhere((u) => u.email == email);
      
      // Simulação: se a senha for '123', o login é bem-sucedido.
      if (senha == '123') {
        return user;
      }
    } catch (_) {
      // Usuário não encontrado
      throw Exception('Usuário não encontrado.');
    }
    
    return null; // Falha na autenticação
  }

  // ----------------------------------------------------
  // Cadastro: Adiciona um novo usuário (mock)
  // ----------------------------------------------------
  Future<Usuario> cadastrar(String nome, String email, String senha) async {
    // Validação: Garante que o usuário não exista (no mock)
    if (_usuariosMock.any((u) => u.email == email)) {
       throw Exception('Este e-mail já está cadastrado.');
    }

    // Cria e salva o usuário (mock)
    final novoUsuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      email: email, 
      nome: nome
    );
    _usuariosMock.add(novoUsuario);

    return novoUsuario;
  }
}