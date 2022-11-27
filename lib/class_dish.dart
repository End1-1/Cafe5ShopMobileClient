import 'package:flutter/material.dart';

class ClassDish {
  int id;
  int part2;
  String name;
  int quicklist;

  Color bgColor = Colors.white;
  Color textColor = Colors.black54;

  ClassDish(this.id, this.part2, this.name, this.quicklist);

  static Map<int, ClassDish> map = Map();
}