import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/produto_viewmodel.dart';


class StockAlertPage extends StatelessWidget {
  const StockAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final produtoViewModel = Provider.of<ProdutoViewModel>(context);
    
    
    final produtosEmAlerta = produtoViewModel.produtos.where((p) => p.precisaRepor).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos com Estoque Baixo'),
        backgroundColor: Colors.red.shade800, 
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
                  color: Colors.red.shade100, 
                  child: ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: Text(produto.nome, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    subtitle: Text('Estoque Atual: ${produto.quantidadeEstoque} (Mínimo: ${produto.estoqueMinimo})'),
                    
                  ),
                );
              },
            ),
    );
  }
}