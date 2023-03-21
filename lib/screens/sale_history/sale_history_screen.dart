import 'dart:convert';

import 'package:cafe5_shop_mobile_client/freezed/sale.dart';
import 'package:cafe5_shop_mobile_client/screens/sale_history/sale_history_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../class_outlinedbutton.dart';
import '../../models/query_bloc/query_action.dart';
import '../../models/query_bloc/query_bloc.dart';
import '../../models/query_bloc/query_state.dart';
import '../../translator.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_table.dart';

class SaleHistoryScreen extends StatelessWidget {
  final SaleHistoryModel _model = SaleHistoryModel();

  SaleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            QueryBloc(QueryStateNeedUserAction(message: tr('Select storage'))),
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
                              ClassOutlinedButton.createTextAndImage(() {
                                Navigator.pop(context);
                              }, tr("Sales history"), "images/back.png",
                                  w: 280),
                              ClassOutlinedButton.createImage(() {
                                _model.showTextFilter = !_model.showTextFilter;
                              }, 'images/filter.png', w: 36),
                              Expanded(child: Container()),
                            ]),
                            const Divider(
                                height: 20,
                                thickness: 2,
                                color: Colors.black26),
                            Row(children: [
                              Expanded(
                                  child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      height: _model.showTextFilter ? 50 : 0,
                                      child: TextFormField(
                                        controller: _model.filterController,
                                        onChanged: (text) {
                                          BlocProvider.of<QueryBloc>(context)
                                              .add(QueryActionFilter(
                                                  filter: _model
                                                      .filterController.text));
                                        },
                                      )))
                            ]),
                            Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          DatePicker.showDateTimePicker(context,
                                              locale: LocaleType.ru,
                                              //currentTime: _orderDateTime.isBefore(DateTime.now()) ? DateTime.now() : _orderDateTime.add(Duration(minutes: 1)),
                                              currentTime: _model.date1,
                                              onConfirm: (dt) {
                                            _model.date1 = dt;
                                          });
                                        },
                                        child: Container(
                                            padding: AppTable.cellPadding,
                                            child: Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(_model.date1),
                                              textAlign: TextAlign.center,
                                            )))),
                                Container(
                                    padding: AppTable.cellPaddingLarge,
                                    child: Text('-',
                                        style: AppFonts.standardText)),
                                Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          DatePicker.showDateTimePicker(context,
                                              locale: LocaleType.ru,
                                              //currentTime: _orderDateTime.isBefore(DateTime.now()) ? DateTime.now() : _orderDateTime.add(Duration(minutes: 1)),
                                              currentTime: _model.date2,
                                              onConfirm: (dt) {
                                            _model.date2 = dt;
                                          });
                                        },
                                        child: Container(
                                            padding: AppTable.cellPadding,
                                            child: Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(_model.date2),
                                              textAlign: TextAlign.center,
                                            )))),
                                ClassOutlinedButton.createImage(() {
                                  _query(context);
                                }, 'images/search.png', w: 36)
                              ],
                            ),
                            const Divider(
                                height: 20,
                                thickness: 1,
                                color: Colors.black26),
                            Expanded(child: _widget(context, state))
                          ]);
                    })))));
  }

  Widget _widget(BuildContext context, QueryState state) {
    if (state is QueryStateError) {
      return Align(
          alignment: Alignment.center,
          child: Text(state.error,
              style: const TextStyle(fontSize: 20, color: Colors.red)));
    } else if (state is QueryStateNeedUserAction) {
      _query(context);
      return Align(
          alignment: Alignment.center,
          child: Text(tr('Please, wait'),
              style: const TextStyle(fontSize: 20, color: Colors.red)));
    } else if (state is QueryStateProgress) {
      return const Align(
          alignment: Alignment.center,
          child: SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator()));
    } else if (state is QueryStateReady) {
      // _model.items = StorageItems.fromJson({'items': jsonDecode(state.data)});
      _model.sales =
          SaleHeaderHistoryList.fromJson({'list': jsonDecode(state.data)});
      if (_model.sales == null || _model.sales!.list.isEmpty) {
        return Align(
            alignment: Alignment.center,
            child: Text(tr('Empty'),
                style: const TextStyle(fontSize: 20, color: Colors.red)));
      }
      return _filteredItem(context, state);
    } else if (state is QueryStateFilter) {
      if (_model.sales == null) {
        return Align(
            alignment: Alignment.center,
            child: Text(tr('Empty'),
                style: const TextStyle(fontSize: 20, color: Colors.red)));
      }
      return _filteredItem(context, state);
    }
    return Align(
        alignment: Alignment.center,
        child: Text(tr('Unknown error'),
            style: const TextStyle(fontSize: 20, color: Colors.red)));
  }

  Widget _filteredItem(BuildContext context, QueryState state) {
    List<Widget> rows = [];
    int i = 0;
    for (var e in _model.sales!.list) {
      i++;
      rows.add(InkWell(onTap:(){}, child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: AppTable.cellPadding,
              height: 60,
              width: 100,
              decoration:
                  i % 2 == 0 ? AppTable.tableCellEven : AppTable.tableCellOdd,
              child: Text(e.date, maxLines: 1, style: AppFonts.tableRowText)),
          Container(
              padding: AppTable.cellPadding,
              height: 60,
              width: 70,
              decoration:
                  i % 2 == 0 ? AppTable.tableCellEven : AppTable.tableCellOdd,
              child:
                  Text(e.taxcode, maxLines: 1, style: AppFonts.tableRowText)),
          Expanded(
              child: Container(
                  padding: AppTable.cellPadding,
                  height: 60,
                  decoration: i % 2 == 0
                      ? AppTable.tableCellEven
                      : AppTable.tableCellOdd,
                  child: Text(e.taxname,
                      maxLines: 2, style: AppFonts.tableRowText))),
          Container(
              padding: AppTable.cellPadding,
              height: 60,
              width: 80,
              decoration:
                  i % 2 == 0 ? AppTable.tableCellEven : AppTable.tableCellOdd,
              child: Text('${e.amount.round()}',
                  maxLines: 1, style: AppFonts.tableRowText)),
        ],
      )));
    }
    return
        SingleChildScrollView(scrollDirection: Axis.vertical, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: rows));
  }

  void _query(BuildContext context) {
    BlocProvider.of<QueryBloc>(context).add(
        QueryActionLoad(op: SocketMessage.op_json_sales_history, optional: [
      DateFormat("dd/MM/yyyy").format(_model.date1),
      DateFormat('dd/MM/yyyy').format(_model.date2)
    ]));
  }
}
