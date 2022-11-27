import 'dart:async';
import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/home_page.dart';
import 'package:cafe5_shop_mobile_client/network_table.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/config.dart';
import 'package:cafe5_shop_mobile_client/db.dart';
import 'package:cafe5_shop_mobile_client/class_table.dart';
import 'package:cafe5_shop_mobile_client/widget_orderwindow.dart';
import 'package:cafe5_shop_mobile_client/widget_halls.dart';
import 'package:sqflite/sqlite_api.dart';

import 'class_outlinedbutton.dart';

class WidgetReadyDishes extends StatefulWidget {

  const WidgetReadyDishes({super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetReadyDishesState();
  }
}

class WidgetReadyDishesState extends BaseWidgetState<WidgetReadyDishes> {

  @override
  void handler(Uint8List data) async {
    SocketMessage m = SocketMessage(messageId: 0, command: 0);
    m.setBuffer(data);
    if (!checkSocketMessage(m)) {
      return;
    }
    print("command ${m.command}");
    if (m.command == SocketMessage.c_dllplugin) {
      int op = m.getInt();
      int dllok = m.getByte();
      if (dllok == 0) {
        sd(m.getString());
        return;
      }
      switch (op) {
        case SocketMessage.op_ready_dishes:
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshDishes();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _refreshDishes();
        break;

      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.paused:
        break;

      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 35),
            child: Stack(children: [
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(
                        width: 36,
                        height: 36,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(2),
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetHalls()), (route) => false);
                            },
                            child: Image.asset("images/back.png", width: 36, height: 36))),
                    Expanded(child: Container()),
                  ],
                  ),
                ])
    ])));
  }

  void _refreshDishes() {
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_ready_dishes);
    sendSocketMessage(m);
  }
}
