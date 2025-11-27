// lib/views/stock_alert_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/produto_viewmodel.dart';
// Note: O modelo Produto é implicitamente acessado via ViewModel

class StockAlertPage extends StatelessWidget {
  const StockAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta o ViewModel para obter o estado atual dos produtos
    final produtoViewModel = Provider.of<ProdutoViewModel>(context);
    
    // Filtra a lista usando o método 'precisaRepor' definido no Modelo/ViewModel.
    final produtosEmAlerta = produtoViewModel.produtos.where((p) => p.precisaRepor).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos com Estoque Baixo'),
        backgroundColor: Colors.red.shade800, // Altera a cor para indicar alerta
        foregroundColor: Colors.white,
      ),
      body: produtosEmAlerta.isEmpty
          ? const Center(
              child: Text(
                '🎉 Nenhum produto precisa de reposição!',
                style: TextStyle(fontSize: 18, color: Colors.teal),
              ),
            )
          : ListView.builder(
              itemCount: produtosEmAlerta.length,
              itemBuilder: (context, index) {
                final produto = produtosEmAlerta[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.red.shade100, // Fundo vermelho claro
                  child: ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: Text(produto.nome, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    subtitle: Text('Estoque Atual: ${produto.quantidadeEstoque} (Mínimo: ${produto.estoqueMinimo})'),
                    // Navegação Opcional para Edição, se necessário
                    // onTap: () {
                    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProdutoFormPage(produto: produto)));
                    // },
                  ),
                );
              },
            ),
    );
  }
}