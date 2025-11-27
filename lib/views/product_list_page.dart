import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque_app/views/produto_form_page.dart'; 

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final produtoViewModel = Provider.of<ProdutoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos no Estoque'),
        backgroundColor: Colors.teal,
      ),
      
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
                
                
                final bool precisaRepor = produto.precisaRepor;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  
                  color: precisaRepor ? Colors.red.shade50 : Colors.white,
                  child: ListTile(
                    title: Text(
                      produto.nome, 
                      style: TextStyle(fontWeight: FontWeight.bold, color: precisaRepor ? Colors.red.shade800 : Colors.black)
                    ),
                    subtitle: Text('Estoque: ${produto.quantidadeEstoque} | Preço: R\$ ${produto.precoVenda.toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    
                    
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          
                          builder: (context) => ProdutoFormPage(produto: produto),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
             
              builder: (context) => const ProdutoFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}