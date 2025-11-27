import 'package:controle_estoque_app/models/usuario.dart';

class AuthService {
  
  final List<Usuario> _usuariosMock = [
    Usuario(id: '1', email: 'teste@app.com', nome: 'Usuário Padrão')
  ];
  
  
  Future<Usuario?> login(String email, String senha) async {
    
    if (email == 'teste@app.com' && senha == '123') {
      return _usuariosMock.first;
    }

    try {
      final user = _usuariosMock.firstWhere((u) => u.email == email);
      
      
      if (senha == '123') {
        return user;
      }
    } catch (_) {
      throw Exception('Usuário não encontrado.');
    }
    
    return null; 
  }

  Future<Usuario> cadastrar(String nome, String email, String senha) async {
    
    if (_usuariosMock.any((u) => u.email == email)) {
       throw Exception('Este e-mail já está cadastrado.');
    }

    
    final novoUsuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      email: email, 
      nome: nome
    );
    _usuariosMock.add(novoUsuario);

    return novoUsuario;
  }
}