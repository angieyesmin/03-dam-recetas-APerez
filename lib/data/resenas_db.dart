import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/resena.dart';

class ResenasDb {
  ResenasDb._();

  static final ResenasDb instancia = ResenasDb._();

  static const _nombreArchivo = 'resenas.db';
  static const _tabla = 'resenas';

  Database? _db;

  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);

    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tabla (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recetaId INTEGER NOT NULL,
            usuario TEXT NOT NULL,
            comentario TEXT NOT NULL,
            calificacion INTEGER NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CONSULTAR RESEÑAS DE UNA RECETA
  Future<List<Resena>> obtenerPorReceta(int recetaId) async {
    final db = await _database;

    final resultado = await db.query(
      _tabla,
      where: 'recetaId = ?',
      whereArgs: [recetaId],
      orderBy: 'id DESC',
    );

    return resultado.map((map) => Resena.fromMap(map)).toList();
  }

  // INSERTAR RESEÑA
  Future<int> insertar(Resena resena) async {
    final db = await _database;

    return await db.insert(_tabla, resena.toMap());
  }

  // ACTUALIZAR RESEÑA
  Future<int> actualizar(Resena resena) async {
    final db = await _database;

    return await db.update(
      _tabla,
      resena.toMap(),
      where: 'id = ?',
      whereArgs: [resena.id],
    );
  }

  // ELIMINAR RESEÑA
  Future<int> eliminar(int id) async {
    final db = await _database;

    return await db.delete(
      _tabla,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}