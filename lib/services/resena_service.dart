import 'package:app_recetas/data/resenas_db.dart';
import 'package:app_recetas/models/resena.dart';

class ResenaService {
  final ResenasDb _database = ResenasDb.instancia;

  // Obtener reseñas de una receta
  Future<List<Resena>> obtenerResenas(int recetaId) async {
    return await _database.obtenerPorReceta(recetaId);
  }

  // Registrar una reseña
  Future<int> agregarResena(Resena resena) async {
    return await _database.insertar(resena);
  }

  // Actualizar una reseña
  Future<int> editarResena(Resena resena) async {
    return await _database.actualizar(resena);
  }

  // Eliminar una reseña
  Future<int> eliminarResena(int id) async {
    return await _database.eliminar(id);
  }
}