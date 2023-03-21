import 'dart:convert';

import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/freezed/storagename.dart';
import 'package:cafe5_shop_mobile_client/models/query_bloc/query_action.dart';
import 'package:cafe5_shop_mobile_client/models/query_bloc/query_bloc.dart';
import 'package:cafe5_shop_mobile_client/models/query_bloc/query_state.dart';
import 'package:cafe5_shop_mobile_client/screens/stock/stock_model.dart';
import 'package:cafe5_shop_mobile_client/screens/storage_names_popup/storage_names_popup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';

import '../../translator.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_table.dart';

class StockScreen extends StatelessWidget {
  final StockModel _model = StockModel();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            QueryBloc(QueryStateNeedUserAction(message: tr('Please, wait'))),
        child: Scaffold(
            body: SafeArea(
                minimum: const EdgeInsets.only(
                    left: 5, right: 5, bottom: 5, top: 35),
                child: BlocListener<QueryBloc, QueryState>(
                    listener: (context, state) {},
                    child: BlocBuilder<QueryBloc, QueryState>(
                        builder: (context, state) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(child: ClassOutlinedButton.createTextAndImage(() {
                                Navigator.pop(context);
                              }, tr("Check quantity"), "images/back.png",
                                  w: null)),
                              ClassOutlinedButton.createImage(
                                  () {
                                    showDialog(context: context, builder: (context) {
                                      return const SimpleDialog(children: [
                                        StorageNamesPopupScreen()
                                      ],);
                                    }).then((s) {
                                      BlocProvider.of<QueryBloc>(context).add(QueryActionLoad(op: SocketMessage.op_json_stock, optional: [s.id]));
                                    });
                                  }, 'images/menu.png')
                            ]),
                            const Divider(
                                height: 20, thickness: 2, color: Colors.black26),
                            Expanded(child: _widget(context, state))
                          ]);
                    })))));
  }

  Widget _widget(BuildContext context, QueryState state) {
    if (state is QueryStateError) {
      return Align(alignment: Alignment.center, child: Text(state.error, style: const TextStyle(fontSize: 20, color: Colors.red)));
    } else if (state is QueryStateNeedUserAction) {
      return Align(alignment: Alignment.center, child: Text(tr('Choose a warehouse'), style: const TextStyle(fontSize: 20, color: Colors.red)));
    } else if (state is QueryStateProgress) {
      return const Align(alignment: Alignment.center, child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));
    } else if (state is QueryStateReady) {
      _model.items = StorageItems.fromJson({'items': jsonDecode(state.data)});
      return _filteredItem(context, state);
    } else if (state is QueryStateFilter) {
      return _filteredItem(context, state);
    }
    return Align(alignment: Alignment.center, child: Text(tr('Unknown error'), style: const TextStyle(fontSize: 20, color: Colors.red)));
  }

  Widget _filteredItem(BuildContext context, QueryState state) {
    List<Widget> rows = [];
    rows.add(
        Container(
            decoration: const BoxDecoration(border: Border.fromBorderSide(
                BorderSide(color: Colors.black12))),
            child: Row(
              children: [
                Expanded(child: TextFormField(
                  controller: _model.filterController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none),
                  onChanged: (text) {
                    BlocProvider.of<QueryBloc>(context).add(QueryActionFilter(filter: _model.filterController.text));
                  },
                )),
                Padding(
                    padding: AppTable.cellPadding, child: InkWell(onTap: () {
                  _model.filterController.clear();
                  BlocProvider.of<QueryBloc>(context).add(QueryActionFilter(filter: _model.filterController.text));
                },
                    child: Image.asset(
                      'images/cancel.png', height: 30, width: 30,)))
              ],
            ))
    );
    rows.add(const Divider(height: 10,));
    int i = 0;
    for (var e in _model.items!.items) {
      if (!e.name.toLowerCase().contains(_model.filterController.text)) {
        continue;
      }
      i++;
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: AppTable.cellPadding,
              height: 60,
              width: 150,
              decoration: i % 2 == 0 ? AppTable.tableCellEven : AppTable
                  .tableCellOdd,
              child: Text(
                  e.groupname, maxLines: 1, style: AppFonts.tableRowText)),
          Expanded(child: Container(padding: AppTable.cellPadding,
              height: 60,
              decoration: i % 2 == 0 ? AppTable.tableCellEven : AppTable
                  .tableCellOdd,
              child: Text(
                  e.groupname, maxLines: 2, style: AppFonts.tableRowText))),
          Container(padding: AppTable.cellPadding,
              height: 60,
              width: 50,
              decoration: i % 2 == 0 ? AppTable.tableCellEven : AppTable
                  .tableCellOdd,
              child: Text(
                  '${e.qty}', maxLines: 1, style: AppFonts.tableRowText)),
        ],));
    }
    return SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows));
  }
}
