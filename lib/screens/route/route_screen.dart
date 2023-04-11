import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/order/order_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/route/route_model.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/data_types.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteScreen extends StatelessWidget {
  final model = RouteModel();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Route',
        child: BlocProvider<ScreenBloc>(
            create: (_) => ScreenBloc(SSInit())..add(model.query()),
            child: BlocListener<ScreenBloc, ScreenState>(listener:
                (BuildContext context, state) {
              if (state is SSError) {
                appDialog(context, state.error);
              }
            }, child:
                BlocBuilder<ScreenBloc, ScreenState>(builder: (context, state) {
                  if (state is SSInProgress) {
                    return Expanded(child: Loading(tr('Load routes')));
                  }
                  if (state is SSData) {
                    for (var e in state.data[pkData]) {
                      model.route.add(RouteItem.fromJson(e));
                    }
                  }
              return SingleChildScrollView(child: Column(
                children: [
                  for (final e in model.route)...[
                    InkWell(onLongPress:(){
                      Partner? p = Lists.findPartner(e.partnerid);
                      if (p == null) {
                        return;
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen(pricePolitic: p.pricepolitic, partner: p)));
                    }, child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                        decoration: BoxDecoration(color: e.orders == 0 ? Colors.black12 : const Color(
                        0xffc4ffc4)), child: Row(
                      children: [
                        SizedBox(height: 50, width: 150, child: Text(e.partnername)),
                        const SizedBox(width: 5),
                        Expanded(child: SizedBox(height: 50, child: Text(e.address))),
                      ],
                    )))
                  ]
                ],
              ));
            }))));
  }
}
