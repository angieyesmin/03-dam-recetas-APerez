import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_recetas/models/receta.dart';

class RecipeService {
  static const String apiUrl = 'https://dummyjson.com/recipes';
  Future<List<Receta>> obtenerRecetas() async {
    try {
      final Uri url = Uri.parse(apiUrl);

      final http.Response respuesta = await http.get(url);
      if (respuesta.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(respuesta.body) as Map<String, dynamic>;
        final List<dynamic> listaRecetas = data['recipes'] as List<dynamic>;
        return listaRecetas.map((recetaJson) {
          return Receta.fromJson(recetaJson as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception(
          'Error al obtener las recetas: ${respuesta.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('No se pudieron cargar las recetas: $e');
    }
  }
}
