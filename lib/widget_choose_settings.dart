import 'dart:typed_data';
import 'package:cafe5_shop_mobile_client/widget_manual_settings.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/config.dart';
import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/home_page.dart';

import 'client_socket.dart';

class WidgetChooseSettings extends StatefulWidget {
  const WidgetChooseSettings({super.key});
  @override
  State<StatefulWidget> createState() {
    return WidgetChooseSettingsState();
  }
}

class WidgetChooseSettingsState extends BaseWidgetState<WidgetChooseSettings> {

  @override
  void handler(Uint8List data) {
    SocketMessage m = SocketMessage(messageId: 0, command: 0);
    m.setBuffer(data);
    if (!checkSocketMessage(m)) {
      return;
    }
    print("command ${m.command}");
    switch (m.command) {
      case SocketMessage.c_hello:
        m = SocketMessage(messageId: SocketMessage.messageNumber(), command: SocketMessage.c_auth);
        m.addString(Config.getString(key_server_username));
        m.addString(Config.getString(key_server_password));
        sendSocketMessage(m);
        break;
      case SocketMessage.c_auth:
        int userid = m.getInt();
        if (userid > 0) {
          ClientSocket.setSocketState(2);
        }
        break;
    }
  }

  @override
  void connected(){
    print("WidgetChooseSettings.connected()");
    SocketMessage.resetPacketCounter();
    SocketMessage m = SocketMessage(messageId: SocketMessage.messageNumber(), command: SocketMessage.c_hello);
    sendSocketMessage(m);
  }

  @override
  void authenticate() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetHome()), (route) => false);
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetHome()));
  }

  @override
  void disconnected() {
    setState((){});
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Image(image: AssetImage(ClientSocket.imageConnectionState()),)
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: ()  {
                    FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR).then((barcodeScanRes) {
                      List<String> params = barcodeScanRes.split(";");
                      if (params.length >= 5) {
                        Config.setString(key_server_address, params[0]);
                        Config.setString(key_server_port, params[1]);
                        Config.setString(key_server_username, params[2]);
                        Config.setString(key_server_password, params[3]);
                        Config.setString(key_database_name, params[4]);
                        ClientSocket.init(Config.getString(key_server_address), int.tryParse(Config.getString(key_server_port)) ?? 0);
                      }
                    });},
                  child: Text(tr("Scan from QR code")),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetManualSettings()));
                  },
                  child: Text(tr("Input manual")),
                ),
              )
            ]
        )
    );
  }
}