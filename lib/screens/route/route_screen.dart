import 'package:cafe5_shop_mobile_client/screens/route/route_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import '../../class_outlinedbutton.dart';
import '../../freezed/route.dart';
import '../../models/lists.dart';
import '../../models/query_bloc/query_action.dart';
import '../../models/query_bloc/query_bloc.dart';
import '../../models/query_bloc/query_state.dart';
import '../../translator.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_table.dart';

class RouteScreen extends StatelessWidget {
  final RouteModel _model = RouteModel();

  RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            QueryBloc(const QueryStateFilter(filter: '')),
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
                              }, tr("Route"), "images/back.png",
                                  w: 280),
                              ClassOutlinedButton.createImage(() {
                                _model.showFilter = !_model.showFilter;
                              }, 'images/filter.png', w: 36),
                              Expanded(child: Container()),
                            ]),
                            const Divider(
                                height: 20,
                                thickness: 2,
                                color: Colors.black26),
                            AnimatedContainer(
                              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.9, maxWidth: MediaQuery.of(context).size.width * 0.9),
                                height: _model.showFilter ? 50 : 0, duration: const Duration(milliseconds: 300), child: Row(children: [
                              Expanded(child: TextFormField(
                                controller: _model.filterController,
                                onChanged: (text){

                                },
                              ))
                            ],)),
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
      return _filteredItem(context, state);
    } else if (state is QueryStateFilter) {
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
    for (var e in Lists.route.list) {
      i++;
      rows.add(InkWell(onTap:(){}, child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionCheckBox(point: e),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: AppTable.cellPadding,
                  height: 30,
                  width: 300,
                  decoration:
                  i % 2 == 0 ? AppTable.tableCellEven : AppTable.tableCellOdd,
                  child: Text(e.address ?? "", maxLines: 1, style: AppFonts.tableRowText)),
              Container(
                  padding: AppTable.cellPadding,
                  height: 30,
                  width: 300,
                  decoration: i % 2 == 0
                      ? AppTable.tableCellEven
                      : AppTable.tableCellOdd,
                  child: Text('${e.taxname}, ${e.taxcode}',
                      maxLines: 1, style: AppFonts.tableRowText))
            ],
          ),
          Container(
              padding: AppTable.cellPadding,
              height: 60,
              width: 80,
              decoration:
              i % 2 == 0 ? AppTable.tableCellEven : AppTable.tableCellOdd,
              child: Text(e.taxcode ?? "",
                  maxLines: 1, style: AppFonts.tableRowText)),
        ],
      )));
    }
    return
      SingleChildScrollView(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: rows)));
  }

  void _query(BuildContext context) {
    BlocProvider.of<QueryBloc>(context).eventToState(
        const QueryActionFilter(filter: ''));
  }
}

class ActionCheckBox extends StatefulWidget {
  final RoutePoint point;
  ActionCheckBox({required this.point});
  @override
  State<StatefulWidget> createState() => _ActionCheckBox();
}

class _ActionCheckBox extends State<ActionCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(value: widget.point.action == 1, onChanged: (v){setState(() {
      int index = Lists.route.list.indexOf(widget.point);
      Lists.route.list[index] = widget.point.copyWith(action: v ?? false ? 1 : 0);});
    });
  }

}
