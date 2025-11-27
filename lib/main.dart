// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

// NOVO: Import necessário para checar se a plataforma é Web (kIsWeb)
import 'package:flutter/foundation.dart'; 

// Importando as classes da sua arquitetura modular
import 'package:controle_estoque_app/models/produto.dart';
import 'package:controle_estoque_app/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque_app/viewmodels/auth_viewmodel.dart';
import 'package:controle_estoque_app/views/login_page.dart';

void main() async {
  // Garante que o Flutter esteja inicializado antes de qualquer inicialização de terceiros
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. INICIALIZAÇÃO DO HIVE (Persistência de Dados)
  try {
    // CORREÇÃO FINAL: Usa kIsWeb para verificar a plataforma Web.
    // Se NÃO for Web (ou seja, for Android, Windows, etc.), usa path_provider.
    if (!kIsWeb) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    } else {
      // Para Web (Chrome/Edge): Inicializa o Hive sem usar path_provider
      await Hive.initFlutter(); 
    }
    
    // 2. REGISTRO DOS ADAPTERS DO HIVE
    if (!Hive.isAdapterRegistered(0)) {
       // O 'ProdutoAdapter()' é gerado pelo build_runner no produto.g.dart.
       Hive.registerAdapter(ProdutoAdapter());
    }
    
  } catch (e) {
    // Tratamento de erro limpo
    debugPrint('ERRO NA INICIALIZAÇÃO DO HIVE: $e');
  }

  runApp(
    // 3. CONFIGURAÇÃO DO CONTROLE DE ESTADO (PROVIDER)
    MultiProvider(
      providers: [
        // ViewModel de Estoque (Lógica de CRUD)
        ChangeNotifierProvider(
          create: (_) => ProdutoViewModel()..carregarProdutos(),
        ),
        // ViewModel de Autenticação (Lógica de Login/Estado do Usuário)
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
      ],
      child: const ControleEstoqueApp(),
    ),
  );
}

class ControleEstoqueApp extends StatelessWidget {
  const ControleEstoqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Controle de Estoque',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      // Tela inicial: Cumpre o requisito da "Tela de Login"
      home: const LoginPage(), 
    );
  }
}