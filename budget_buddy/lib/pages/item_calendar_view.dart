import 'package:budget_buddy/dialogs/add_dialog.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:budget_buddy/pages/item_list_view.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';

typedef ItemsListChangedCallback = Function(Item item);

class ItemCalendarView extends StatefulWidget {
  const ItemCalendarView({
    required this.items,
    this.selectedDay,
    required this.onDaySelected,
    super.key,
    required this.onListChanged,
    required this.onDeleteItem,
    required this.onCompleteItem,
    required this.cam,
  });

  final List<Item> items;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final ItemsListChangedCallback onListChanged;
  final ItemsListDeletedCallback onDeleteItem;
  final Function(Item) onCompleteItem;
  final cam;

  @override
  _ItemCalendarViewState createState() => _ItemCalendarViewState();
}

class _ItemCalendarViewState extends State<ItemCalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Buddy"),
        centerTitle: true,
      ),
      body: TableCalendar(
        shouldFillViewport: true,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        eventLoader: (day) {
          List<Item> dayItems = widget.items
              .where((item) => isSameDay(item.date, day))
              .toList();

          for (var item in widget.items) {
            if (!item.isComplete && item.frequency != null) {
              // Get all future dates for this recurring item
              List<DateTime> futureDates = item.getFutureOccurrences();
              
              // If this day matches any future occurrence
              if (futureDates.any((date) => isSameDay(date, day))) {
                // add if we dont already have this item
                if (!dayItems.contains(item)) {
                  dayItems.add(item);
                }
              }
            }
          }
          return dayItems;
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onDayLongPressed: (selectedDay, focusedDay) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemListView(
                items: widget.items
                    .where((item) => isSameDay(item.date, selectedDay))
                    .toList(),
                onListChanged: widget.onListChanged,
                onDeleteItem: widget.onDeleteItem,
                onCompleteItem: widget.onCompleteItem,
                cam: widget.cam,
              ),
            ),
          );
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return ItemDialog(
                    onListChanged: widget.onListChanged, cam: widget.cam);
              });
        },
        tooltip: "Add New Item",
        child: const Icon(Icons.add),
      ),
    );
  }
}
