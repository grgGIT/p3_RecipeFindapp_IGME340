import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipefind/main.dart'; // Adjust the import to your main app file

void main() {
  testWidgets('Search bar and recipe list test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const RecipeApp());

    // Verify that the search bar is present.
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the initial list of recipes is empty or has a specific item.
    // Adjust the following line based on your app's initial state.
    expect(find.text('No recipes found'), findsOneWidget);

    // Optionally, simulate a search action.
    await tester.enterText(find.byType(TextField), 'Chicken');
    await tester.pump();

    // Verify that the list updates with search results.
    // Adjust the following line based on expected search results.
    expect(find.text('Chicken Recipe'), findsWidgets);
  });
}