import 'package:cafe5_shop_mobile_client/sales_history/model.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:cafe5_shop_mobile_client/widgets/square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SalesHistoryScreen extends StatelessWidget {
  final model = SalesHistoryModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _blocKey = GlobalKey<ScaffoldState>();
  final bloc = ScreenBloc(SSInit());

  SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScreenBloc>( key: _blocKey,
        create: (_) => bloc..add(SEHttpQuery(query: model.stockQuery())),
        child: AppScaffold(
        key: _scaffoldKey,
        title: 'Sales history',
        headerWidgets: [
          squareImageButton(() async {
            if (await filterWindow(context)) {
              bloc.add(SEHttpQuery(query: model.stockQuery()));
            };
          }, 'assets/images/filter.png', height: 40)
        ],
        child:  BlocListener<ScreenBloc, ScreenState>(
                listener: (context, state) {
                  if (state is SSError) {
                    appDialog(context, state.error);
                  }
                },
                child: Column(children: [
                  BlocBuilder<ScreenBloc, ScreenState>(
                      builder: (context, state) {
                    if (state is SSInProgress) {
                      return Expanded(child: Loading(tr('Load report')));
                    }
                    return const Expanded(
                        child:
                            SingleChildScrollView(child: Column(children: [

                            ])));
                  })
                ]))));
  }

  Future<bool> filterWindow(BuildContext context) async {
    bool? result = await showDialog(
        context: context,
        builder: (builder) {
          return SimpleDialog(children: [
            Row(children: [
              Text(tr('Start date')),
              const SizedBox(
                width: 10,
              ),
              squareImageButton(() {
                model.date1 = model.previousDate(model.date1);
              }, 'assets/images/left.png'),
              StreamBuilder(
                  stream: model.dateStream.stream,
                  builder: (context, snapshot) {
                    return Text(DateFormat('dd/MM/yyyy').format(model.date1));
                  }),
              squareImageButton(() {
                model.date1 = model.nextDate(model.date1);
              }, 'assets/images/right.png'),
            ]),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              Text(tr('End date')),
              const SizedBox(
                width: 10,
              ),
              squareImageButton(() {
                model.date2 = model.previousDate(model.date2);
              }, 'assets/images/left.png'),
              StreamBuilder(
                  stream: model.dateStream.stream,
                  builder: (context, snapshot) {
                    return Text(DateFormat('dd/MM/yyyy').format(model.date2));
                  }),
              squareImageButton(() {
                model.date2 = model.nextDate(model.date2);
              }, 'assets/images/right.png'),
            ]),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Container(),),
                squareImageButton(() {
                  Navigator.pop(context, true);
                }, 'assets/images/done.png'),
                const SizedBox(
                  width: 10,
                ),
                squareImageButton(() {
                  Navigator.pop(context);
                }, 'assets/images/cancel.png'),
                Expanded(child: Container(),),
              ],
            ),
          ]);
        });
      return result ?? false;
  }
}
