import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/class_car_model.dart';
import 'package:cafe5_shop_mobile_client/class_customer.dart';
import 'package:cafe5_shop_mobile_client/class_dish.dart';
import 'package:cafe5_shop_mobile_client/class_dishpart1.dart';
import 'package:cafe5_shop_mobile_client/class_dishpart2.dart';
import 'package:cafe5_shop_mobile_client/class_hall.dart';
import 'package:cafe5_shop_mobile_client/class_menudish.dart';
import 'package:cafe5_shop_mobile_client/class_orderdish.dart';
import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/class_table.dart';
import 'package:cafe5_shop_mobile_client/config.dart';
import 'package:cafe5_shop_mobile_client/network_table.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/widget_setcar.dart';
import 'package:cafe5_shop_mobile_client/widget_tables.dart';
import 'package:cafe5_shop_mobile_client/window_dish_comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'class_dishes_special_comment_dlg.dart';
import 'class_set_qty_dlg.dart';

class WidgetOrderWindow extends StatefulWidget {
  ClassTable table;

  WidgetOrderWindow({required this.table});

  @override
  State<StatefulWidget> createState() {
    return WidgetOrderWindowState();
  }
}

class WidgetOrderWindowState extends BaseWidgetState<WidgetOrderWindow> {
  bool _dataLoading = false;
  bool _dataError = false;
  String _dataErrorString = "";
  bool _hideMenu = true;
  int _menuAnimationDuration = 300;
  double _startx = 0;
  double _menuWidth = 0;
  double _screenWidth = 0;
  int _menuType = 1;
  int _prevMenuType = 1;
  int _part1Filter = 0;
  String _dishSearchFilter = "";
  bool _searchVisible = false;
  int _selectedType = 0;
  int _selectedOrderDishIndex = -1;
  List<ClassOrderDish> _orderDishes = [];
  final ScrollController _orderScrollController = ScrollController();
  ClassMenuDish? tempDish;

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
      int op = 0, dllok = 0;
      try {
        op = m.getInt();
        dllok = m.getByte();
      } catch (e) {
        print(e);
        await sd(tr("Data error"));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetTables(hall: widget.table.hallid)), (route) => false);
        return;
      }
      if (dllok == 0) {
        await sd(m.getString());
        if (op == SocketMessage.op_open_table) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetTables(hall: widget.table.hallid)), (route) => false);
        }
        return;
      }
      switch (op) {
        case SocketMessage.op_open_table:
          widget.table.orderid = m.getString();
          widget.table.owner = m.getString();
          if (widget.table.orderid!.isNotEmpty) {
            SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_get_car);
            m.addString(widget.table.orderid!);
            sendSocketMessage(m);
          }
          break;
        case SocketMessage.op_unlock_table:
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetTables(hall: widget.table.hallid)), (route) => false);
          break;
        case SocketMessage.op_get_car:
          widget.table.car = ClassCarModel.getCar(m.getInt());
          widget.table.car!.licensePlate = m.getString();
          widget.table.customer = ClassCustomer(id: m.getInt(), name: m.getString(), phone: m.getString());
          m = SocketMessage.dllplugin(SocketMessage.op_open_order);
          m.addString(widget.table.orderid!);
          sendSocketMessage(m);
          break;
        case SocketMessage.op_open_order:
          setState(() {
            NetworkTable ntdishes = NetworkTable();
            ntdishes.readFromSocketMessage(m);
            _orderDishes.clear();
            for (int i = 0; i < ntdishes.rowCount; i++) {
              ClassOrderDish co = ClassOrderDish(
                ntdishes.getRawData(i, 0).toString(),
                ntdishes.getRawData(i, 1),
                ntdishes.getRawData(i, 2),
                ntdishes.getRawData(i, 3),
                ntdishes.getRawData(i, 4),
                ntdishes.getRawData(i, 5),
                ntdishes.getRawData(i, 6),
                ntdishes.getRawData(i, 7),
                ntdishes.getRawData(i, 8),
                ntdishes.getRawData(i, 9),
                ntdishes.getRawData(i, 10),
              );
              _orderDishes.add(co);
            }
          });
          break;
        case SocketMessage.op_create_header:
          int isNewOrder = m.getByte();
          String orderid = m.getString();
          widget.table.orderid = orderid;
          if (tempDish != null) {
            _sendDishToServer(tempDish!);
          }
          break;
        case SocketMessage.op_add_dish_to_order:
          setState(() {
            ClassOrderDish co = ClassOrderDish(m.getString(), m.getInt(), m.getDouble(), m.getDouble(), m.getDouble(), m.getDouble(), m.getDouble(), m.getInt(), m.getString(), m.getString(), m.getString());
            _orderDishes.add(co);
            _orderScrollController.jumpTo(_orderScrollController.position.maxScrollExtent);
          });
          break;
        case SocketMessage.op_remove_dish_from_order:
          String recid = m.getString();
          setState(() {
            for (ClassOrderDish co in _orderDishes) {
              if (co.id == recid) {
                _orderDishes.remove(co);
                return;
              }
            }
            _selectedOrderDishIndex = -1;
          });
          break;
        case SocketMessage.op_modify_order_dish:
          String recid = m.getString();
          double qty = m.getDouble();
          String comment = m.getString();
          setState(() {
            for (ClassOrderDish co in _orderDishes) {
              if (co.id == recid) {
                co.qty = qty;
                co.comment = comment;
                return;
              }
            }
          });
          break;
        case SocketMessage.op_print_service:
          m = SocketMessage.dllplugin(SocketMessage.op_open_order);
          m.addString(widget.table.orderid!);
          sendSocketMessage(m);
          setState(() {
            _selectedOrderDishIndex = -1;
          });
          break;
        case SocketMessage.op_create_header:
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _screenWidth = MediaQuery.of(context).size.width;
      _menuWidth = _screenWidth - (_screenWidth / 3);
      SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_open_table);
      m.addInt(widget.table.id);
      m.addString(Config.getString(key_session_id));
      sendSocketMessage(m);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('app resumed');
        break;

      case AppLifecycleState.inactive:
        print('app inactive');
        break;

      case AppLifecycleState.paused:
        SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_unlock_table);
        m.addInt(widget.table.id);
        m.addString(Config.getString(key_session_id));
        sendSocketMessage(m);
        break;

      case AppLifecycleState.detached:
        print('app deatched');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.all(5),
            child: Stack(children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Visibility(
                    visible: _dataErrorString.isNotEmpty,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(_dataErrorString),
                    )),
                Row(children: [
                  ClassOutlinedButton.createImage(() {
                    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_unlock_table);
                    m.addInt(widget.table.id);
                    m.addString(Config.getString(key_session_id));
                    sendSocketMessage(m);
                  }, "images/back.png"),
                  Expanded(child: Container()),
                  Row(children: [Text(widget.table.name, style: const TextStyle(fontWeight: FontWeight.bold)), const Text(", "), Text(widget.table.owner.isEmpty ? Config.getString(key_fullname) : widget.table.owner, style: const TextStyle(fontWeight: FontWeight.bold))]),
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
                            setState(() {
                              _hideMenu = false;
                              _startx = 0;
                            });
                          },
                          child: Image.asset("images/menu.png", width: 36, height: 36))),
                ]),
                Container(
                  color: Colors.blueGrey,
                  height: 5,
                ),
                Visibility(
                  visible: Config.getInt(key_protocol_version) == 3,
                  child: Row(children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 5, top: 2, right: 5),
                            height: 36,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.only(left: 5),
                                ),
                                onPressed: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetSetCar(table: widget.table))).then((result) {
                                    if (result == null) {
                                      return;
                                    }
                                    setState(() {
                                      widget.table = result;
                                    });
                                  });
                                },
                                child: Row(children: [
                                  Image.asset("images/car.png"),
                                  Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Container(margin: const EdgeInsets.only(left: 5), child: Text(_getCarTitle())))),
                                ])))),
                    ClassOutlinedButton.createImage(() {
                      if (widget.table.customer != null) {
                        launchUrl(Uri(scheme: "tel", path: widget.table.customer!.phone));
                      }
                    }, "images/call.png")
                  ]),
                ),
                Expanded(child: _orderDishesTable()),
                Container(
                    padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ClassOutlinedButton.createImage(() {
                          if (_selectedOrderDishIndex < 0) {
                            return;
                          }
                          final ClassOrderDish co = _orderDishes.elementAt(_selectedOrderDishIndex);
                          if (co.qtyprint > 0) {
                            SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_add_dish_to_order);
                            m.addString(widget.table.orderid!);
                            m.addInt(co.dishid);
                            m.addDouble(co.price);
                            m.addInt(co.storeid);
                            m.addString(co.print1);
                            m.addString(co.print2);
                            sendSocketMessage(m);
                            return;
                          }

                          SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_modify_order_dish);
                          m.addString(co.id);
                          m.addDouble(co.qty + 1);
                          m.addString(co.comment);
                          sendSocketMessage(m);
                        }, "images/plus.png", h: 48, w: 48),
                        ClassOutlinedButton.createImage(() {
                          if (_selectedOrderDishIndex < 0) {
                            return;
                          }
                          final ClassOrderDish co = _orderDishes.elementAt(_selectedOrderDishIndex);
                          if (co.qty <= 1 && co.qtyprint < 0.01) {
                            SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_remove_dish_from_order);
                            m.addString(co.id);
                            sendSocketMessage(m);
                            return;
                          }
                          if (co.qty > 1 && co.qtyprint < 0.01) {
                            SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_modify_order_dish);
                            m.addString(co.id);
                            m.addDouble(co.qty - 1);
                            m.addString(co.comment);
                            sendSocketMessage(m);
                          }
                        }, "images/minus.png", h: 48, w: 48),
                        ClassOutlinedButton.createImage(() async {
                          if (_selectedOrderDishIndex < 0) {
                            return;
                          }
                          final ClassOrderDish co = _orderDishes.elementAt(_selectedOrderDishIndex);
                          if (co.qtyprint > 0.01) {
                            return;
                          }
                          var qty = await ClassSetQtyDlg.getQty(context, ClassDish.map[co.dishid]!.name);
                          if (qty == null) {
                            return;
                          }
                          if (qty == -1000) {
                            SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_remove_dish_from_order);
                            m.addString(co.id);
                            sendSocketMessage(m);
                            return;
                          }
                          if (qty < 0) {
                            co.qty += qty * -1;
                          } else {
                            co.qty = qty!;
                          }
                          SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_modify_order_dish);
                          m.addString(co.id);
                          m.addDouble(co.qty);
                          m.addString(co.comment);
                          sendSocketMessage(m);

                        }, "images/half.png", h: 48, w: 48),
                        ClassOutlinedButton.createImage(() {
                          if (_selectedOrderDishIndex < 0) {
                            return;
                          }
                          final ClassOrderDish co = _orderDishes.elementAt(_selectedOrderDishIndex);
                          if (co.qtyprint > 0.01) {
                            return;
                          }
                          if (co.qty > 0.01) {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetDishComment(co.dishid, co.comment))).then((value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                co.comment = value;
                              });
                              SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_modify_order_dish);
                              m.addString(co.id);
                              m.addDouble(co.qty);
                              m.addString(co.comment);
                              sendSocketMessage(m);
                            });
                          }
                        }, "images/message.png", h: 48, w: 48),
                        ClassOutlinedButton.createImage(() {
                          if (widget.table.orderid == null || widget.table.orderid!.isEmpty) {
                            return;
                          }
                          bool found = false;
                          for (ClassOrderDish co in _orderDishes) {
                            if (co.qtyprint < 0.01) {
                              found = true;
                              break;
                            }
                          }
                          if (found) {
                            sq(tr("Print order"), () {
                              SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_print_service);
                              m.addString(widget.table.orderid!);
                              sendSocketMessage(m);
                            }, () {});
                          }
                        }, "images/printer.png", h: 48, w: 48),
                        Expanded(
                            child: Container(
                          color: Colors.green,
                        )),
                        Visibility(
                            visible: Config.getInt(key_protocol_version) != 3,
                            child: ClassOutlinedButton.createImage(() {
                              if (widget.table.orderid == null || widget.table.orderid!.isEmpty) {
                                return;
                              }
                              bool found = false;
                              for (ClassOrderDish co in _orderDishes) {
                                if (co.qtyprint < 0.01) {
                                  found = true;
                                  break;
                                }
                              }
                              if (!found) {
                                sq(tr("Print bill"), () {
                                  SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_print_bill);
                                  m.addString(widget.table.orderid!);
                                  sendSocketMessage(m);
                                }, () {});
                              } else {
                                sd(tr("Order is not completed"));
                              }
                            }, "images/bill.png", h: 48, w: 48))
                      ],
                    ))
              ]),
              _orderMenu()
            ])));
  }

  Widget _orderDishesTable() {
    return ListView.builder(
        controller: _orderScrollController,
        itemCount: _orderDishes.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final ClassOrderDish co = _orderDishes.elementAt(index);
          return GestureDetector(
              onTap: () => setState(() {
                    _selectedOrderDishIndex = index;
                  }),
              child: Container(
                  height: co.comment.isEmpty ? 50 : 60,
                  color: index == _selectedOrderDishIndex ? const Color(0xA5DADEFF) : (co.qtyprint > 0.01 ? const Color(0xffffd561) : Colors.white),
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Container(
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color(0xffa0a0a0))),
                      ),
                      child: Row(
                        children: [
                          Container(
                              width: 40,
                              margin: const EdgeInsets.only(top: 2),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    num(co.qty),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ))),
                          Container(
                              width: 250,
                              height: co.comment.isEmpty ? 30 : 50,
                              margin: const EdgeInsets.only(top: 2),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(
                                      ClassDish.map[co.dishid]!.name,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Visibility(visible: co.comment.isNotEmpty, child: Text(co.comment))
                                  ]))),
                          Container(
                              margin: const EdgeInsets.only(top: 2),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    num(co.price * co.qty),
                                    style: const TextStyle(fontSize: 14),
                                  )))
                        ],
                      ))));
        });
  }

  String _getCarTitle() {
    String result = "";
    result += widget.table.car == null ? "" : widget.table.car!.name + ", " + widget.table.car!.licensePlate + ", " + widget.table.customer!.name;
    return result;
  }

  Widget _orderMenu() {
    return AnimatedPositioned(
        duration: Duration(milliseconds: _menuAnimationDuration),
        top: 0,
        right: _hideMenu ? -1 * (MediaQuery.of(context).size.width) : _startx,
        bottom: 0,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            _hideOrderMenu();
          },
          onPanUpdate: (details) {
            if (_startx - details.delta.dx > 0) {
              return;
            }
            setState(() {
              _startx -= details.delta.dx;
            });
          },
          onPanEnd: (details) {
            setState(() {
              if (_startx < -120) {
                _hideMenu = true;
              } else {
                _startx = 0;
              }
              _menuAnimationDuration = 300;
            });
          },
          child: Container(
              color: Colors.white10,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    width: _menuWidth,
                    child: Container(
                        padding: const EdgeInsets.only(top: 5),
                        color: const Color(0XffDDEEAA),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children: [
                              ClassOutlinedButton.createImage(() {
                                setState(() {
                                  if (_menuType == _prevMenuType) {
                                    _hideOrderMenu();
                                  } else {
                                    _menuType = _prevMenuType;
                                  }
                                });
                              }, "images/back.png"),
                              Visibility(visible: !_searchVisible, child: Expanded(child: Container())),
                              Visibility(
                                  visible: !_searchVisible,
                                  child: ClassOutlinedButton.createImage(() {
                                    setState(() {
                                      _prevMenuType = _menuType;
                                      _menuType = 3;
                                    });
                                  }, "images/favorite.png")),
                              Visibility(
                                  visible: !_searchVisible,
                                  child: ClassOutlinedButton.createImage(() {
                                    setState(() {
                                      _searchVisible = true;
                                    });
                                  }, "images/search.png")),
                              Visibility(
                                visible: _searchVisible,
                                child: Row(children: [
                                  SizedBox(
                                      width: 150,
                                      child: TextField(
                                        autofocus: true,
                                        onChanged: (txt) {
                                          if (txt.length < 3) {
                                            _dishSearchFilter = "";
                                            return;
                                          }
                                          setState(() {
                                            _menuType = 2;
                                            _dishSearchFilter = txt;
                                          });
                                        },
                                      )),
                                  ClassOutlinedButton.createImage(() {
                                    setState(() {
                                      _menuType = 1;
                                      _part1Filter = 0;
                                      _dishSearchFilter = "";
                                      _searchVisible = false;
                                    });
                                  }, "images/cancel.png")
                                ]),
                              )
                            ]),
                            Container(
                              height: 2,
                            ),
                            _part1(),
                            Expanded(child: _menuBody()),
                          ],
                        )),
                  )
                ],
              )),
        ));
  }

  Widget _dishes(bool quick) {
    ClassHall? h = ClassHall.getHall(widget.table.hallid);
    if (h == null) {
      return const Text("Hall is null");
    }

    int colCount = 2;
    List<DataColumn> columns = [];
    for (int i = 0; i < colCount; i++) {
      columns.add(const DataColumn(label: Text("")));
    }

    List<DataRow> rows = [];
    List<DataCell> cells = [];
    int col = 0;
    for (int i = 0; i < ClassMenuDish.list.length; i++) {
      final ClassMenuDish md = ClassMenuDish.list.elementAt(i);
      final ClassDish cd = ClassDish.map[md.dishid]!;
      if (quick) {
        if (cd.quicklist == 0) {
          continue;
        }
      } else {
        if (_dishSearchFilter.isNotEmpty) {
          if (h.menu != md.menuid || !cd.name.toLowerCase().contains(_dishSearchFilter.toLowerCase())) {
            continue;
          }
        } else if (_selectedType != md.typeid || h.menu != md.menuid) {
          continue;
        }
      }

      DataCell dc = DataCell(Container(margin: const EdgeInsets.only(top: 2), color: cd.bgColor, width: _menuWidth / colCount, child: Align(alignment: Alignment.center, child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Text(cd.name.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: cd.textColor, fontSize: 13, fontWeight: FontWeight.bold))), Container(width: double.infinity, height: 20, decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent), color: Colors.white), child: Text(textAlign: TextAlign.center, "${md.price}", style: const TextStyle(fontWeight: FontWeight.bold)))]))), onTap: () async {
        md.dish = cd;
        if (ClassDishesSpecialCommentDlg.specialCommentForDish(md.dishid)) {
          String? comment = await ClassDishesSpecialCommentDlg.getComment(context, md.dishid, cd.name);
          if (comment == null) {
            return;
          }
          md.comment = comment;
        }
        if (widget.table.orderid == null || widget.table.orderid!.isEmpty) {
          switch (Config.getInt(key_protocol_version)) {
            case 1:
            case 2:
              tempDish = md;
              SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_create_header);
              m.addInt(widget.table.id);
              sendSocketMessage(m);
              return;
            case 3:
              sd(tr("Set the car first"));
              return;
          }
        }
        _sendDishToServer(md);
      });
      cells.add(dc);
      col++;
      if (col >= colCount) {
        col = 0;
        rows.add(DataRow(cells: cells));
        cells = [];
      }
    }
    if (cells.isNotEmpty) {
      while (cells.length < colCount) {
        cells.add(const DataCell(Text("")));
      }
      rows.add(DataRow(cells: cells));
    }

    return SingleChildScrollView(child: DataTable(horizontalMargin: 2, headingRowHeight: 0, dataRowHeight: 95, columnSpacing: 2, columns: columns, rows: rows));
  }

  Widget _part1() {
    if (ClassDishPart1.list.isEmpty) {
      return Container();
    }
    return SizedBox(
        height: 30,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ClassDishPart1.list.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final ClassDishPart1 co = ClassDishPart1.list.elementAt(index);
              return GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(right: 3),
                  color: Colors.black12,
                  height: 30,
                  width: 100,
                  child: Align(alignment: Alignment.center, child: Text(co.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                ),
                onTap: () {
                  setState(() {
                    _menuType = 1;
                    _part1Filter = co.id;
                  });
                },
              );
            }));
  }

  Widget _part2(int level) {
    ClassHall? h = ClassHall.getHall(widget.table.hallid);
    if (h == null) {
      return const Text("Hall is null");
    }

    List<int> p1 = [];
    for (ClassDishPart2 p in ClassDishPart2.list) {
      if (_part1Filter > 0 && p.part1 != _part1Filter) {
        continue;
      }
      p1.add(p.id);
    }

    int colCount = 2;
    List<DataColumn> columns = [];
    for (int i = 0; i < colCount; i++) {
      columns.add(const DataColumn(label: Text("")));
    }

    List<DataRow> rows = [];
    List<DataCell> cells = [];
    int col = 0;
    final Set<int> availableList = ClassMenuDish.part2[h.menu]!;
    for (int i = 0; i < ClassDishPart2.list.length; i++) {
      final ClassDishPart2 d = ClassDishPart2.list.elementAt(i);
      if (d.parentid != level || !availableList.contains(d.id) || !p1.contains(d.id)) {
        continue;
      }
      DataCell dc = DataCell(
          Container(
              margin: const EdgeInsets.only(top: 2),
              color: d.bgColor,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(d.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: d.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      )))), onTap: () {
        setState(() {
          _selectedType = d.id;
          _menuType = 2;
        });
      });
      cells.add(dc);
      col++;
      if (col >= colCount) {
        col = 0;
        rows.add(DataRow(cells: cells));
        cells = [];
      }
    }
    if (cells.length > 0) {
      while (cells.length < colCount + 1) {
        cells.add(const DataCell(Text("")));
      }
      rows.add(DataRow(cells: cells));
    }

    return SingleChildScrollView(child: DataTable(horizontalMargin: 2, headingRowHeight: 0, columnSpacing: 2, columns: columns, rows: rows));
  }

  Widget _menuBody() {
    switch (_menuType) {
      case 0:
        return const Text("0");
      case 1:
        return _part2(0);
      case 2:
        return _dishes(false);
      case 3:
        return _dishes(true);
    }
    return const Text("No menu type selected");
  }

  void _hideOrderMenu() {
    setState(() {
      _hideMenu = true;
      _startx = 0;
      _menuAnimationDuration = 300;
    });
  }

  void _sendDishToServer(ClassMenuDish md) {
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_add_dish_to_order);
    m.addString(widget.table.orderid!);
    m.addInt(md.dish!.id);
    m.addDouble(md.price);
    m.addInt(md.storeid);
    m.addString(md.print1);
    m.addString(md.print2);
    m.addString(md.comment);
    sendSocketMessage(m);
    tempDish = null;
  }
}
