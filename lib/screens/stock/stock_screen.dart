import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/models/model.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/screens/stock/stock_model.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockScreen extends StatelessWidget {
  final model = StockModel();

  StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Stock',
        headerWidgets: [
          squareImageButton(() {}, 'assets/images/filter.png', height: 40)
        ],
        child: BlocProvider<ScreenBloc>(
          create: (_) => ScreenBloc(SSInit())
            ..add(SEHttpQuery(
                query: HttpQuery(hqStock, initData: {
              'stock': model.stock,
              'group': model.goodsGroup
            }))),
          child: Column(children: [
            StreamBuilder(
                stream: model.filterController.stream,
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      Text(model.stockName()),
                      Expanded(child: Container()),
                      Text(model.groupName())
                    ],
                  );
                }),
            BlocListener(
                listener: (context, state) {},
                child: BlocBuilder<ScreenBloc, ScreenState>(
                    builder: (context, state) {
                  if (state is SSInProgress) {
                    return Loading(tr('Load stock'));
                  }
                  return Column(children: [
                    for (var e in model.stock) ...[
                      Row(
                        children: [
                          Text(e.groupname),
                          Text(e.goodsname),
                          Text(mdFormatDouble(e.qty))
                        ],
                      )
                    ]
                  ]);
                }))
          ]),
        ));
  }
}
