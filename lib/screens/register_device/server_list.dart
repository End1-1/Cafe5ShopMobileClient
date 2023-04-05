import 'package:cafe5_shop_mobile_client/utils/prefs.dart';
import 'package:flutter/material.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key});

  @override
  State<StatefulWidget> createState() => _ServerList();
}

class _ServerList extends State<ServerList> {
  final BoxDecoration _unselectedDecor = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(2)),
      gradient: RadialGradient(
          center: Alignment(-0.5, -0.6),
          colors: [Color(0xffdedede), Color(0xffa8a8a8)],
          radius: 2));

  final BoxDecoration _selectedDecor = const BoxDecoration(
      gradient: RadialGradient(
          center: Alignment(-0.5, -0.6),
          colors: [Color(0x9bade1fd), Color(0xff99aff6)],
          radius: 2));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var e in servers) ...[
          Row(children: [
            Expanded(
                child: Container(
                    decoration: prefs.getString(pkServerName) == e.keys.first
                        ? _selectedDecor
                        : _unselectedDecor,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            prefs.setString(pkServerName, e.keys.first);
                            prefs.setString(pkServerAddress,
                                e.values.first.split(':').first);
                            prefs.setString(
                                pkServerPort, e.values.first.split(':').last);
                          });
                        },
                        child: Text(
                          e.keys.first,
                        ))))
          ]),
          const SizedBox(height: 10)
        ]
      ],
    ));
  }
}
