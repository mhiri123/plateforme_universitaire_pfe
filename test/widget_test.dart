import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plateforme_universitaire/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construire notre application et déclencher une trame.
    await tester.pumpWidget(const PlatformUniversityApp());

    // Vérifier que le compteur commence à 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Appuyer sur l'icône '+' et déclencher une trame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Vérifier que le compteur a incrémenté.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
class PlatformUniversityApp extends StatelessWidget {
  const PlatformUniversityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Platform University App'),
        ),
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}

