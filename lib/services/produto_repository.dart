import 'package:hive_flutter/hive_flutter.dart';
import 'package:controle_estoque_app/models/produto.dart'; // Importa o nosso modelo POO

class ProdutoRepository {
  // O nome da nossa "tabela" no Hive
  static const String _produtoBoxName = 'produtos';

  // ----------------------------------------------------
  // MÉTODOS CRUD
  // ----------------------------------------------------

  // CREATE (Criar/Adicionar)
  Future<void> adicionarProduto(Produto produto) async {
    final box = await Hive.openBox<Produto>(_produtoBoxName);
    // O HiveObject.save() salva ou atualiza o objeto no banco de dados.
    await box.add(produto);
  }

  // READ (Listar Todos)
  Future<List<Produto>> listarTodosProdutos() async {
    final box = await Hive.openBox<Produto>(_produtoBoxName);
    // Retorna todos os objetos da Box como uma lista.
    return box.values.toList();
  }

  // UPDATE (Atualizar)
  Future<void> atualizarProduto(Produto produto) async {
    // Como o Produto herda de HiveObject, ele já tem a chave (key)
    // Se você usa o método .save() em um objeto que já existe, ele o atualiza.
    await produto.save();
  }

  // DELETE (Excluir)
  Future<void> excluirProduto(Produto produto) async {
    // Usa o método .delete() do HiveObject para remover o item da Box.
    await produto.delete();
  }

  // Método de Lógica (Exemplo para requisito de Alerta)
  Future<List<Produto>> listarProdutosComEstoqueBaixo() async {
    final box = await Hive.openBox<Produto>(_produtoBoxName);
    // Filtra a lista de produtos usando o método 'precisaRepor' do modelo POO.
    return box.values.where((p) => p.precisaRepor).toList();
  }
}

/*
Princípios Aplicados:
1. POO (Abstração): O usuário do Repositório (o ViewModel) não precisa saber se estamos usando Hive, SQLite ou uma API REST. Ele apenas chama 'listarTodosProdutos()'.
2. Arquitetura Modular: O acesso a dados está isolado nesta camada 'services'.
*/