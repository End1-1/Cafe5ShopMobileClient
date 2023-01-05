class PriceType {
  int id;
  String name;

  PriceType({required this.id, required this.name});

  static List<PriceType> list = [];

  static PriceType? valueOf(int id) {
    for (PriceType p in list) {
      if (p.id == id) {
        return p;
      }
    }
    return null;
  }
}