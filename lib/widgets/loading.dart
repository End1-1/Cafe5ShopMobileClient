import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String text;
  static const ts = TextStyle(fontSize: 12, color: Colors.black);

  const Loading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: 150, height: 150,
            child: Flex(
          direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
            height: 30, width: 30, child: CircularProgressIndicator()),
        const SizedBox(height: 20),
        Text(text, style: ts)
      ],
    )));
  }
}
