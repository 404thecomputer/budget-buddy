// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:budget_buddy/dialogs/add_dialog.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:budget_buddy/pages/item_list_view.dart';
import 'package:budget_buddy/widgets/budget_item.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budget_buddy/main.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  testWidgets('Clicking button shows listView', (WidgetTester tester) async {
    //Get a specific camera from the list of available cameras
    //final firstCamera = cameras.first;

    // await tester.pumpWidget(MainNavigator(camera: Placeholder()));
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: MainNavigator(camera: Placeholder()))));

    final textFinder = find.text("List View");

    expect(textFinder, findsOne);

    await tester.tap(textFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOne);
  });

  testWidgets("There is one default item", (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: MainNavigator(camera: Placeholder()))));

    final textFinder = find.text("List View");
    await tester.tap(textFinder);
    await tester.pumpAndSettle();

    final itemFinder = find.byType(BudgetItem);
    expect(itemFinder, findsOne);
  });

  testWidgets("Clicking the add button brings up a dialog", (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: MainNavigator(camera: Placeholder))));

    final textFinder = find.text("List View");
    await tester.tap(textFinder);
    await tester.pumpAndSettle();
    final floatingButtonFinder = find.byType(FloatingActionButton);
    await tester.tap(floatingButtonFinder);
    await tester.pumpAndSettle();

    final dialogFinder = find.byType(ItemDialog);
    expect(dialogFinder, findsOne);
  });

  testWidgets("Typing in dialog fields and adding item works", (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: MainNavigator(camera: Placeholder))));

    var textFinder = find.text("List View");
    await tester.tap(textFinder);
    await tester.pumpAndSettle();
    final floatingButtonFinder = find.byType(FloatingActionButton);
    await tester.tap(floatingButtonFinder);
    await tester.pumpAndSettle();
    textFinder = find.text("Bill Name");
    tester.enterText(textFinder, "Visa");
    //Date uses a date picker so i don't have to test that
    textFinder = find.text("Amount");
    tester.enterText(textFinder, "700");
    final buttonFinder = find.byKey(const Key("OKButton"));
    tester.tap(buttonFinder);
    tester.pumpAndSettle();

    // textFinder = find.text(text)
  });
}
