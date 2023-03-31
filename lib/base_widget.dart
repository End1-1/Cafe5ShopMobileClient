import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widget_choose_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cafe5_shop_mobile_client/client_socket.dart';
import 'package:cafe5_shop_mobile_client/client_socket_interface.dart';

abstract class BaseWidgetState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver implements SocketInterface {

  List<int> _messageNumbers = [];

  @override
  void initState() {
    ClientSocket.socket.addInterface(this);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    print("Dispose ${this.runtimeType}");
    ClientSocket.socket.removeInterface(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        paused();
        break;
      case AppLifecycleState.resumed:
        resumed();
        break;
    }
  }

  void paused() {
  }

  void resumed() {
  }

  void sendSocketMessage(SocketMessage m) {
    _messageNumbers.add(m.messageId);
    ClientSocket.send(m);
  }

  bool checkSocketMessage(SocketMessage m) {
    return _messageNumbers.contains(m.messageId);
  }

  @override
  void authenticate() {
    setState(() {});
  }

  @override
  void connected() {
    setState(() {});
  }

  @override
  void disconnected() {
    print("Disconnected from ${this.runtimeType}");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetChooseSettings()), (route) => false);
  }

  @override
  void handler(Uint8List data) {
    // TODO: implement handler
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<void> sd(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(tr('Tasks')),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(tr(msg)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(tr("Ok")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sq(String msg, Function yes, Function no) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('Tasks')),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(msg),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(tr("Yes")),
              onPressed: () {
                Navigator.of(context).pop();
                if (yes != null) {
                  yes();
                }
              },
            ),
            TextButton(
              child: Text(tr("No")),
              onPressed: () {
                Navigator.of(context).pop();
                if (no != null) {
                  no();
                }
              },
            )
          ],
        );
      },
    );
  }
}
