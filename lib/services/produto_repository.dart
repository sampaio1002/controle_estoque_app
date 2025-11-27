import 'package:hive_flutter/hive_flutter.dart';
import 'package:controle_estoque_app/models/produto.dart'; 

class ProdutoRepository {
  
  static const String _produtoBoxName = 'produtos';

  
  Future<void> adicionarProduto(Produto produto) async {
    final box = await Hive.openBox<Produto>(_produtoBoxName);
    
    await box.add(produto);
  }

  
  Future<List<Produto>> listarTodosProdutos() async {
    final box = await Hive.openBox<Produto>(_produtoBoxName);
    
    return box.values.toList();
  }

  
  Future<void> atualizarProduto(Produto produto) async {
    
    await produto.save();
  }

  
  Future<void> excluirProduto(Produto produto) async {
    
    await produto.delete();
  }

  
  Future<List<Produto>> listarProdutosComEstoqueBaixo() async {
    final box = await Hive.openBox<Produto>(_produtoBoxName);
    
    return box.values.where((p) => p.precisaRepor).toList();
  }
}

