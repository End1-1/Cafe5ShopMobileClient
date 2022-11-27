import 'package:flutter/cupertino.dart';
import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/config.dart';
import 'package:cafe5_shop_mobile_client/widget_tables.dart';
import 'package:cafe5_shop_mobile_client/class_hall.dart';

class WidgetHalls extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WidgetHallsState();
  }
}

class WidgetHallsState extends BaseWidgetState<WidgetHalls> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Config.getBool(key_use_this_hall)) {
        if (Config.getInt(key_use_this_hall_id) > 0) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetTables(hall: Config.getInt(key_use_this_hall_id))), (route) => false);
          return;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: _hallList()),
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: CheckboxListTile(
                  title: Text(tr("Always use this hall")),
                  value: Config.getBool(key_use_this_hall),
                  onChanged: (c) {
                    setState(() {
                      Config.setBool(key_use_this_hall, c ?? false);
                    });
                  },
                ))),
      ],
    )));
  }

  Widget _hallList() {
    if (ClassHall.list.isEmpty) {
      return Text("Empty list of hall");
    }
    int colCount = 2;
    double colWidth = (MediaQuery.of(context).size.width - (colCount * 5) - 40) / colCount;
    List<DataColumn> columns = [];
    for (int i = 0; i < colCount; i++) {
      columns.add(DataColumn(label: Container(width: colWidth, child: Text(""))));
    }

    List<DataRow> rows = [];
    int col = 0;
    List<DataCell> dc = [];
    for (int i = 0; i < ClassHall.list.length; i++) {
      DataCell dataCell = DataCell(Container(
          padding: EdgeInsets.all(5),
          width: colWidth,
          margin: EdgeInsets.all(2),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(padding: EdgeInsets.only(left: 3, right: 3)),
              onPressed: () {
                Config.setInt(key_use_this_hall_id,  ClassHall.list[i].id);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetTables(hall: ClassHall.list[i].id)), (route) => false);
              },
              child: Text(
                ClassHall.list[i].name,
                overflow: TextOverflow.ellipsis,
              ))));
      dc.add(dataCell);
      col++;
      if (col == colCount) {
        col = 0;
        rows.add(DataRow(cells: dc));
        dc = [];
      }
    }
    if (dc.isNotEmpty) {
      while (dc.length < colCount) {
        dc.add(DataCell(Text("")));
      }
      rows.add(DataRow(cells: dc));
    }

    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: DataTable(
          dividerThickness: 0,
          columnSpacing: 0,
          dataRowHeight: 50,
          columns: columns,
          rows: rows,
          dataRowColor: MaterialStateProperty.resolveWith(_getDataRowColor),
        ));
  }

  Color _getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    } else if (states.contains(MaterialState.selected)) {
      return Colors.amberAccent;
    }
    return Colors.transparent;
  }
}
