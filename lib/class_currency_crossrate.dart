class CurrencyCrossRate {
  int id;
  int curr1;
  int curr2;
  double rate;
  CurrencyCrossRate({required this.id, required this.curr1, required this.curr2, required this.rate});

  static List<CurrencyCrossRate> data = [];

  static double getRate(int curr1, int curr2) {
    for (CurrencyCrossRate r in data) {
      if (r.curr1 == curr1 && r.curr2 == curr2) {
        return r.rate;
      }
    }
    return 0;
  }
}