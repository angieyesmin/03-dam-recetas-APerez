import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_recetas/main.dart';

void main() {
  testWidgets(
    'La aplicación Recetas del Mayab inicia correctamente',
    (WidgetTester tester) async {

      await tester.pumpWidget(const RecetasApp());

      // Verificar el nombre de la aplicación
      expect(find.text('Recetas App'), findsOneWidget);

      // Verificar el subtítulo
      expect(find.text('Sabores del mayab'), findsOneWidget);

      // Verificar el indicador de carga
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}