import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String text;

  const Loading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
            height: 30, width: 30, child: CircularProgressIndicator()),
        const SizedBox(height: 20),
        Text(text)
      ],
    ));
  }
}
