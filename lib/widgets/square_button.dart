import 'package:flutter/material.dart';

Widget squareButton(VoidCallback onPressed, String text) {
  return SizedBox(height: 72, width: 72, child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(2),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      )));
}

Widget squareImageButton(VoidCallback onPressed, String assetPath) {
  return SizedBox(height: 72, width: 72, child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(2),
      ),
      child:  Image.asset(assetPath, width: 64, height: 64)));
}
