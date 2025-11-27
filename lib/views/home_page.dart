// lib/views/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/auth_viewmodel.dart'; 
import 'package:controle_estoque_app/views/login_page.dart';

// Importa apenas as telas separadas para o BottomNavigationBar
import 'package:controle_estoque_app/views/product_list_page.dart';
import 'package:controle_estoque_app/views/stock_alert_page.dart';
import 'package:controle_estoque_app/views/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Lista de instâncias das telas importadas
  final List<Widget> _pages = const [
    ProductListPage(), // 0. Listagem de Produtos (CRUD)
    StockAlertPage(),  // 1. Alertas de Estoque Baixo
    SettingsPage(),    // 2. Configurações/Logout
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o AuthViewModel para reagir ao Logout
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Redireciona para o Login se o usuário fizer Logout (Requisito: Autenticação)
    if (!authViewModel.estaLogado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Usa pushReplacement para remover a HomePage da pilha
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
      return const SizedBox.shrink(); // Retorna vazio enquanto redireciona
    }

    return Scaffold(
      // Exibe a tela selecionada
      body: _pages[_selectedIndex],
      
      // Requisito: Menu principal / Navegação entre telas (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Estoque'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber), label: 'Alertas'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}