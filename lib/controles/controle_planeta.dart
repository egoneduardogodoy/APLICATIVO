import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../modelos/planeta.dart'; // Adicionar o pacote 'path' necessário para obter o caminho do banco de dados

class ControlePlaneta {
  static Database? _db;

  Future<Database> get bd async {
    if (_db != null) return _db!;
    _db = await _initBD('planetas.db');
    return _db!;
  }

  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(
      caminho,
      version: 1,
      onCreate: _criarBD,
    );
  }

  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
      CREATE TABLE planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tamanho REAL NOT NULL,
        distancia REAL NOT NULL,
        apelido TEXT
      );
    ''';
    await bd.execute(sql);
  }

  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');

    return resultado.map((map) => Planeta.fromMap(map)).toList(); // Corrigir 'result' para 'resultado'
  }

  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.insert('planetas', planeta.toMap());
  }

  Future<int> alterarPlaneta(Planeta planeta) async {
  final db = await bd;
  return db.update(
    'planetas',
    planeta.toMap(),
    where: 'id = ?',
    whereArgs: [planeta.id],
  );
}

  // Definindo o método excluirPlaneta
  Future<void> excluirPlaneta(int id) async {
    final db = await bd;
    await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
