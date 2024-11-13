import 'package:camera/camera.dart';

class Item {
  String name;
  DateTime? date;
  double payment = 0.0;
  String? frequency;
  XFile? image;
  bool isComplete = false; 
  DateTime? originalDate;

  Item(
      {required this.name,
      required this.date,
      required this.payment,
      this.image,
      this.frequency
    }) {
    originalDate = date;  // Initialize originalDate in constructor
  }

  Item copyWithNewDate(DateTime newDate) {
    return Item(
      name: name,
      date: newDate,
      payment: payment,
      frequency: frequency,
      image: image,
    );
  }

  DateTime? getNextDate() {
    if (date == null || frequency == null) return null;
    
    switch (frequency) {
      case "Daily":
        return date!.add(const Duration(days: 1));
      case "Weekly":
        return date!.add(const Duration(days: 7));
      case "Biweekly":
        return date!.add(const Duration(days: 14));
      case "Monthly":
        return DateTime(
          date!.year,
          date!.month + 1,
          date!.day
        );
      default:
        return null;
    }
  }

  List<DateTime> getFutureOccurrences() {
    List<DateTime> dates = [];
    if (frequency == null) return dates;

    DateTime? currentDate = date;
    // Calculate next 12 months of occurrences
    for(int i = 0; i < 12; i++) {
      if (currentDate != null) {
        print("Calculating occurrence: ${currentDate.toString()}");
        dates.add(currentDate);
        currentDate = getNextDate();
      }
    }
    print("Found ${dates.length} future occurrences");
    return dates;
  }
}
