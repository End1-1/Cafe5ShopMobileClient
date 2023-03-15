import 'dart:typed_data';

import '../../client_socket.dart';
import '../../client_socket_interface.dart';

import 'buyer_debts_state.dart';

abstract class BuyerDebtsAction  {
  BuyerDebtsState _state = BuyerDebtsState();
  BuyerDebtsState get state => _state;
  set state(s) => _state = s;

  void process();
}

class BuyerDebtsActionLoad extends BuyerDebtsAction {

  BuyerDebtsActionLoad() {

  }

  void process() async {
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_json_debts);
    ClientSocket.send(m);
  }

  @override
  void authenticate() {
    // TODO: implement authenticate
  }

  @override
  void connected() {
    // TODO: implement connected
  }

  @override
  void disconnected() {
    // TODO: implement disconnected
  }

  @override
  void handler(Uint8List data) {

  }
}