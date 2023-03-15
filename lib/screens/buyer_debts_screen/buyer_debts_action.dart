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

  }


}