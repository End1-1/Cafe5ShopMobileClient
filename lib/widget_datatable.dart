import 'package:cafe5_shop_mobile_client/network_table.dart';
import 'package:flutter/cupertino.dart';

class WidgetNetworkDataTable extends StatefulWidget {
  final NetworkTable networkTable;

  const WidgetNetworkDataTable({super.key, required this.networkTable});

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
        l.add(Container(padding: const EdgeInsets.only(left: 2), width: 100, height: 30, decoration: BoxDecoration(border: Border.all()), child: Text(overflow: TextOverflow.ellipsis, widget.networkTable.columnName(i))));
      }
    } else {
      for (int i = 0; i < widget.networkTable.columnCount; i++) {
        Color color = _currentIndex == index - 1 ? const Color(0x00a3a3a2) : const Color(0x00fff00);
        l.add(Container(padding: const EdgeInsets.only(left: 2), width: 100, height: 30, decoration: BoxDecoration(color: color, border: Border.all()), child: Text(overflow: TextOverflow.ellipsis, widget.networkTable.getDisplayData(index - 1, i))));
      }
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Column(children: _rows())));
  }
}
