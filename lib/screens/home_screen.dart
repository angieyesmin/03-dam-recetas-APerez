import 'package:flutter/material.dart';
import 'package:app_recetas/models/receta.dart';
import 'package:app_recetas/services/recipe_service.dart';
import 'package:app_recetas/widgets/recetas_card.dart';
import 'package:app_recetas/screens/detalle_receta_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();

  late Future<List<Receta>> _futureRecetas;

  @override
  void initState() {
    super.initState();
    _futureRecetas = _recipeService.obtenerRecetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),

      appBar: AppBar(
        title: const Text(
          'Recetas del Mayab',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      body: FutureBuilder<List<Receta>>(
        future: _futureRecetas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1565C0),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Color(0xFF0D47A1),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error al cargar las recetas:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _futureRecetas =
                              _recipeService.obtenerRecetas();
                        });
                      },
                      child: const Text('Intentar nuevamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay recetas disponibles.',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF0D47A1),
                ),
              ),
            );
          }

          final recetas = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: recetas.length,
            itemBuilder: (context, index) {
              return RecetaCard(
                receta: recetas[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleRecetaScreen(
                        receta: recetas[index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}