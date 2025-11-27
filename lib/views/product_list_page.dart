// lib/views/product_list_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque_app/models/produto.dart';
import 'package:controle_estoque_app/views/produto_form_page.dart'; // Tela para CRUD (Cadastro/Edição)

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta o ViewModel para obter a lista de produtos (Controle de Estado)
    final produtoViewModel = Provider.of<ProdutoViewModel>(context);

    // O Scaffold aqui define a AppBar para a aba 'Estoque'
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos no Estoque'),
        backgroundColor: Colors.teal,
      ),
      
      // Requisito: Listagem e Detalhamento de Itens (ListView)
      body: produtoViewModel.produtos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum produto cadastrado. Clique no + para adicionar.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: produtoViewModel.produtos.length,
              itemBuilder: (context, index) {
                final produto = produtoViewModel.produtos[index];
                
                // Verifica se precisa de reposição para mudar a cor do card
                final bool precisaRepor = produto.precisaRepor;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  // Se precisar de reposição, destaca o card em vermelho claro
                  color: precisaRepor ? Colors.red.shade50 : Colors.white,
                  child: ListTile(
                    title: Text(
                      produto.nome, 
                      style: TextStyle(fontWeight: FontWeight.bold, color: precisaRepor ? Colors.red.shade800 : Colors.black)
                    ),
                    subtitle: Text('Estoque: ${produto.quantidadeEstoque} | Preço: R\$ ${produto.precoVenda.toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    
                    // Requisito: Detalhamento de Itens / Edição
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          // Passa o produto para a tela de formulário para edição
                          builder: (context) => ProdutoFormPage(produto: produto),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      
      // Requisito: Cadastro, edição e exclusão de registros (Botão de Adição)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              // Abre a tela de formulário sem produto (Modo Cadastro)
              builder: (context) => const ProdutoFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}