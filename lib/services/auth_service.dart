import 'package:controle_estoque_app/models/usuario.dart';

class AuthService {
  
  
  final List<Usuario> _usuariosMock = [
    Usuario(id: '1', email: 'teste@app.com', nome: 'Usuário Padrão')
  ];
  
  
  Future<Usuario?> login(String email, String senha) async {
    
    final user = _usuariosMock.cast<Usuario?>().firstWhere(
      (u) => u?.email == email,
      orElse: () => null, 
    );

    
    if (user != null && senha == '123') {
        return user; 
    }
    
    
    throw Exception('Credenciais inválidas.'); 
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