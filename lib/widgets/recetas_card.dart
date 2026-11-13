import 'package:flutter/material.dart';
import 'package:app_recetas/models/receta.dart';

class RecetaCard extends StatelessWidget {
  final Receta receta;
  final VoidCallback? onTap;

  const RecetaCard({
    super.key,
    required this.receta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la receta
            Image.network(
              receta.imagenUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.restaurant,
                    size: 60,
                    color: Colors.grey,
                  ),
                );
              },
            ),

            // Información de la receta
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receta.nombre,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF1565C0),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tiempo de preparación: ${receta.tiempoTotal} minutos',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}