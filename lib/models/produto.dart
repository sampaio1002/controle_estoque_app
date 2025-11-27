import 'package:hive/hive.dart';


part 'produto.g.dart'; 

@HiveType(typeId: 0)
class Produto extends HiveObject {
  
  
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

  
  bool get precisaRepor {
    return quantidadeEstoque <= estoqueMinimo;
  }
}