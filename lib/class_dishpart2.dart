import 'package:flutter/material.dart';

class ClassDishPart2 {
  int id;
  int parentid;
  int part1;
  String name;

  Color bgColor = Colors.white;
  Color textColor = Colors.black54;

  ClassDishPart2(this.id, this.parentid, this.part1, this.name);

  static List<ClassDishPart2> list = [];
}