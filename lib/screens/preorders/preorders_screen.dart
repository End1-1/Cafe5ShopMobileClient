import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/models/model.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/drivers_list/driver_list_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/preorder_detail/preorder_details_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/preorders/preorders_model.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PreordersScreen extends StatelessWidget {
  final model = PreordersModel();
  final _scaffoldKey = GlobalKey();

  PreordersScreen({super.key, required int state}) {
    model.state = state;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScreenBloc>(
        create: (_) => ScreenBloc(SSInProgress())
          ..add(model.query(prefs.getInt(pkSaleDriver) ?? 0)),
        child: AppScaffold(
            key: _scaffoldKey,
            title: model.state == 1 ? 'Pending preorders' : 'Preorders',
            headerWidgets: _headerWidget(context),
            child: BlocListener<ScreenBloc, ScreenState>(listener:
                (context, state) {
              if (state is SSError) {
                appDialog(context, state.error).then((value) {
                  Navigator.pop(context);
                });
              }
            }, child:
                BlocBuilder<ScreenBloc, ScreenState>(builder: (context, state) {
              if (state is SSInProgress) {
                return Loading(tr('Loading...'));
              } else if (state is SSData) {
                model.data.clear();
                for (var e in state.data[pkData]) {
                  model.data.add(Preorder.fromJson(e));
                }
                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var e in model.data) ...[
                          Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              decoration: const BoxDecoration(
                                  border: Border.fromBorderSide(
                                      BorderSide(color: Colors.black12))),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PreorderDetailsScreen(
                                                    preorder: e)));
                                  },
                                  onLongPress: () {
                                    appDialogQuestion(
                                        context, tr('Is delivery complete?'),
                                        () {
                                      Map<String, dynamic> response = {
                                        'id': e.id
                                      };
                                      HttpQuery(hqCompleteDelivery)
                                          .request(response)
                                          .then((value) {
                                        if (value == hrOk) {
                                          BlocProvider.of<ScreenBloc>(
                                                  _scaffoldKey.currentContext!)
                                              .add(model.query(
                                                  prefs.getInt(pkSaleDriver) ??
                                                      0));
                                        } else {
                                          appDialog(context, response[pkData]);
                                        }
                                      });
                                    }, null);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 50,
                                          width: 100,
                                          child: Text(e.date)),
                                      SizedBox(
                                          height: 50,
                                          width: 150,
                                          child: Text(e.partnername)),
                                      SizedBox(
                                          height: 50,
                                          width: 300,
                                          child: Text(e.address)),
                                      SizedBox(
                                          height: 50,
                                          width: 100,
                                          child: Text(mdFormatDouble(e.amount)))
                                    ],
                                  )))
                        ]
                      ],
                    )));
              }
              return Container();
            }))));
  }

  List<Widget> _headerWidget(BuildContext context) {
    return [
      squareImageButton(() {
        model.previousDate();
        BlocProvider.of<ScreenBloc>(_scaffoldKey.currentContext!)
            .add(model.query(prefs.getInt(pkSaleDriver) ?? 0));
      }, 'assets/images/left.png'),
      StreamBuilder<String>(
          stream: model.dateStream.stream,
          builder: (context, snapshot) {
            return Text(
                snapshot.data ?? DateFormat('dd/MM/yyyy').format(model.date));
          }),
      squareImageButton(() {
        model.nextDate();
        BlocProvider.of<ScreenBloc>(_scaffoldKey.currentContext!)
            .add(model.query(prefs.getInt(pkSaleDriver) ?? 0));
      }, 'assets/images/right.png'),
      squareImageButton(() {
        showDialog(
            context: _scaffoldKey.currentContext!,
            builder: (context) {
              return const SimpleDialog(children: [DriverListScreen()]);
            }).then((value) {
          if (value != null) {
            prefs.setInt(pkSaleDriver, value);
            BlocProvider.of<ScreenBloc>(_scaffoldKey.currentContext!)
                .add(model.query(prefs.getInt(pkSaleDriver) ?? 0));
          }
        });
      }, 'assets/images/filter.png')
    ];
  }
}
