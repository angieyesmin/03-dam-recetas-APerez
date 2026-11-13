import 'package:flutter/material.dart';

import '../models/resena.dart';
import '../data/resenas_db.dart';

class FormularioResenaScreen extends StatefulWidget {
  final int recetaId;
  final Resena? resena;

  const FormularioResenaScreen({
    super.key,
    required this.recetaId,
    this.resena,
  });

  @override
  State<FormularioResenaScreen> createState() =>
      _FormularioResenaScreenState();
}

class _FormularioResenaScreenState
    extends State<FormularioResenaScreen> {

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usuarioCtrl;
  late final TextEditingController _comentarioCtrl;

  int _calificacion = 5;

  bool get _esEdicion => widget.resena != null;

  @override
  void initState() {
    super.initState();

    _usuarioCtrl = TextEditingController(
      text: widget.resena?.usuario ?? '',
    );

    _comentarioCtrl = TextEditingController(
      text: widget.resena?.comentario ?? '',
    );

    _calificacion = widget.resena?.calificacion ?? 5;
  }

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _comentarioCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final resena = Resena(
      id: widget.resena?.id,
      recetaId: widget.recetaId,
      usuario: _usuarioCtrl.text.trim(),
      comentario: _comentarioCtrl.text.trim(),
      calificacion: _calificacion,
      fecha: widget.resena?.fecha ??
          DateTime.now().toIso8601String(),
    );

    if (_esEdicion) {
      await ResenasDb.instancia.actualizar(resena);
    } else {
      await ResenasDb.instancia.insertar(resena);
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _esEdicion ? 'Editar reseña' : 'Nueva reseña',
        ),
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [

            TextFormField(
              controller: _usuarioCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Tu nombre',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty
                      ? 'Escribe tu nombre'
                      : null,
            ),

            const SizedBox(height: 20),

            const Text(
              'Califica esta receta',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _calificacion = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _calificacion
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 35,
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _comentarioCtrl,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Escribe tu reseña',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.comment),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().length < 5
                      ? 'Escribe al menos 5 caracteres'
                      : null,
            ),

            const SizedBox(height: 25),

            FilledButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save),
              label: Text(
                _esEdicion
                    ? 'Guardar cambios'
                    : 'Publicar reseña',
              ),
            ),
          ],
        ),
      ),
    );
  }
}