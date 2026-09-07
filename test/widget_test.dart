import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_explorer/app.dart';

void main() {
  testWidgets('L\'application démarre et affiche l\'écran Explorer',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TravelExplorerApp()),
    );
    await tester.pump();

    expect(find.text('Explorer'), findsWidgets);
    expect(find.byType(BottomNavigationBar), findsNothing); // on utilise NavigationBar
  });
}
