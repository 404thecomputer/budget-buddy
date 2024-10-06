// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:budget_buddy/dialogs/add_dialog.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:budget_buddy/pages/item_calendar_view.dart';
import 'package:budget_buddy/widgets/budget_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_buddy/main.dart';
import 'package:money_formatter/money_formatter.dart';

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

  testWidgets('Clicking button shows CalendarView',
      (WidgetTester tester) async {
    //Get a specific camera from the list of available cameras
    //final firstCamera = cameras.first;

    // await tester.pumpWidget(MainNavigator(camera: Placeholder()));
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: MainNavigator(camera: Placeholder()))));

    final textFinder = find.text("Calendar View");

    expect(textFinder, findsOne);

    await tester.tap(textFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ItemCalendarView), findsOne);
  });

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
    await tester.enterText(find.byKey(const Key("BillNameTextField")), "Visa");
    // //Date uses a date picker so i don't have to test that
    await tester.enterText(find.byKey(const Key("AmountTextField")), "700");
    final buttonFinder = find.byKey(const Key("OKButton"));
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // textFinder = find.text(text)
    final nameFinder = find.text("Visa");

    Item item = Item(name: "name", date: DateTime(2022), payment: 700);
    MoneyFormatter fmf = MoneyFormatter(amount: item.payment);
    String fo = fmf.output.symbolOnLeft;
    final amountFinder = find.textContaining(fo);

    expect(find.byType(BudgetItem), findsNWidgets(2));
    expect(nameFinder, findsOne);
    expect(amountFinder, findsOne);
  });
}
