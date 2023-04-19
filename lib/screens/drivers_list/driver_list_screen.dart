import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_list_screen.freezed.dart';

part 'driver_list_screen.g.dart';

@freezed
class Driver with _$Driver {
  const factory Driver({required int id, required String name}) = _Driver;

  factory Driver.fromJson(Map<String, Object?> json) => _$DriverFromJson(json);
}

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
    List<Driver> l = [];
    Map<String, dynamic> data = {};
    if (await HttpQuery(hqDriverList).request(data) == hrOk) {
      for (var e in data[pkData]) {
        l.add(Driver.fromJson(e));
      }
    }
    return l;
  }
}
