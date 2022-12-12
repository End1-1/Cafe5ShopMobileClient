class SaleGoods {
  int goods;
  int currency;
  String name;
  String barcode;
  double price1;
  double price2;

  SaleGoods({required this.goods, required this.currency, required this.name, required this.barcode, required this.price1, required this.price2});

  static List<SaleGoods> list = [];
}