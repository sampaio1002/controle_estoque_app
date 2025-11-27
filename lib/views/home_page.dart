import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controle_estoque_app/viewmodels/auth_viewmodel.dart'; 
import 'package:controle_estoque_app/views/login_page.dart';


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

  final List<Widget> _pages = const [
    ProductListPage(), 
    StockAlertPage(),  
    SettingsPage(),    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    final authViewModel = Provider.of<AuthViewModel>(context);

    
    if (!authViewModel.estaLogado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      
      body: _pages[_selectedIndex],
      
      
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