import 'package:cafe5_shop_mobile_client/network_table.dart';
import 'package:flutter/cupertino.dart';

abstract class WidgetNetDataTableRowClick {
  void onRowClick(dynamic data);
}

class WidgetNetworkDataTable extends StatefulWidget {
  final NetworkTable networkTable;
  final List<double> columnWidths;
  WidgetNetDataTableRowClick? onRowClick;

  WidgetNetworkDataTable({super.key, required this.networkTable, this.columnWidths = const [], this.onRowClick});

  @override
  State<StatefulWidget> createState() {
    return WidgetNetworkDataTableState();
  }
}

class WidgetNetworkDataTableState extends State<WidgetNetworkDataTable> {
  int _currentIndex = -1;

  List<Widget> _rows() {
    List<Widget> l = [];
    for (int i = 0; i < widget.networkTable.rowCount + 1; i++) {
      l.add(GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = i - 1;
              if (widget.onRowClick != null && _currentIndex > -1) {
                widget.onRowClick!.onRowClick(widget.networkTable.getRawData(_currentIndex, 0));
              }
            });
          },
          child: Row(children: _row(i))));
    }
    return l;
  }

  List<Widget> _row(int index) {
    List<Widget> l = [];
    if (index == 0) {
      for (int i = 0; i < widget.networkTable.columnCount; i++) {
        double colWidth = widget.columnWidths.isEmpty ? 100 : widget.columnWidths[i];
        l.add(Container(padding: const EdgeInsets.only(left: 2), width: colWidth, height: 30, decoration: BoxDecoration(border: Border.all()), child: Text(overflow: TextOverflow.ellipsis, widget.networkTable.columnName(i))));
      }
    } else {
      for (int i = 0; i < widget.networkTable.columnCount; i++) {
        double colWidth = widget.columnWidths.isEmpty ? 100 : widget.columnWidths[i];
        Color color = _currentIndex == index - 1 ? const Color(0x00a3a3a2) : const Color(0x00fff00);
        l.add(Container(padding: const EdgeInsets.only(left: 2), width: colWidth, height: 30, decoration: BoxDecoration(color: color, border: Border.all()), child: Text(overflow: TextOverflow.ellipsis, widget.networkTable.getDisplayData(index - 1, i))));
      }
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Column(children: _rows())));
  }
}
