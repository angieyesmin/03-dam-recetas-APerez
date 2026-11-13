class Receta {
  final int id;
  final String nombre;
  final List<String> ingredientes;
  final List<String> instrucciones;
  final int tiempoPreparacion;
  final int tiempoCoccion;
  final int porciones;
  final int calorias;
  final String imagenUrl;
  final double calificacion;

  const Receta({
    required this.id,
    required this.nombre,
    required this.ingredientes,
    required this.instrucciones,
    required this.tiempoPreparacion,
    required this.tiempoCoccion,
    required this.porciones,
    required this.calorias,
    required this.imagenUrl,
    required this.calificacion,
  });

  factory Receta.fromJson(Map<String, dynamic> json) {
    return Receta(
      id: (json['id'] as num?)?.toInt() ?? 0,

      nombre: json['name']?.toString() ?? 'Receta sin nombre',

      ingredientes: (json['ingredients'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      instrucciones: (json['instructions'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      tiempoPreparacion:
          (json['prepTimeMinutes'] as num?)?.toInt() ?? 0,

      tiempoCoccion:
          (json['cookTimeMinutes'] as num?)?.toInt() ?? 0,

      porciones:
          (json['servings'] as num?)?.toInt() ?? 1,

      calorias:
          (json['caloriesPerServing'] as num?)?.toInt() ?? 0,

      imagenUrl: json['image']?.toString() ?? '',

      calificacion:
          (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  int get tiempoTotal => tiempoPreparacion + tiempoCoccion;
}