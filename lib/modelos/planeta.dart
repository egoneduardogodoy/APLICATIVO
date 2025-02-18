class Planeta {
  int? id;
  String nome;
  double tamanho;
  double distancia;
  String? apelido;

  // Construtor de Planeta
  Planeta({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    required this.apelido,
  });

  // Construtor Alternativo
  Planeta.vazio()
      : id = null,
        nome = '',
        tamanho = 0.0,
        distancia = 0.0,
        apelido = '';

  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      nome: map['nome'],
      tamanho: map['tamanho'],
      distancia: map['distancia'],
      apelido: map['apelido'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tamanho': tamanho,
      'distancia': distancia,
      'apelido': apelido,
    };
  }
}
