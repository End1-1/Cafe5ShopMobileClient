import 'package:cafe5_shop_mobile_client/db.dart';

class ClassHall {
  int id;
  String name;
  int menu;
  double servicevalue;

  ClassHall({required this.id, required this.name, required this.menu, required this.servicevalue});

  static List<ClassHall> list = [];

  static ClassHall? getHall(int id) {
    for (ClassHall ch in list) {
      if (ch.id == id) {
        return ch;
      }
    }
    return null;
  }
}