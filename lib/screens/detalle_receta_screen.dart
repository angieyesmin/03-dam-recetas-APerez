import 'package:flutter/material.dart';

import 'package:app_recetas/models/receta.dart';
import 'package:app_recetas/models/resena.dart';
import 'package:app_recetas/data/resenas_db.dart';
import 'package:app_recetas/screens/formulario_resena_screen.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({
    super.key,
    required this.receta,
  });

  @override
  State<DetalleRecetaScreen> createState() =>
      _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {

  List<Resena> _resenas = [];

  bool _cargandoResenas = true;

  @override
  void initState() {
    super.initState();
    _cargarResenas();
  }

  // ==========================================
  // CARGAR RESEÑAS DE LA RECETA
  // ==========================================

  Future<void> _cargarResenas() async {

    final resultado = await ResenasDb.instancia.obtenerPorReceta(
      widget.receta.id,
    );

    if (!mounted) return;

    setState(() {
      _resenas = resultado;
      _cargandoResenas = false;
    });
  }

  // ==========================================
  // ABRIR FORMULARIO PARA AGREGAR O EDITAR
  // ==========================================

  Future<void> _abrirFormulario([Resena? existente]) async {

    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioResenaScreen(
          recetaId: widget.receta.id,
          resena: existente,
        ),
      ),
    );

    if (guardado == true) {

      await _cargarResenas();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existente == null
                ? 'Reseña publicada correctamente'
                : 'Reseña actualizada correctamente',
          ),
        ),
      );
    }
  }

  // ==========================================
  // ELIMINAR RESEÑA
  // ==========================================

  Future<void> _confirmarEliminar(Resena resena) async {

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar reseña'),
        content: const Text(
          '¿Deseas eliminar esta reseña?',
        ),
        actions: [

          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),

          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),

        ],
      ),
    );

    if (confirmar == true && resena.id != null) {

      await ResenasDb.instancia.eliminar(resena.id!);

      if (!mounted) return;

      await _cargarResenas();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reseña eliminada correctamente'),
        ),
      );
    }
  }

  // ==========================================
  // CONSTRUIR ESTRELLAS
  // ==========================================

  Widget _mostrarEstrellas(int calificacion) {

    return Row(
      children: List.generate(5, (index) {

        return Icon(
          index < calificacion
              ? Icons.star
              : Icons.star_border,
          color: Colors.orange,
          size: 20,
        );

      }),
    );
  }

  // ==========================================
  // TARJETA DE RESEÑA
  // ==========================================

  Widget _tarjetaResena(Resena resena) {

    DateTime? fecha;

    try {
      fecha = DateTime.parse(resena.fecha);
    } catch (_) {
      fecha = null;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                const CircleAvatar(
                  backgroundColor: Color(0xFF1565C0),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        resena.usuario,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      Text(
                        fecha == null
                            ? resena.fecha
                            : '${fecha.day}/${fecha.month}/${fecha.year}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),

                    ],
                  ),
                ),

                _mostrarEstrellas(resena.calificacion),

              ],
            ),

            const SizedBox(height: 12),

            Text(
              resena.comentario,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [

                TextButton.icon(
                  onPressed: () => _abrirFormulario(resena),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Editar'),
                ),

                TextButton.icon(
                  onPressed: () => _confirmarEliminar(resena),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }

  // ==========================================
  // SECCIÓN DE RESEÑAS
  // ==========================================

  Widget _seccionResenas() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        const Text(
          'Reseñas de esta receta',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,

          child: FilledButton.icon(
            onPressed: () => _abrirFormulario(),

            icon: const Icon(Icons.rate_review),

            label: const Text('Agregar reseña'),

            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),

        const SizedBox(height: 20),

        if (_cargandoResenas)

          const Center(
            child: CircularProgressIndicator(),
          )

        else if (_resenas.isEmpty)

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Column(
              children: [

                Icon(
                  Icons.rate_review_outlined,
                  size: 45,
                  color: Colors.grey,
                ),

                SizedBox(height: 10),

                Text(
                  'Todavía no hay reseñas.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  '¡Sé el primero en compartir tu opinión!',
                  textAlign: TextAlign.center,
                ),

              ],
            ),
          )

        else

          ..._resenas.map(
            (resena) => _tarjetaResena(resena),
          ),

      ],
    );
  }

  // ==========================================
  // PANTALLA PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {

    final receta = widget.receta;

    return Scaffold(

      backgroundColor: const Color(0xFFE3F2FD),

      appBar: AppBar(
        title: const Text(
          "Detalle de la receta",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          // IMAGEN DE LA RECETA

          ClipRRect(
            borderRadius: BorderRadius.circular(14),

            child: Image.network(
              receta.imagenUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stack) =>
                  Container(
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
            ),
          ),

          const SizedBox(height: 16),

          // NOMBRE

          Text(
            receta.nombre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),

          const SizedBox(height: 12),

          // INFORMACIÓN

          Wrap(
            spacing: 10,
            runSpacing: 8,

            children: [

              Chip(
                avatar: const Icon(Icons.timer, size: 18),
                label: Text('${receta.tiempoTotal} min'),
              ),

              Chip(
                avatar: const Icon(
                  Icons.local_fire_department,
                  size: 18,
                ),
                label: Text('${receta.calorias} kcal'),
              ),

              Chip(
                avatar: const Icon(Icons.restaurant, size: 18),
                label: Text('${receta.porciones} porciones'),
              ),

              Chip(
                avatar: const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 18,
                ),
                label: Text(
                  receta.calificacion.toStringAsFixed(1),
                ),
              ),

            ],
          ),

          const SizedBox(height: 20),

          // INGREDIENTES

          const Text(
            "Ingredientes:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),

          const SizedBox(height: 10),

          ...receta.ingredientes.map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Icon(
                    Icons.circle,
                    size: 8,
                    color: Color(0xFF1565C0),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      ingrediente,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // PREPARACIÓN

          const Text(
            "Preparación:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),

          const SizedBox(height: 12),

          ...receta.instrucciones.asMap().entries.map(
            (entrada) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF1565C0),

                    child: Text(
                      '${entrada.key + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      entrada.value,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ==================================
          // RESEÑAS
          // ==================================

          _seccionResenas(),

          const SizedBox(height: 30),

        ],
      ),
    );
  }
}