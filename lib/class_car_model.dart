class ClassCarModel {
  int id;
  String name;
  String licensePlate = "";

  ClassCarModel({required this.id, required this.name});

  static List<ClassCarModel> carModels = [];

  static ClassCarModel getCar(int id) {
    for (int i = 0; i < carModels.length; i++) {
      if (id == carModels.elementAt(i).id) {
        return carModels.elementAt(i);
      }
    }
    return ClassCarModel(id: 0, name: "");
  }
}