import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cafe5_shop_mobile_client/config.dart';

class SocketMessage {
  static const int c_hello = 1;
  static const int c_auth = 4;
  static const int c_dllop = 10;
  static const int c_dllplugin = 11;

  static const int op_login = 1;
  static const int op_get_hall_list = 2;
  static const int op_get_table_list = 3;
  static const int op_get_dish_part1_list = 4;
  static const int op_get_dish_part2_list = 5;
  static const int op_get_dish_dish_list = 6;
  static const int op_login_pashhash = 7;
  static const int op_open_table = 8;
  static const int op_unlock_table = 9;
  static const int op_car_model = 10;
  static const int op_search_licenseplate = 11;
  static const int op_create_header = 12;
  static const int op_set_car = 13;
  static const int op_open_order = 14;
  static const int op_get_car = 15;
  static const int op_dish_menu = 16;
  static const int op_add_dish_to_order = 17;
  static const int op_remove_dish_from_order = 18;
  static const int op_modify_order_dish = 19;
  static const int op_print_service = 20;
  static const int op_login_pin = 21;
  static const int op_update_tables = 22;
  static const int op_get_dish_comments = 23;
  static const int op_print_bill = 24;
  static const int op_ready_dishes = 25;

  static const String waiterclientp = "8b90e61a-1385-4fb4-85ce-f23849045e69";

  late BytesBuilder buffer;
  int messageId;
  int command;
  int _dataSize = 0;
  int _dataPosition = 0;

  static int _packetNumberCounter = 1;
  static int _messageNumberCounter = 1;

  SocketMessage({required this.messageId, required this.command}) {
    buffer = BytesBuilder();
  }

  void setBuffer(Uint8List data) {
    _dataPosition = 0;
    _dataSize = 0;
    buffer.add(data);
    buffer.toBytes().sublist(_dataPosition, 3);
    _dataPosition += 3;
    int packetNumber = buffer.toBytes().sublist(_dataPosition, _dataPosition + 4).buffer.asByteData().getInt32(0, Endian.little);
    _dataPosition += 4;
    messageId = buffer.toBytes().sublist(_dataPosition, _dataPosition + 4).buffer.asByteData().getInt32(0, Endian.little);
    _dataPosition += 4;
    command = buffer.toBytes().sublist(_dataPosition, _dataPosition + 2).buffer.asByteData().getInt16(0, Endian.little);
    _dataPosition += 2;
    _dataSize = buffer.toBytes().sublist(_dataPosition, _dataPosition + 4).buffer.asByteData().getInt32(0, Endian.little);
    _dataPosition += 4;
  }

  static int calculateDataSize(BytesBuilder bb) {
    // print(bb
    //     .toBytes()
    //     .sublist(13, 17));
    return bb.toBytes().sublist(13, 17).buffer.asByteData().getInt32(0, Endian.little);
  }

  void addByte(int value) {
    buffer.addByte(value);
    _dataSize++;
  }

  int getByte() {
    int r = buffer.toBytes().sublist(_dataPosition, _dataPosition + 1).buffer.asByteData().getInt8(0);
    _dataPosition++;
    return r;
  }

  void addShort(int value) {
    buffer.add(Uint8List(2)..buffer.asByteData().setInt16(0, value, Endian.little));
    _dataSize += 2;
  }

  int getShort() {
    int r = buffer.toBytes().sublist(_dataPosition, _dataPosition + 2).buffer.asByteData().getInt16(0, Endian.little);
    _dataPosition += 2;
    return r;
  }

  void addInt(int value) {
    buffer.add(Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.little));
    _dataSize += 4;
  }

  int getInt() {
    int r = buffer.toBytes().sublist(_dataPosition, _dataPosition + 4).buffer.asByteData().getInt32(0, Endian.little);
    _dataPosition += 4;
    return r;
  }

  void addDouble(double value) {
    buffer.add(Uint8List(8)..buffer.asByteData().setFloat64(0, value, Endian.little));
    _dataSize += 8;
  }

  double getDouble() {
    double r = buffer.toBytes().sublist(_dataPosition, _dataPosition + 8).buffer.asByteData().getFloat64(0, Endian.little);
    _dataPosition += 8;
    return r;
  }

  void addString(String value) {
    List<int> b = utf8.encode(value);
    addInt(b.length + 1);
    buffer.add(b);
    buffer.addByte(0);
    _dataSize += b.length + 1;
  }

  String getString() {
    int sz = getInt();
    String str = utf8.decode(buffer.toBytes().sublist(_dataPosition, _dataPosition + sz - 1));
    _dataPosition += sz;
    return str;
  }

  Uint8List data() {
    int pn = packetNumber();
    print("packet number: $pn");
    final BytesBuilder finalBuffer = BytesBuilder();
    //pattern
    finalBuffer.add([0x03, 0x04, 0x15]);
    //packet number
    finalBuffer.add(Uint8List(4)..buffer.asByteData().setInt32(0, pn, Endian.little));
    //message id
    finalBuffer.add(Uint8List(4)..buffer.asByteData().setInt32(0, messageId, Endian.little));
    //command
    finalBuffer.add(Uint8List(2)..buffer.asByteData().setInt16(0, command, Endian.little));
    //data size
    finalBuffer.add(Uint8List(4)..buffer.asByteData().setInt32(0, _dataSize, Endian.little));
    //data
    finalBuffer.add(buffer.takeBytes());

    return finalBuffer.takeBytes();
  }

  static int messageNumber() {
    return _messageNumberCounter++;
  }

  static int packetNumber() {
    int pn = _packetNumberCounter++;
    return pn;
  }

  static void resetPacketCounter() {
    _packetNumberCounter = 1;
  }

  static SocketMessage dllplugin(int op) {
    print("new socketmessage $c_dllplugin : $op");
    SocketMessage m = SocketMessage(messageId: messageNumber(), command: c_dllplugin);
    m.addString(waiterclientp);
    m.addInt(op);
    m.addByte(Config.getInt(key_protocol_version));
    return m;
  }
}
