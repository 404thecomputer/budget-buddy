import 'package:budget_buddy/dialogs/take_picture_screen.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_buddy/widgets/buttons.dart';
import 'package:budget_buddy/main.dart';

// adapted from to-dont-list code
typedef ItemsListChangedCallback = Function(Item item);
const frequencies = <String>[
  'No Repeat',
  'Daily',
  'Weekly',
  'Biweekly',
  'Monthly'
];

class ItemDialog extends StatefulWidget {
  const ItemDialog({
    super.key,
    required this.onListChanged,
    required this.cam,
  });

  final ItemsListChangedCallback onListChanged;
  final cam;

  @override
  State<ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _dateInputController = TextEditingController();
  final TextEditingController _amountInputController = TextEditingController();
  final ButtonStyle cameraStyle =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  String billName = "";
  String textString = "";
  DateTime? moment = DateTime.now();
  double amount = 0.0;
  XFile? img;
  String dropdownValue = frequencies.first;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Add New Item')),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        TextField(
          key: const Key("BillNameTextField"),
          onChanged: (value) {
            setState(() {
              billName = value;
            });
          },
          controller: _nameInputController,
          decoration: const InputDecoration(labelText: "Bill Name"),
        ),
        // Date Picker in flutter, https://levelup.gitconnected.com/date-picker-in-flutter-ec6080f3508a
        TextField(
          onTap: () async {
            moment = await showDatePicker(
              context: context,
              // initialDate: DateTime(2000),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            setState(() {
              _dateInputController.text =
                  DateFormat.yMMMMd('en_US').format(moment!);
            });
          },
          controller: _dateInputController,
          decoration: const InputDecoration(labelText: "Date"),
          readOnly: true,
        ),
        TextField(
          key: const Key("AmountTextField"),
          onChanged: (valueAmount) {
            setState(() {
              amount = double.parse(valueAmount);
            });
          },
          controller: _amountInputController,
          decoration: const InputDecoration(labelText: "Amount"),
        ),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          items: frequencies.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
            key: const Key("CameraButton"),
            style: cameraStyle,
            child: const Text('Take Picture'),
            onPressed: () async {
              final result = await showDialog<XFile>(
                  context: context,
                  builder: (_) {
                    return TakePictureScreen(
                        camera: widget.cam); // needs to return an image/path
                  });
              img = result;
              setState(() {
                textString = "image taken";
              });
            }),
        Text(textString),
      ]),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          EvilButton(
            key: const Key("CancelButton"),
            child: const Text('Cancel'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
          const SizedBox(width: 10),
          GoodButton(
            key: const Key("OKButton"),
            child: const Text('OK'),
            onPressed: () {
              setState(() {
                widget.onListChanged(Item(
                    name: billName,
                    date: moment,
                    payment: amount,
                    image: img,
                    frequency: dropdownValue));
                setBalance(getBalance()+ amount);    
                Navigator.pop(context);
              });
            },
          ),
        ]),
      ],
    );
  }
}
