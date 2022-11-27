import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/class_car_model.dart';
import 'package:cafe5_shop_mobile_client/class_dish.dart';
import 'package:cafe5_shop_mobile_client/class_dishpart1.dart';
import 'package:cafe5_shop_mobile_client/class_dishpart2.dart';
import 'package:cafe5_shop_mobile_client/class_hall.dart';
import 'package:cafe5_shop_mobile_client/class_menudish.dart';
import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/class_table.dart';
import 'package:cafe5_shop_mobile_client/config.dart';
import 'package:cafe5_shop_mobile_client/db.dart';
import 'package:cafe5_shop_mobile_client/network_table.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widget_halls.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'class_dish_comment.dart';
import 'class_dishes_special_comment_dlg.dart';

class WidgetHome extends StatefulWidget {
  WidgetHome({super.key}) {
    print("Create WidgetHome");
  }

  @override
  State<StatefulWidget> createState() {
    return WidgetHomeState();
  }
}

class WidgetHomeState extends BaseWidgetState with TickerProviderStateMixin {
  bool _dataLoading = false;
  bool _showPin = false;
  String _progressString = "";
  late AnimationController animationController;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    animationController.repeat(reverse: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Config.getString(key_session_id).isNotEmpty) {
        SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_login_pashhash);
        m.addString(Config.getString(key_session_id));
        m.addString(Config.getString(key_firebase_token));
        sendSocketMessage(m);
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void handler(Uint8List data) async {
    _dataLoading = false;
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
        sd(tr(m.getString()));
        return;
      }
      switch (op) {
        case SocketMessage.op_login:
        case SocketMessage.op_login_pin:
          Config.setString(key_session_id, m.getString());
          Config.setString(key_fullname, m.getString());
          if (Config.getBool(key_data_dont_update)) {
            _startWithoutDataLoad();
            return;
          }
          m = SocketMessage.dllplugin(SocketMessage.op_get_hall_list);
          sendSocketMessage(m);
          setState(() {
            _progressString = tr("Loading list of halls");
          });
          break;
        case SocketMessage.op_login_pashhash:
          if (Config.getBool(key_data_dont_update)) {
            _startWithoutDataLoad();
            return;
          }
          m = SocketMessage.dllplugin(SocketMessage.op_get_hall_list);
          sendSocketMessage(m);
          setState(() {
            _progressString = tr("Loading list of halls");
          });
          break;
        case SocketMessage.op_get_hall_list:
          NetworkTable nt = NetworkTable();
          nt.readFromSocketMessage(m);
          Db.delete("delete from halls");
          for (int i = 0; i < nt.rowCount; i++) {
            Db.insert("insert into halls (id, name, menuid, servicevalue) values (?,?,?,?)", [nt.getRawData(i, 0), nt.getRawData(i, 1), nt.getRawData(i, 2), nt.getRawData(i, 3)]);
          }
          setState(() {
            _progressString = tr("Loading list of tables");
          });
          m = SocketMessage.dllplugin(SocketMessage.op_get_table_list);
          sendSocketMessage(m);
          break;
        case SocketMessage.op_get_table_list:
          NetworkTable nt = NetworkTable();
          nt.readFromSocketMessage(m);
          await Db.db!.transaction((txn) async {
            Batch b = txn.batch();
            b.delete("tables");
            for (int i = 0; i < nt.rowCount; i++) {
              b.insert("tables", {'id': nt.getRawData(i, 0), 'hall': nt.getRawData(i, 1), 'state': nt.getRawData(i, 2), 'name': nt.getRawData(i, 3), 'orderid': nt.getRawData(i, 4), 'q': i});
            }
            await b.commit();
          });

          setState(() {
            _progressString = tr("Loading list of dish part 1");
          });
          m = SocketMessage.dllplugin(SocketMessage.op_get_dish_part1_list);
          sendSocketMessage(m);
          break;
        case SocketMessage.op_get_dish_part1_list:
          NetworkTable nt = NetworkTable();
          nt.readFromSocketMessage(m);
          Db.delete("delete from dish_part1");
          for (int i = 0; i < nt.rowCount; i++) {
            Db.insert("insert into dish_part1 (id, name) values (?,?)", [nt.getRawData(i, 0), nt.getRawData(i, 1)]);
          }
          m = SocketMessage.dllplugin(SocketMessage.op_get_dish_part2_list);
          sendSocketMessage(m);
          setState(() {
            _progressString = tr("Loading list of dish part 2");
          });
          break;
        case SocketMessage.op_get_dish_part2_list:
          NetworkTable nt = NetworkTable();
          nt.readFromSocketMessage(m);
          await Db.db!.transaction((txn) async {
            Batch b = txn.batch();
            b.delete("dish_part2");
            for (int i = 0; i < nt.rowCount; i++) {
              b.insert("dish_part2", {'id': nt.getRawData(i, 0), 'parentid': nt.getRawData(i, 1), 'part1': nt.getRawData(i, 2), 'textcolor': nt.getRawData(i, 3), 'bgcolor': nt.getRawData(i, 4), 'name': nt.getRawData(i, 5), 'q': nt.getRawData(i, 6)});
            }
            await b.commit();
          });

          setState(() {
            _progressString = tr("Loading dishes");
          });
          m = SocketMessage.dllplugin(SocketMessage.op_get_dish_dish_list);
          sendSocketMessage(m);
          break;
        case SocketMessage.op_get_dish_dish_list:
          NetworkTable nt = NetworkTable();
          nt.readFromSocketMessage(m);
          await Db.db!.transaction((txn) async {
            Batch b = txn.batch();
            b.delete("dish");
            for (int i = 0; i < nt.rowCount; i++) {
              b.insert("dish", {'id': nt.getRawData(i, 0), 'part2': nt.getRawData(i, 1), 'bgcolor': nt.getRawData(i, 2), 'textcolor': nt.getRawData(i, 3), 'name': nt.getRawData(i, 4), 'q': nt.getRawData(i, 5), 'quicklist': nt.getRawData(i, 6)});
            }
            b.commit();
          });
          setState(() {
            _progressString = tr("Loading menu");
          });
          m = SocketMessage.dllplugin(SocketMessage.op_dish_menu);
          sendSocketMessage(m);
          break;
        case SocketMessage.op_dish_menu:
          NetworkTable nt = NetworkTable();
          nt.readFromSocketMessage(m);
          await Db.db!.transaction((txn) async {
            Batch b = txn.batch();
            b.delete("dish_menu");
            for (int i = 0; i < nt.rowCount; i++) {
              b.insert("dish_menu", {'id': i + 1, 'menuid': nt.getRawData(i, 0), 'typeid': nt.getRawData(i, 1), 'dishid': nt.getRawData(i, 2), 'price': nt.getRawData(i, 3), 'storeid': nt.getRawData(i, 4), 'print1': nt.getRawData(i, 5), 'print2': nt.getRawData(i, 6)});
            }
            await b.commit();
          });
          setState(() {
            _progressString = tr("Loading dish comments");
          });
          m = SocketMessage.dllplugin(SocketMessage.op_get_dish_comments);
          sendSocketMessage(m);
          break;
        case SocketMessage.op_get_dish_comments:
          NetworkTable nt = NetworkTable();
          nt.readFromSocketMessage(m);
          await Db.db!.transaction((txn) async {
            Batch b = txn.batch();
            b.delete("dish_comment");
            for (int i = 0; i < nt.rowCount; i++) {
              b.insert("dish_comment", {'id': nt.getRawData(i, 0), 'forid': nt.getRawData(i, 1), 'name': nt.getRawData(i, 2)});
            }
            await b.commit();
          });
          setState(() {
            _progressString = tr("Loading car models");
          });
          m = SocketMessage.dllplugin(SocketMessage.op_car_model);
          sendSocketMessage(m);
          break;
        case SocketMessage.op_car_model:
          NetworkTable nt = NetworkTable();
          nt.readFromSocketMessage(m);
          await Db.db!.transaction((txn) async {
            Batch b = txn.batch();
            b.delete("car_model");
            for (int i = 0; i < nt.rowCount; i++) {
              b.insert("car_model", {'id': nt.getRawData(i, 0), 'name': nt.getRawData(i, 1)});
            }
            await b.commit();
          });
          Config.setBool(key_data_dont_update, true);
          _startWithoutDataLoad();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    tr("Sign in"),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ))),
          Visibility(
              visible: false,
              child: Column(children: [
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 252,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
                        child: Row(children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              "images/user.png",
                              width: 40,
                              height: 40,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: TextFormField(
                              controller: _usernameController,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                hintText: tr("Username"),
                                hintStyle: const TextStyle(color: Colors.black12),
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ]))),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 252,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
                        child: Row(children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              "images/lock.png",
                              width: 40,
                              height: 40,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                hintText: tr("********"),
                                hintStyle: const TextStyle(color: Colors.black12),
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ]))),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 252,
                        height: 50,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              backgroundColor: Colors.blueGrey,
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.black38,
                                style: BorderStyle.solid,
                              ),
                            ),
                            onPressed: _login,
                            child: Text(tr("Login"), style: const TextStyle(color: Colors.white))))),
              ])),
          Align(
              child: SizedBox(
                  width: 72 * 3,
                  child: TextFormField(
                    obscureText: !_showPin,
                    controller: _pinController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    decoration: InputDecoration(
                        suffixIcon: ClassOutlinedButton.createImage(() {
                      setState(() {
                        _showPin = !_showPin;
                      });
                    }, _showPin ? "images/hidden.png" : "images/view.png")),
                  ))),
          Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClassOutlinedButton.create(() {
                            _pin("7");
                          }, "7", h: 72, w: 72),
                          ClassOutlinedButton.create(() {
                            _pin("8");
                          }, "8", h: 72, w: 72),
                          ClassOutlinedButton.create(() {
                            _pin("9");
                          }, "9", h: 72, w: 72),
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClassOutlinedButton.create(() {
                            _pin("4");
                          }, "4", h: 72, w: 72),
                          ClassOutlinedButton.create(() {
                            _pin("5");
                          }, "5", h: 72, w: 72),
                          ClassOutlinedButton.create(() {
                            _pin("6");
                          }, "6", h: 72, w: 72),
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClassOutlinedButton.create(() {
                            _pin("1");
                          }, "1", h: 72, w: 72),
                          ClassOutlinedButton.create(() {
                            _pin("2");
                          }, "2", h: 72, w: 72),
                          ClassOutlinedButton.create(() {
                            _pin("3");
                          }, "3", h: 72, w: 72),
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClassOutlinedButton.createImage(() {
                            _loginPin();
                          }, "images/user.png", h: 72, w: 72),
                          ClassOutlinedButton.create(() {
                            _pin("0");
                          }, "0", h: 72, w: 72),
                          ClassOutlinedButton.createImage(() {
                            _pinController.clear();
                          }, "images/cancel.png", h: 72, w: 72),
                        ],
                      ))
                ],
              )),
          Align(
              child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Visibility(
                      visible: _dataLoading,
                      child: CircularProgressIndicator(
                        value: animationController.value,
                      )))),
          Align(
            child: Container(margin: const EdgeInsets.only(top: 5), child: Visibility(visible: _progressString.isNotEmpty, child: Text(_progressString))),
          )
        ])));
  }

  void _login() {
    if (_dataLoading) {
      return;
    }
    setState(() {
      _dataLoading = true;
      _progressString = "";
    });
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_login);
    m.addString(_usernameController.text);
    m.addString(_passwordController.text);
    sendSocketMessage(m);
  }

  void _loginPin() {
    if (_dataLoading) {
      return;
    }
    setState(() {
      _dataLoading = true;
      _progressString = "";
    });
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_login_pin);
    m.addString(_pinController.text);
    m.addString(Config.getString(key_firebase_token));
    sendSocketMessage(m);
  }

  void _pin(String t) {
    _pinController.text += t;
  }

  void _startWithoutDataLoad() async {
    print(DateTime.now());

    await Db.query("halls").then((map) {
      ClassHall.list.clear();
      List.generate(map.length, (i) {
        ClassHall ch = ClassHall(id: map[i]["id"], name: map[i]["name"], menu: map[i]["menuid"], servicevalue: map[i]["servicevalue"]);
        ClassHall.list.add(ch);
      });
    });

    await Db.query("tables", orderBy: "q").then((map) {
      ClassTable.list.clear();
      List.generate(map.length, (i) {
        ClassTable ct = ClassTable(id: map[i]["id"], name: map[i]["name"], stateid: map[i]["state"], hallid: map[i]["hall"]);
        ClassTable.list.add(ct);
      });
    });

    await Db.query("car_model").then((map) {
      ClassCarModel.carModels.clear();
      List.generate(map.length, (i) {
        ClassCarModel cm = ClassCarModel(id: map[i]["id"], name: map[i]["name"]);
        ClassCarModel.carModels.add(cm);
      });
    });

    await Db.query("dish_part1").then((map) {
      ClassDishPart1.list.clear();
      List.generate(map.length, (i) {
        ClassDishPart1 cd = ClassDishPart1(map[i]["id"], map[i]["name"]);
        ClassDishPart1.list.add(cd);
      });
    });

    await Db.query("dish_part2", orderBy: "q").then((map) {
      ClassDishPart2.list.clear();
      List.generate(map.length, (i) {
        ClassDishPart2 cd = ClassDishPart2(map[i]["id"], map[i]["parentid"], map[i]["part1"], map[i]["name"]);
        cd.bgColor = Color(map[i]["bgcolor"]);
        cd.textColor = Color(map[i]["textcolor"]);
        ClassDishPart2.list.add(cd);
      });
    });

    await Db.query("dish").then((map) {
      ClassDish.map.clear();
      List.generate(map.length, (i) {
        ClassDish cd = ClassDish(map[i]["id"], map[i]["part2"], map[i]["name"], map[i]["quicklist"]);
        cd.bgColor = Color(map[i]["bgcolor"]);
        cd.textColor = Color(map[i]["textcolor"]);
        ClassDish.map[cd.id] = cd;
      });
    });

    await Db.query("dish_menu", orderBy: "id").then((map) {
      ClassMenuDish.list.clear();
      List.generate(map.length, (i) {
        ClassMenuDish cm = ClassMenuDish(map[i]["menuid"], map[i]["typeid"], map[i]["dishid"], map[i]["price"], map[i]["print1"], map[i]["print2"], map[i]["storeid"]);
        ClassMenuDish.list.add(cm);
      });
    });
    ClassMenuDish.buildPart2();

    await Db.query("dish_comment").then((map) {
      ClassDishComment.list.clear();
      List.generate(map.length, (i) {
        ClassDishComment cm = ClassDishComment(map[i]["id"], map[i]["forid"], map[i]["name"]);
        ClassDishComment.list.add(cm);
      });
      ClassDishesSpecialCommentDlg.init();
    });

    print(DateTime.now());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetHalls()), (route) => false);
  }
}
