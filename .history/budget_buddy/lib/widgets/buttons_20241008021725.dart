import 'package:flutter/material.dart';

//Code adapted from StyledButton in firebase_demo
class EvilButton extends StatelessWidget {
  const EvilButton({required this.child, required this.onPressed, super.key});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red, foregroundColor: Colors.white),
        onPressed: onPressed,
        child: child,
      );
}

class GoodButton extends StatelessWidget {
  const GoodButton({required this.child, required this.onPressed, super.key});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green, foregroundColor: Colors.white),
        onPressed: onPressed,
        child: child,
      );
}