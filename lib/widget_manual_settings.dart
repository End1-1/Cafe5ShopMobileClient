import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/client_socket.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/widget_tables.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/config.dart';
import 'package:cafe5_shop_mobile_client/db.dart';
import 'package:cafe5_shop_mobile_client/class_table.dart';
import 'package:cafe5_shop_mobile_client/class_customer.dart';
import 'package:cafe5_shop_mobile_client/class_car_model.dart';
import 'package:cafe5_shop_mobile_client/widget_tables.dart';

class WidgetManualSettings extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return WidgetManualSettingsState();
  }
}

class WidgetManualSettingsState extends State<WidgetManualSettings> {

  final TextEditingController _eServer = TextEditingController(text: Config.getString(key_server_address));
  final TextEditingController _ePort = TextEditingController(text: Config.getString(key_server_port));
  final TextEditingController _eUser = TextEditingController(text: Config.getString(key_server_username));
  final TextEditingController _ePassword = TextEditingController(text: Config.getString(key_server_password));
  final TextEditingController _eDatabase = TextEditingController(text: Config.getString(key_database_name));
  final TextEditingController _eProtocol = TextEditingController(text: Config.getInt(key_protocol_version).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 5,
              ),
              Row(children: [
                Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(left: 5),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(2),
                        ),
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                        child: Image.asset("images/cancel.png", width: 36, height: 36))),
                Expanded(child: Container()),
                Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(2),
                        ),
                        onPressed: () {
                          Config.setString(key_server_address, _eServer.text);
                          Config.setString(key_server_port, _ePort.text);
                          Config.setString(key_server_username, _eUser.text);
                          Config.setString(key_server_password, _ePassword.text);
                          Config.setString(key_database_name, _eDatabase.text);
                          Config.setInt(key_protocol_version, int.tryParse(_eProtocol.text)!);
                          ClientSocket.init(Config.getString(key_server_address), int.tryParse(Config.getString(key_server_port)) ?? 0);
                          Navigator.pop(context, null);
                        },
                        child: Image.asset("images/done.png", width: 36, height: 36))),
              ]),
              Align(alignment: Alignment.topLeft, child: Container(margin: const EdgeInsets.only(left: 5, top: 15), child: Text(tr("Server")))),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: _eServer,
                      )),
                  SizedBox(
                      width: 36,
                      height: 36,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            _eServer.clear();
                          },
                          child: Image.asset("images/cancel.png"))),
                ],
              ),

              Align(alignment: Alignment.topLeft, child: Container(margin: const EdgeInsets.only(left: 5, top: 15), child: Text(tr("Port")))),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: _ePort,
                      )),
                  SizedBox(
                      width: 36,
                      height: 36,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            _ePort.clear();
                          },
                          child: Image.asset("images/cancel.png")))
                ],
              ),
              Align(alignment: Alignment.topLeft, child: Container(margin: const EdgeInsets.only(left: 5, top: 15), child: Text(tr("Username")))),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: _eUser,
                      )),
                  SizedBox(
                      width: 36,
                      height: 36,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            _eUser.clear();
                          },
                          child: Image.asset("images/cancel.png"))),
                ],
              ),
              Align(alignment: Alignment.topLeft, child: Container(margin: const EdgeInsets.only(left: 5, top: 15), child: Text(tr("Password")))),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: _ePassword,
                      )),
                  SizedBox(
                      width: 36,
                      height: 36,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            _ePassword.clear();
                          },
                          child: Image.asset("images/cancel.png"))),
                ],
              ),
              Align(alignment: Alignment.topLeft, child: Container(margin: const EdgeInsets.only(left: 5, top: 15), child: Text(tr("Database")))),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: _eDatabase,
                      )),
                  SizedBox(
                      width: 36,
                      height: 36,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            _eDatabase.clear();
                          },
                          child: Image.asset("images/cancel.png"))),
                ],
              ),
              Align(alignment: Alignment.topLeft, child: Container(margin: const EdgeInsets.only(left: 5, top: 15), child: Text(tr("Protocol")))),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: _eProtocol,
                      )),
                  SizedBox(
                      width: 36,
                      height: 36,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            _eProtocol.clear();
                          },
                          child: Image.asset("images/cancel.png"))),
                ],
              ),
            ]))));
  }


}
