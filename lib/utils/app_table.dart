import 'package:cafe5_shop_mobile_client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTable {
  static const cellPadding = EdgeInsets.all(5);
  static const cellPaddingLarge = EdgeInsets.all(15);
  static const tableCellEven = BoxDecoration(color: AppColors.tableEventRow, border: Border(right: BorderSide(color: Colors.black12, width: 0.5)));
  static const tableCellOdd = BoxDecoration(color: AppColors.tableOddRow, border: Border(right: BorderSide(color: Colors.black12, width: 0.5)));
}