class Resena {
  final int? id;
  final int recetaId;
  final String usuario;
  final String comentario;
  final int calificacion;
  final String fecha;

  const Resena({
    this.id,
    required this.recetaId,
    required this.usuario,
    required this.comentario,
    required this.calificacion,
    required this.fecha,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'recetaId': recetaId,
      'usuario': usuario,
      'comentario': comentario,
      'calificacion': calificacion,
      'fecha': fecha,
    };
  }

  factory Resena.fromMap(Map<String, Object?> map) {
    return Resena(
      id: map['id'] as int?,
      recetaId: map['recetaId'] as int,
      usuario: map['usuario'] as String,
      comentario: map['comentario'] as String,
      calificacion: map['calificacion'] as int,
      fecha: map['fecha'] as String,
    );
  }
}