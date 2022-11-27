import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
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

class WidgetSetCar extends StatefulWidget {
  final ClassTable table;

  WidgetSetCar({required this.table});

  @override
  State<StatefulWidget> createState() {
    return WidgetSetCarState();
  }
}

class WidgetSetCarState extends BaseWidgetState<WidgetSetCar> {

  ClassCarModel? _carModel;
  ClassCustomer? _customer;
  TextEditingController _carNameController = TextEditingController();
  TextEditingController _plateController = TextEditingController();
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _customerPhoneController = TextEditingController();
  FocusNode _carNameFocusNode = FocusNode();
  GlobalKey _carNameKey = GlobalKey();

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
          case SocketMessage.op_search_licenseplate:
            _setModel(m.getInt());
            _setCustomer(m.getInt(), m.getString(), m.getString());
            break;
        case SocketMessage.op_set_car:
          widget.table.orderid = m.getString();
          _customer = ClassCustomer(id: m.getInt(), name: m.getString(), phone: m.getString());
          widget.table.car = _carModel;
          widget.table.customer = _customer;
          Navigator.of(context).pop(widget.table);
          break;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        if (widget.table.car != null) {
          _carModel = widget.table.car;
          _plateController.text = _carModel!.licensePlate;
          _carNameController.text = _carModel!.name;
        }
        if (widget.table.customer != null) {
          _customer = widget.table.customer;
          _customerNameController.text = _customer!.name;
          _customerPhoneController.text = _customer!.phone;
        }
      });
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
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 5,
      ),
      Row(children: [
        Container(
            width: 36,
            height: 36,
            margin: EdgeInsets.only(left: 5),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(2),
                ),
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: Image.asset("images/cancel.png", width: 36, height: 36))),
        Expanded(child: Container()),
        Container(width: 36, height: 36, margin: EdgeInsets.only(left: 5), child: Align(alignment: Alignment.center, child: Text(widget.table.name))),
        Container(
            width: 36,
            height: 36,
            margin: EdgeInsets.only(left: 5, right: 5),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(2),
                ),
                onPressed: () {
                  _setCar();
                },
                child: Image.asset("images/done.png", width: 36, height: 36))),
      ]),
      Align(alignment: Alignment.topLeft, child: Container(margin: EdgeInsets.only(left: 5, top: 15), child: Text(tr("Car plate number")))),
      Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: _plateController,
          )),
          SizedBox(
              width: 36,
              height: 36,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                  onPressed: () {
                    _plateController.clear();
                  },
                  child: Image.asset("images/cancel.png"))),
          Container(
              margin: const EdgeInsets.only(left: 5),
              width: 36,
              height: 36,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                  onPressed: () {
                    SocketMessage m = SocketMessage(messageId: SocketMessage.messageNumber(), command: SocketMessage.c_dllplugin);
                    m.addString(SocketMessage.waiterclientp);
                    m.addInt(SocketMessage.op_search_licenseplate);
                    m.addByte(3);
                    m.addString(_plateController.text);
                    sendSocketMessage(m);
                  },
                  child: Image.asset("images/search.png")))
        ],
      ),
      Align(alignment: Alignment.topLeft, child: Container(margin: EdgeInsets.only(left: 5, top: 15), child: Text(tr("Car model")))),
      Row(children: [
        Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 5, right: 5, top: 15),
                child: RawAutocomplete<ClassCarModel>(
                  textEditingController: _carNameController,
                  key: _carNameKey,
                  focusNode: _carNameFocusNode,
                  displayStringForOption: (cm) => cm.name,
                  optionsBuilder: (TextEditingValue t) {
                    return ClassCarModel.carModels.where((cm) {
                      return cm.name.toLowerCase().startsWith(t.text.toLowerCase());
                    }).toList();
                  },
                  fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                    return TextFormField(controller: fieldTextEditingController, focusNode: fieldFocusNode);
                  },
                  optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<ClassCarModel> onSelected, Iterable<ClassCarModel> options) {
                    return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          child: Container(
                              width: 300,
                              height: 400,
                              child: ListView.builder(
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    final ClassCarModel cm = options.elementAt(i);
                                    return GestureDetector(
                                        onTap: () {
                                          onSelected(cm);
                                        },
                                        child: ListTile(title: Text(cm.name)));
                                  })),
                        ));
                  },
                  onSelected: (cm) {
                    _carModel = cm;
                  },
                ))),
        SizedBox(
            width: 36,
            height: 36,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {
                  _carNameController.clear();
                  _carModel = null;
                },
                child: Image.asset("images/cancel.png")))
      ]),
      Align(alignment: Alignment.topLeft, child: Container(margin: EdgeInsets.only(left: 5, top: 15), child: Text(tr("Customer name")))),
      Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: _customerNameController,
          )),
          ClassOutlinedButton.createImage((){
            setState(() {
              _customerNameController.text = tr("Unknown");
            });
          }, "images/question.png"),
          SizedBox(
              width: 36,
              height: 36,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                  onPressed: () {
                    _customerNameController.clear();
                  },
                  child: Image.asset("images/cancel.png")))
        ],
      ),
              Align(alignment: Alignment.topLeft, child: Container(margin: EdgeInsets.only(left: 5, top: 15), child: Text(tr("Customer phone number")))),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: _customerPhoneController,
                      )),
                  SizedBox(
                      width: 36,
                      height: 36,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            _customerPhoneController.clear();
                          },
                          child: Image.asset("images/cancel.png")))
                ],
              ),
      Expanded(child: Container(child: GestureDetector(
        onTap: () {
          _carNameFocusNode.nextFocus();
        },
      )))
    ])));
  }

  void _setModel(int id) {
    for (int i = 0; i < ClassCarModel.carModels.length; i++) {
      final ClassCarModel cm = ClassCarModel.carModels.elementAt(i);
      if (cm.id == id) {
        _carNameController.text = cm.name;
        _carModel = cm;
        return;
      }
    }
    _carModel = null;
    _carNameController.clear();
  }

  void _setCustomer(int id, String name, String phone) {
    _customerNameController.text = name;
    _customerPhoneController.text = phone;
    _customer = ClassCustomer(id: id, name: name, phone: phone);
  }

  void _setCar() {
    if (_plateController.text.length < 5) {
      sd(tr("Incorrect license plate"));
      return;
    }
    if (_carModel == null) {
      sd(tr("Select car model"));
      return;
    }
    if (_carModel!.id == 0) {
      sd(tr("Select car model"));
      return;
    }
    if (_customerNameController.text.isEmpty) {
      sd(tr("Enter the customer name"));
      return;
    }
    if (widget.table.orderid == null || widget.table.orderid!.isEmpty) {
      sq(tr("Create new order?"), (){
        _setCarUploadInfo();
      }, (){});
    } else {
      _setCarUploadInfo();
    }
  }

  void _setCarUploadInfo() {
    print("CUstomer name ${_customerNameController.text}");
    _carModel!.licensePlate = _plateController.text;
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_set_car);
    m.addInt(widget.table.id);
    m.addInt(_carModel!.id);
    m.addString(_plateController.text);
    m.addInt(_customer == null ? 0 : _customer!.id);
    m.addString(_customerNameController.text);
    m.addString(_customerPhoneController.text);
    sendSocketMessage(m);
  }
}
