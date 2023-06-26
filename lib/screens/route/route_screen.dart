import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/drivers_list/driver_list_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/order/order_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/route/route_model.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/data_types.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RouteScreen extends StatelessWidget {
  final model = RouteModel();
  final GlobalKey _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScreenBloc>(
        create: (_) => ScreenBloc(SSInit())
          ..add(model.query(prefs.getInt(pkRouteDriver) ?? 0)),
        child: AppScaffold(
            key: _scaffoldKey,
            title: 'Route',
            headerWidgets: [
              squareImageButton(() {
                model.previousDate();
                BlocProvider.of<ScreenBloc>(_scaffoldKey.currentContext!)
                    .add(model.query(prefs.getInt(pkRouteDriver) ?? 0));
              }, 'assets/images/left.png'),
              StreamBuilder<String>(
                  stream: model.dateStream.stream,
                  builder: (context, snapshot) {
                    return Text(snapshot.data ??
                        DateFormat('dd/MM/yyyy').format(model.date));
                  }),
              squareImageButton(() {
                model.nextDate();
                BlocProvider.of<ScreenBloc>(_scaffoldKey.currentContext!)
                    .add(model.query(prefs.getInt(pkRouteDriver) ?? 0));
              }, 'assets/images/right.png'),
              squareImageButton(() {
                showDialog(
                    context: _scaffoldKey.currentContext!,
                    builder: (context) {
                      return const SimpleDialog(children: [DriverListScreen()]);
                    }).then((value) {
                  if (value != null) {
                    prefs.setInt(pkRouteDriver, value);
                    BlocProvider.of<ScreenBloc>(_scaffoldKey.currentContext!)
                        .add(model.query(prefs.getInt(pkRouteDriver) ?? 0));
                  }
                });
              }, 'assets/images/filter.png')
            ],
            child: BlocListener<ScreenBloc, ScreenState>(listener:
                (BuildContext context, state) {
              if (state is SSError) {
                appDialog(context, state.error);
              }
            }, child:
                BlocBuilder<ScreenBloc, ScreenState>(builder: (context, state) {
              if (state is SSInProgress) {
                return Loading(tr('Load routes'));
              }
              if (state is SSData) {
                model.route.clear();
                for (var e in state.data[pkData]) {
                  model.route.add(RouteItem.fromJson(e));
                }
              }
              int row = 1;
              return SingleChildScrollView(
                  child: Column(
                children: [
                  for (final e in model.route) ...[
                    InkWell(
                        onLongPress: () {
                          Partner? p = Lists.findPartner(e.partnerid);
                          if (p == null) {
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderScreen(
                                      pricePolitic: p.pricepolitic,
                                      partner: p))).then((value) {
                            BlocProvider.of<ScreenBloc>(
                                    _scaffoldKey.currentContext!)
                                .add(model
                                    .query(prefs.getInt(pkRouteDriver) ?? 0));
                          });
                        },
                        child: Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            decoration:
                                const BoxDecoration(color: Colors.black12),
                            child: Row(
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${row++}. ${e.partnername}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo)),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (e.action.contains('1')) ...[
                                              Image.asset(
                                                  'assets/images/goodsnotneeded.png',
                                                  height: 20,
                                                  width: 20)
                                            ],
                                            if (e.action.contains('2'))
                                              Image.asset(
                                                  'assets/images/order.png',
                                                  height: 20,
                                                  width: 20),
                                            if (e.action.contains('3'))
                                              Image.asset(
                                                  'assets/images/visitclosed.png',
                                                  height: 20,
                                                  width: 20),
                                            if (e.action.contains('4'))
                                              Image.asset(
                                                  'assets/images/completedelivery.png',
                                                  height: 20,
                                                  width: 20),
                                            if (e.orders > 0) ...[
                                              Image.asset(
                                                  'assets/images/delivery.png',
                                                  height: 20,
                                                  width: 20)
                                            ],
                                            //Expanded(child: Container())
                                          ])
                                    ]),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: SizedBox(
                                        height: 50, child: Text(e.address))),
                              ],
                            )))
                  ]
                ],
              ));
            }))));
  }
}
