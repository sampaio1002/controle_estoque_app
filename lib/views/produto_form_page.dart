import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque_app/models/produto.dart';

class ProdutoFormPage extends StatefulWidget {
  
  final Produto? produto; 
  
  const ProdutoFormPage({super.key, this.produto});

  @override
  State<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _precoController;
  late final TextEditingController _quantidadeController;
  late final TextEditingController _minimoController;

  bool get isEditing => widget.produto != null;

  @override
  void initState() {
    super.initState();
    
    _nomeController = TextEditingController(text: widget.produto?.nome ?? '');
    _descricaoController = TextEditingController(text: widget.produto?.descricao ?? '');
    _precoController = TextEditingController(text: widget.produto?.precoVenda.toString() ?? '');
    _quantidadeController = TextEditingController(text: widget.produto?.quantidadeEstoque.toString() ?? '');
    _minimoController = TextEditingController(text: widget.produto?.estoqueMinimo.toString() ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();
    _minimoController.dispose();
    super.dispose();
  }
  
  void _salvarProduto() async {
    
    if (!_formKey.currentState!.validate()) return;
    
    final viewModel = Provider.of<ProdutoViewModel>(context, listen: false);

    final novoOuAtualizadoProduto = Produto(
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      precoVenda: double.tryParse(_precoController.text) ?? 0.0,
      quantidadeEstoque: int.tryParse(_quantidadeController.text) ?? 0,
      estoqueMinimo: int.tryParse(_minimoController.text) ?? 0,
    );

    if (isEditing) {
      
      widget.produto!.nome = novoOuAtualizadoProduto.nome;
      widget.produto!.descricao = novoOuAtualizadoProduto.descricao;
      widget.produto!.precoVenda = novoOuAtualizadoProduto.precoVenda;
      widget.produto!.quantidadeEstoque = novoOuAtualizadoProduto.quantidadeEstoque;
      widget.produto!.estoqueMinimo = novoOuAtualizadoProduto.estoqueMinimo;
      
      await viewModel.atualizarProduto(widget.produto!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto atualizado!')));
    } else {
      await viewModel.adicionarProduto(novoOuAtualizadoProduto);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto cadastrado!')));
    }
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  
  void _excluirProduto() async {
    final viewModel = Provider.of<ProdutoViewModel>(context, listen: false);
    
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Tem certeza que deseja excluir este produto?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Não')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Sim')),
        ],
      ),
    );

    if (confirm == true && widget.produto != null) {
      await viewModel.excluirProduto(widget.produto!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto excluído!')));
      if (mounted) {
        Navigator.of(context).pop(); 
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Cadastrar Produto'),
        backgroundColor: Colors.teal,
        actions: [
          
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _excluirProduto,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) => value == null || value.isEmpty ? 'O nome é obrigatório.' : null,
              ),
              
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço de Venda (R\$)'),
                keyboardType: TextInputType.number,
                
                validator: (value) => double.tryParse(value ?? '') == null ? 'Insira um preço válido.' : null,
              ),
              
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(labelText: 'Quantidade em Estoque'),
                keyboardType: TextInputType.number,
                 
                validator: (value) => int.tryParse(value ?? '') == null ? 'Insira uma quantidade inteira.' : null,
              ),
              
              TextFormField(
                controller: _minimoController,
                decoration: const InputDecoration(labelText: 'Estoque Mínimo para Alerta'),
                keyboardType: TextInputType.number,
                 
                validator: (value) => int.tryParse(value ?? '') == null ? 'Insira uma quantidade inteira.' : null,
              ),
              const SizedBox(height: 30),
              
              
              ElevatedButton.icon(
                onPressed: _salvarProduto,
                icon: Icon(Icons.save),
                label: Text(isEditing ? 'SALVAR ALTERAÇÕES' : 'CADASTRAR PRODUTO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}