import 'dart:io';

import 'package:budget_buddy/dialogs/take_picture_screen.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// adapted from to-dont-list code
typedef ItemsListChangedCallback = Function(Item item);

class ItemDialog extends StatefulWidget {
  const ItemDialog({
    super.key,
    required this.onListChanged,
    required this.cam,
  });

  final ItemsListChangedCallback onListChanged;
  final CameraDescription cam;

  @override
  State<ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _dateInputController = TextEditingController();
  final TextEditingController _amountInputController = TextEditingController();
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle cameraStyle =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  String billName = "";
  String textString = "";
  DateTime? moment = DateTime.now();
  double amount = 0.0;
  XFile? img;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Item'),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        TextField(
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
          onChanged: (valueAmount) {
            setState(() {
              amount = double.parse(valueAmount);
            });
          },
          controller: _amountInputController,
          decoration: const InputDecoration(labelText: "Amount"),
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
        ElevatedButton(
          key: const Key("CancelButton"),
          style: noStyle,
          child: const Text('Cancel'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        ElevatedButton(
          key: const Key("OKButton"),
          style: yesStyle,
          child: const Text('OK'),
          onPressed: () {
            setState(() {
              widget.onListChanged(Item(
                  name: billName, date: moment, payment: amount, image: img));
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }
}
