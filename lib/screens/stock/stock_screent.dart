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

class StockScreen extends StatelessWidget {
  final StockModel _model = StockModel();

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
                                      BlocProvider.of<QueryBloc>(context).eventToState(const QueryActionLoad(op: SocketMessage.op_json_stock));
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
      return const SizedBox(height: 50, width: 50, child: CircularProgressIndicator());
    } else if (state is QueryStateReady) {
      _model.items = StorageItems.fromJson({'storageitems': jsonDecode(state.data)});
      List<Widget> rows = [];
      return SingleChildScrollView(child: Column(children: rows));
    }
    return Align(alignment: Alignment.center, child: Text(tr('Unknown error'), style: const TextStyle(fontSize: 20, color: Colors.red)));
  }
}
