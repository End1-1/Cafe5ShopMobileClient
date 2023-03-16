import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/utils/app_fonts.dart';
import 'package:cafe5_shop_mobile_client/utils/app_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceModePopupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: _priceModeList(context)
    );
  }

  List<Widget> _priceModeList(BuildContext context) {
    List<Widget> l = [];
    for (var e in Lists.priceModeList.list) {
      l.add(
        Container(padding: AppTable.cellPaddingLarge, child: InkWell(onTap:(){
          Navigator.pop(context, e);
        }, child: Text(e.name, style: AppFonts.standardText)))
      );
    }
    return l;
  }

}