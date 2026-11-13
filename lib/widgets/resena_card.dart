import 'package:flutter/material.dart';
import 'package:app_recetas/models/resena.dart';

class ResenaCard extends StatelessWidget {
  final Resena resena;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const ResenaCard({
    super.key,
    required this.resena,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    resena.usuario,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onEditar,
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar reseña',
                    ),
                    IconButton(
                      onPressed: onEliminar,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar reseña',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < resena.calificacion
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 22,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              resena.comentario,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 8),

            Text(
              resena.fecha.split('T').first,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}