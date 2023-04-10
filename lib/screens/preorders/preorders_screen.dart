import 'package:cafe5_shop_mobile_client/models/http_query/http_preorders.dart';
import 'package:cafe5_shop_mobile_client/models/model.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/preorder_detail/preorder_details_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/preorders/preorders_model.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreordersScreen extends StatelessWidget {
  final model = PreordersModel();
  final int state;

  PreordersScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Preorders',
        child: BlocProvider<ScreenBloc>(
            create: (_) => ScreenBloc(SSInProgress())
              ..add(SEHttpQuery(query: HttpPreorders(state))),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PreorderDetailsScreen(preorder: e)));
                                },
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
}
