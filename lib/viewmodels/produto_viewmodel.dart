import 'package:flutter/material.dart';
import 'package:controle_estoque_app/models/produto.dart';
import 'package:controle_estoque_app/services/produto_repository.dart';


class ProdutoViewModel with ChangeNotifier {
  
  
  final ProdutoRepository _repository = ProdutoRepository();

  
  List<Produto> _produtos = [];
  List<Produto> get produtos => _produtos;


  Future<void> carregarProdutos() async {
    _produtos = await _repository.listarTodosProdutos();
    
    notifyListeners();
  }

  
  Future<void> adicionarProduto(Produto produto) async {
    await _repository.adicionarProduto(produto);
    
    await carregarProdutos();
  }

  
  Future<void> atualizarProduto(Produto produto) async {
    await _repository.atualizarProduto(produto);
    
    await carregarProdutos();
  }

  
  Future<void> excluirProduto(Produto produto) async {
    await _repository.excluirProduto(produto);
    
    await carregarProdutos();
  }
  
  
  Future<List<Produto>> get produtosComEstoqueBaixo async {
    return await _repository.listarProdutosComEstoqueBaixo();
  }

  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  
}

