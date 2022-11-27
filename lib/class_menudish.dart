import 'class_dish.dart';

class ClassMenuDish {
  int menuid;
  int typeid;
  int dishid;
  double price;
  String print1;
  String print2;
  String comment = "";
  int storeid;
  ClassDish? dish;

  ClassMenuDish(this.menuid, this.typeid, this.dishid, this.price, this.print1, this.print2, this.storeid);

  static List<ClassMenuDish> list = [];

  static Map<int, Set<int> > part2  = Map();

  static void buildPart2() {
    for (ClassMenuDish cm in list) {
      if (!part2.containsKey(cm.menuid)) {
        part2[cm.menuid] = Set();
      }
      part2[cm.menuid]!.add(cm.typeid);
    }
  }
}