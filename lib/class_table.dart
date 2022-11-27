
import 'package:cafe5_shop_mobile_client/class_car_model.dart';
import 'package:cafe5_shop_mobile_client/class_customer.dart';

class ClassTable {
  int id;
  int stateid;
  int hallid;
  String name;
  String? orderid;
  String owner = "";
  ClassCustomer? customer;
  ClassCarModel? car;

  ClassTable({required this.id, required this.stateid, required this.hallid, required this.name});

  static List<ClassTable> list = [];
}