// lib/models/produto.dart

import 'package:hive/hive.dart';

// O 'part' aqui diz ao Dart que o arquivo 'produto.g.dart' será gerado
part 'produto.g.dart'; 

@HiveType(typeId: 0) // ID único para o Hive
class Produto extends HiveObject {
  
  // O @HiveField(n) define o índice de cada campo
  @HiveField(0)
  String nome;

  @HiveField(1)
  String descricao;

  @HiveField(2)
  double precoVenda;

  @HiveField(3)
  int quantidadeEstoque;

  @HiveField(4)
  int estoqueMinimo;

  Produto({
    required this.nome,
    required this.descricao,
    required this.precoVenda,
    required this.quantidadeEstoque,
    required this.estoqueMinimo,
  });

  // Método de Lógica (POO)
  bool get precisaRepor {
    return quantidadeEstoque <= estoqueMinimo;
  }
}