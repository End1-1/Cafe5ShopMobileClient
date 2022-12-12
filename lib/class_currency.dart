class Currency {
  final int id;
  final String name;
  Currency({required this.id, required this.name});

  static List<Currency> list = [];

  static Currency? valueOf(int id) {
    for (int i = 0; i < list.length; i++) {
      final Currency c = list[i];
      if (c.id == id) {
        return c;
      }
    }
    return null;
  }
}