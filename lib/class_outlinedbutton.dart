import 'package:flutter/material.dart';

class ClassOutlinedButton {

  static Widget create(Function f, String text, {double h = 36, double w = 36}) {
    return Container(
        width: w,
        height: h,
        margin: const EdgeInsets.only(left: 5),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(2),
            ),
            onPressed: () {
              f();
            },
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold),)));
  }

  static Widget createImage(Function f, String img, {double h = 36, double w = 36}) {
    return Container(
        width: w,
        height: h,
        margin: const EdgeInsets.only(left: 3, right: 3),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(2),
            ),
            onPressed: () {
              f();
            },
            child: Image.asset(img, width: w, height: h)));
  }
}