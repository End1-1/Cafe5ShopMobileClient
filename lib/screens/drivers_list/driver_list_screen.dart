import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/utils/data_types.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:flutter/material.dart';

class DriverListScreen extends StatelessWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const ts = TextStyle(color: Colors.black, fontSize: 18);
    return FutureBuilder<List<Driver>>(
      future: _getList(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(10),
              color: Colors.white,
              height: 300,
              width: 600,
              child: SingleChildScrollView(
                  child: Wrap(
                direction: Axis.vertical,
                children: [
                  for (var d in snapshot.data!) ...[
                    InkWell(onTap: (){
                      Navigator.pop(context, d.id);
                    }, child: Container(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10), child:
                    Text(
                      d.name,
                      style: ts,
                    )))
                  ]
                ],
              )));
        }
        if (snapshot.hasError) {}
        return Container(color: Colors.white, child: Loading(tr('Get driver list...')));
      },
    );
  }

  Future<List<Driver>> _getList() async {
    return Lists.drivers.values.toList();
  }
}
