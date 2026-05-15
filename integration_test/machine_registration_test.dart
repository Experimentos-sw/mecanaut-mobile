import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mecanaut_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('RenderFlex overflowed')) {
      return;
    }
    FlutterError.presentError(details);
  };

  testWidgets('US01 - Flujo E2E de Registro de Activos', (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    final usernameField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    final loginBtn = find.text('Iniciar Sesion').last;

    await tester.enterText(usernameField, 'pruebaadmin');
    await tester.enterText(passwordField, 'prueba123');
    await tester.pumpAndSettle();

    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Plantas'));
    await tester.pumpAndSettle();

    final newPlantBtn = find.text('Nueva Planta');
    await tester.ensureVisible(newPlantBtn);
    await tester.tap(newPlantBtn);
    await tester.pumpAndSettle();

    final timestamp = DateTime.now().millisecondsSinceEpoch % 10000;

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Planta E2E $timestamp',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Av Industrial 123',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'Lima');
    await tester.enterText(find.byType(TextFormField).at(3), 'Peru');
    await tester.enterText(find.byType(TextFormField).at(4), '+51 987654321');
    await tester.enterText(
      find.byType(TextFormField).at(5),
      'planta$timestamp@test.com',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pump();

    await _waitForWidget(tester, find.text('Planta creada correctamente.'));
    expect(find.text('Planta creada correctamente.'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lineas de Produccion'));
    await tester.pumpAndSettle();

    final newLineBtn = find.text('Nueva Linea');
    await tester.ensureVisible(newLineBtn);
    await tester.tap(newLineBtn);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Linea E2E $timestamp',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'L-$timestamp');
    await tester.enterText(find.byType(TextFormField).at(2), '150');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pump();

    await _waitForWidget(tester, find.text('Linea creada correctamente.'));
    expect(find.text('Linea creada correctamente.'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Maquinarias'));
    await tester.pumpAndSettle();

    final newMachineBtn = find.text('Nueva Maquina');
    await tester.ensureVisible(newMachineBtn);
    await tester.tap(newMachineBtn);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'M-$timestamp');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Prensa Test $timestamp',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'SN-$timestamp');
    await tester.enterText(find.byType(TextFormField).at(3), 'Acme Corp');
    await tester.enterText(find.byType(TextFormField).at(4), 'Prensa');
    await tester.pumpAndSettle();

    final modalScroll = find.byType(SingleChildScrollView).last;
    await tester.drag(modalScroll, const Offset(0, -300));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(6), '150');
    await tester.pumpAndSettle();

    final saveBtn = find.text('Guardar');
    await tester.ensureVisible(saveBtn);
    await tester.tap(saveBtn);

    await tester.pump();

    await _waitForWidget(tester, find.text('Maquinaria creada correctamente.'));
    expect(find.text('Maquinaria creada correctamente.'), findsOneWidget);
  });
}

Future<void> _waitForWidget(WidgetTester tester, Finder finder) async {
  for (int i = 0; i < 50; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
}
