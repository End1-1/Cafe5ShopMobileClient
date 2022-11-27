import 'dart:typed_data';
import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';

import 'package:cafe5_shop_mobile_client/class_dish_comment.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/widget_dish_manual_comment.dart';
import 'package:flutter/material.dart';

class WidgetDishComment extends StatefulWidget {
  final int dishid;
  String comment;

  WidgetDishComment(this.dishid, this.comment, {super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetDishCommentState();
  }
}

class WidgetDishCommentState extends BaseWidgetState<WidgetDishComment> {
  double _menuWidth = 0;
  double _screenWidth = 0;

  @override
  void handler(Uint8List data) {
    SocketMessage m = SocketMessage(messageId: 0, command: 0);
    m.setBuffer(data);
    if (!checkSocketMessage(m)) {
      return;
    }
    print("command ${m.command}");
    switch (m.command) {
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _screenWidth = MediaQuery.of(context).size.width;
      _menuWidth = _screenWidth - (_screenWidth / 3);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.all(3),
            child: Flex(direction: Axis.vertical, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClassOutlinedButton.createImage(() {
                  _cancel();
                }, "images/cancel.png"),
                Expanded(child: Container()),
                Text(tr("Dish comment"), style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Container()),
                ClassOutlinedButton.createImage(() {
                  Navigator.pop(context, widget.comment);
                }, "images/done.png")
              ]),
              Container(
                color: Colors.blueGrey,
                height: 5,
              ),
              SizedBox(width: double.infinity, child: _selectedComments()),
              Expanded(
                child: _comments(),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: 30,
                  width: double.infinity,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(2),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetDishManualComment())).then((result) {
                          if (result == null || result.isEmpty) {
                            return;
                          }
                          setState(() {
                            widget.comment = "${widget.comment},$result";
                          });
                        });
                      },
                      child: Align(alignment: Alignment.center, child: Row(children: [Expanded(child: Container()), Image.asset("images/edit.png", width: 25, height: 25), Text(tr("Edit comment")), Expanded(child: Container())]))))
            ])));
  }

  List<Widget> _wrapSelectedComments() {
    List<String> l = widget.comment.split(",");
    List<Widget> w = [];
    for (int i = 0; i < l.length; i++) {
      if (l[i].isEmpty) {
        continue;
      }
      w.add(Row(children: [
        Text(l[i], style: const TextStyle(fontWeight: FontWeight.bold)),
        ClassOutlinedButton.createImage(() {
          setState(() {
            l.removeAt(i);
            widget.comment = l.join(",");
          });
        }, "images/cancel.png")
      ]));
    }
    return w;
  }

  Widget _selectedComments() {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: _wrapSelectedComments(),
    );
  }

  Widget _comments() {
    int colCount = 3;
    List<DataColumn> columns = [];
    for (int i = 0; i < colCount; i++) {
      columns.add(const DataColumn(label: Text("")));
    }

    List<DataRow> rows = [];
    List<DataCell> cells = [];
    int col = 0;
    for (int i = 0; i < ClassDishComment.list.length; i++) {
      final ClassDishComment cmn = ClassDishComment.list.elementAt(i);
      if (cmn.forid > 0) {
        continue;
      }

      DataCell dc = DataCell(
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: _screenWidth / colCount,
            child: Align(
                alignment: Alignment.center,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(cmn.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                        )))),
          ), onTap: () {
        if (widget.comment.isNotEmpty) {
          widget.comment += ",";
        }
        setState(() {
          widget.comment += cmn.name;
        });
      });

      cells.add(dc);
      col++;
      if (col >= colCount) {
        col = 0;
        rows.add(DataRow(cells: cells));
        cells = [];
      }
    }
    if (cells.isNotEmpty) {
      while (cells.length < colCount) {
        cells.add(const DataCell(Text("")));
      }
      rows.add(DataRow(cells: cells));
    }

    return SingleChildScrollView(child: DataTable(horizontalMargin: 2, headingRowHeight: 0, dataRowHeight: 95, columnSpacing: 2, columns: columns, rows: rows));
  }

  void _cancel() {
    Navigator.pop(context);
  }
}
