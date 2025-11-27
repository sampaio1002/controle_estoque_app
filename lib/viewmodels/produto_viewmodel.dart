// lib/viewmodels/produto_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:controle_estoque_app/models/produto.dart';
import 'package:controle_estoque_app/services/produto_repository.dart';

// O 'ChangeNotifier' é a base do Provider, permitindo notificar as Views.
class ProdutoViewModel with ChangeNotifier {
  
  // 1. Dependência do Serviço (Acesso a Dados)
  final ProdutoRepository _repository = ProdutoRepository();

  // 2. O Estado da Aplicação (A lista de produtos a ser exibida nas Views)
  List<Produto> _produtos = [];
  List<Produto> get produtos => _produtos;

  // ----------------------------------------------------
  // MÉTODOS DE AÇÃO (Lógica de Negócios)
  // ----------------------------------------------------

  // Carrega todos os produtos do Repository e atualiza o estado
  Future<void> carregarProdutos() async {
    _produtos = await _repository.listarTodosProdutos();
    // Notifica todos os widgets ouvintes para reconstruírem a tela.
    notifyListeners();
  }

  // Adiciona um novo produto
  Future<void> adicionarProduto(Produto produto) async {
    await _repository.adicionarProduto(produto);
    // Recarrega a lista para refletir a mudança imediatamente
    await carregarProdutos();
  }

  // Atualiza um produto existente
  Future<void> atualizarProduto(Produto produto) async {
    await _repository.atualizarProduto(produto);
    // Recarrega a lista
    await carregarProdutos();
  }

  // Exclui um produto
  Future<void> excluirProduto(Produto produto) async {
    await _repository.excluirProduto(produto);
    // Recarrega a lista
    await carregarProdutos();
  }
  
  // Retorna a lista de produtos com estoque baixo (Exemplo de Filtro)
  Future<List<Produto>> get produtosComEstoqueBaixo async {
    return await _repository.listarProdutosComEstoqueBaixo();
  }

  // ----------------------------------------------------
  // TRATAMENTO DE ERROS BÁSICO (Para ser expandido depois)
  // ----------------------------------------------------
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Exemplo de como usar:
  /*
  Future<void> tentarAdicionar(Produto produto) async {
    try {
      await adicionarProduto(produto);
    } catch (e) {
      _errorMessage = 'Erro ao adicionar produto: ${e.toString()}';
      notifyListeners();
    }
  }
  */
}

/*
Princípios Aplicados:
1. MVVM: Separação clara da View (UI) da Lógica de Negócios (ViewModel).
2. Controle de Estado: O 'notifyListeners()' garante que as mudanças de dados sejam refletidas na UI.
3. POO: Herança ('with ChangeNotifier') e Encapsulamento (lista '_produtos' privada).
*/