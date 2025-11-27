import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';


import 'package:flutter/foundation.dart'; 

import 'package:controle_estoque_app/models/produto.dart';
import 'package:controle_estoque_app/viewmodels/produto_viewmodel.dart';
import 'package:controle_estoque_app/viewmodels/auth_viewmodel.dart';
import 'package:controle_estoque_app/views/login_page.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  
  try {
    
    if (!kIsWeb) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    } else {
      
      await Hive.initFlutter(); 
    }
    
    
    if (!Hive.isAdapterRegistered(0)) {
       
       Hive.registerAdapter(ProdutoAdapter());
    }
    
  } catch (e) {
    
    debugPrint('ERRO NA INICIALIZAÇÃO DO HIVE: $e');
  }

  runApp(
    
    MultiProvider(
      providers: [
        
        ChangeNotifierProvider(
          create: (_) => ProdutoViewModel()..carregarProdutos(),
        ),
        
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
      
      home: const LoginPage(), 
    );
  }
}