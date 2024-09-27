import 'dart:io';

import 'package:budget_buddy/dialogs/take_picture_screen.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

typedef ItemsListDeletedCallback = Function(Item item);

class InfoDialog extends StatefulWidget {
  const InfoDialog(
      {super.key,
      required this.item,
      required this.onDeleteItem,
      required this.cam});

  final ItemsListDeletedCallback onDeleteItem;
  final Item item;
  final CameraDescription cam;

  @override
  State<InfoDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<InfoDialog> {
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
    MoneyFormatter fmf = MoneyFormatter(amount: widget.item.payment);
    String fo = fmf.output.symbolOnLeft;

    return AlertDialog(
      title: const Text('Bill Information'),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text("Name: ${widget.item.name}"),
        Text("Date: ${DateFormat('MM-dd-yy').format(widget.item.date!)}"),
        Text("Amount: $fo"),
        Text("Frequency: ${widget.item.frequency}"),
        ElevatedButton(
            key: const Key("CameraButton2"),
            style: cameraStyle,
            child: const Text('Add/Show Picture'),
            onPressed: () async {
              if (widget.item.image != null) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return DisplayPictureScreen(image: widget.item.image!);
                    });
              }
              if (widget.item.image == null) {
                final result = await showDialog<XFile>(
                    context: context,
                    builder: (_) {
                      return TakePictureScreen(
                          camera: widget.cam); // needs to return an image/path
                    });
                widget.item.image = result;
              }
            }),
      ]),
      actions: <Widget>[
        ElevatedButton(
          key: const Key("DeleteButton"),
          style: noStyle,
          child: const Text('Delete Bill'),
          onPressed: () {
            widget.onDeleteItem(widget.item);
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          key: const Key("CloseButton"),
          style: yesStyle,
          child: const Text('Close'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }
}
