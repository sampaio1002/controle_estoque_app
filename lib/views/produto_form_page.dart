// lib/views/produto_form_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque_app/models/produto.dart';

class ProdutoFormPage extends StatefulWidget {
  // Se for null, é Cadastro; se tiver valor, é Edição.
  final Produto? produto; 
  
  const ProdutoFormPage({super.key, this.produto});

  @override
  State<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para Tratamento de Erros e Validação de Entradas
  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _precoController;
  late final TextEditingController _quantidadeController;
  late final TextEditingController _minimoController;

  bool get isEditing => widget.produto != null;

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com os valores do produto (se estiver editando)
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
  
  // --------------------------------------------------------------------------
  // Lógica CRUD (Cadastro/Edição)
  // --------------------------------------------------------------------------
  void _salvarProduto() async {
    // Requisito: Tratamento de erros e validação de entradas
    if (!_formKey.currentState!.validate()) return;
    
    final viewModel = Provider.of<ProdutoViewModel>(context, listen: false);

    final novoOuAtualizadoProduto = Produto(
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      // Validação de Entradas: Converte texto para double/int
      precoVenda: double.tryParse(_precoController.text) ?? 0.0,
      quantidadeEstoque: int.tryParse(_quantidadeController.text) ?? 0,
      estoqueMinimo: int.tryParse(_minimoController.text) ?? 0,
    );

    if (isEditing) {
      // Atualiza o objeto existente com os novos valores
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

  // Lógica CRUD (Exclusão)
  void _excluirProduto() async {
    final viewModel = Provider.of<ProdutoViewModel>(context, listen: false);
    
    // Confirmação antes de excluir (Boa Prática de Desenvolvimento Mobile)
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
        Navigator.of(context).pop(); // Volta para a lista
      }
    }
  }

  // --------------------------------------------------------------------------
  // UI (Interface Responsiva)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Cadastrar Produto'),
        backgroundColor: Colors.teal,
        actions: [
          // Botão de Excluir, visível apenas no modo Edição
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
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) => value == null || value.isEmpty ? 'O nome é obrigatório.' : null,
              ),
              // Campo Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              // Campo Preço
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço de Venda (R\$)'),
                keyboardType: TextInputType.number,
                // Validação de Entradas: verifica se é um número
                validator: (value) => double.tryParse(value ?? '') == null ? 'Insira um preço válido.' : null,
              ),
              // Campo Quantidade em Estoque
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(labelText: 'Quantidade em Estoque'),
                keyboardType: TextInputType.number,
                 // Validação de Entradas: verifica se é um número inteiro
                validator: (value) => int.tryParse(value ?? '') == null ? 'Insira uma quantidade inteira.' : null,
              ),
              // Campo Estoque Mínimo (Alerta)
              TextFormField(
                controller: _minimoController,
                decoration: const InputDecoration(labelText: 'Estoque Mínimo para Alerta'),
                keyboardType: TextInputType.number,
                 // Validação de Entradas: verifica se é um número inteiro
                validator: (value) => int.tryParse(value ?? '') == null ? 'Insira uma quantidade inteira.' : null,
              ),
              const SizedBox(height: 30),
              
              // Botão Salvar
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