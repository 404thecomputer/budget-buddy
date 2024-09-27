import 'package:budget_buddy/dialogs/take_picture_screen.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:budget_buddy/pages/item_calendar_view.dart';
import 'package:budget_buddy/pages/item_list_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  //Obtain a list of the available cameras on the device
  final cameras = await availableCameras();

  //Get a specific camera from the list of available cameras
  final firstCamera = cameras.first;
  runApp(MyApp(
    firstCamera: firstCamera,
  ));
}

class MyApp extends StatelessWidget {
  final firstCamera;
  const MyApp({super.key, required this.firstCamera});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Buddy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: MainNavigator(
        camera: firstCamera,
      ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  final camera;
  const MainNavigator({super.key, required this.camera});

  @override
  State<StatefulWidget> createState() {
    return MainNavigatorState();
  }
}

class MainNavigatorState extends State<MainNavigator> {
  late List<Item> items = [];
  int currentIndex = 0;
  DateTime? selectedDay;

  void _handleNewItem(Item item) {
    setState(() {
      items.add(item);
      if (item.frequency == "Daily") {
        int i = 1;
        while (i < 365) {
          Item newItem = Item(name: item.name, date: item.date, frequency: item.frequency, payment: item.payment);
          DateTime newDate = DateTime(item.date!.year, item.date!.month, item.date!.day + (i));
          newItem.date = newDate;
          items.add(newItem);
          i++;
        }
      }
      if (item.frequency == "Weekly") {
        int i = 1;
        while (i < 52) {
          Item newItem = Item(name: item.name, date: item.date, frequency: item.frequency, payment: item.payment);
          DateTime newDate = DateTime(item.date!.year, item.date!.month, item.date!.day + (7 * i));
          newItem.date = newDate;
          items.add(newItem);
          i++;
        }
      }
      if (item.frequency == "Biweekly") {
        int i = 1;
        while (i < 26) {
          Item newItem = Item(name: item.name, date: item.date, frequency: item.frequency, payment: item.payment);
          DateTime newDate = DateTime(item.date!.year, item.date!.month, item.date!.day + (14 * i));
          newItem.date = newDate;
          items.add(newItem);
          i++;
        }
      }
      if (item.frequency == "Monthly") {
        int i = 1;
        while (i < 12) {
          Item newItem = Item(name: item.name, date: item.date, frequency: item.frequency, payment: item.payment);
          DateTime newDate = DateTime(item.date!.year, item.date!.month + i, item.date!.day);
          newItem.date = newDate;
          items.add(newItem);
          i++;
        }
      }
      items.sort((a, b) => a.date!.compareTo(b.date!));
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      items.remove(item);
    });
  }

  List<Item> _getItemsForSelectedDay(DateTime day) {
    return items.where((item) => isSameDay(item.date, day)).toList();
  }

  @override
  void initState() {
    items = [Item(name: "Bill 5", date: DateTime.now(), payment: 150.0, frequency: "Monthly")];
    super.initState();
  }

  Widget returnScreen(int screenIndex) {
    if (screenIndex == 0) {
      //   return TakePictureScreen(camera: widget.camera);
      // }
      // if (screenIndex == 1) {
      return ItemCalendarView(
        items: items,
        selectedDay: selectedDay,
        onListChanged: _handleNewItem,
        onDeleteItem: _handleDeleteItem,
        cam: widget.camera,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            this.selectedDay = selectedDay;
            currentIndex = 1; // Switch to list view when day selected
          });
        },
      );
    } else {
      return ItemListView(
          items: selectedDay != null
              ? _getItemsForSelectedDay(selectedDay!)
              : items,
          onListChanged: _handleNewItem,
          cam: widget.camera,
          onDeleteItem: _handleDeleteItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: returnScreen(currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: "Calendar View"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "List View"),
          ],
          onTap: (i) {
            setState(() {
              currentIndex = i;
            });
          },
          currentIndex: currentIndex,
          selectedItemColor: Colors.green,
        ));
  }
}
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() {
//     return _MyHomePageState();
//   }
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
