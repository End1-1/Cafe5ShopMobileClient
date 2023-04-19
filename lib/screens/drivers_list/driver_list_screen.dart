import 'package:cafe5_shop_mobile_client/models/http_query/http_query.dart';
import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:cafe5_shop_mobile_client/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
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
    return FutureBuilder(
      future: _getList(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {

        }
        if (snapshot.hasError) {

        }
        return Loading(tr('Get driver list...'));
    },);
  }

  Future<List<Driver>> _getList() async {
    List<Driver> l = [];
    Map<String, Object?> data = {};
    await HttpQuery(hqDriverList).request(data);
    return l;
  }
}