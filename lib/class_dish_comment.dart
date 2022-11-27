class ClassDishComment {
  int id;
  int forid;
  String name;
  ClassDishComment(this.id, this.forid, this.name);

  static List<ClassDishComment> list = [];

  static List<ClassDishComment> getList(int dish) {
    List<ClassDishComment> l = [];
    for (ClassDishComment c in list) {
      if (c.forid == dish) {
        l.add(c);
      }
    }
    for (ClassDishComment c in list) {
      if (c.forid != dish) {
        l.add(c);
      }
    }
    return l;
  }
}