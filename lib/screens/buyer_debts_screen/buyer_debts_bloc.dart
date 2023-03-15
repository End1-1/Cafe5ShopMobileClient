import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/screens/buyer_debts_screen/buyer_debts_action.dart';
import 'package:cafe5_shop_mobile_client/screens/buyer_debts_screen/buyer_debts_state.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../client_socket.dart';
import '../../client_socket_interface.dart';

class BuyerDebtsBlock extends Bloc<BuyerDebtsAction, BuyerDebtsState> implements SocketInterface {
  BuyerDebtsBlock(super.initialState) {
    ClientSocket.socket.addInterface(this);
  }

  Future<void> eventToState(BuyerDebtsAction a) async {
    if (a is BuyerDebtsActionLoad) {

    }

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
    SocketMessage m = SocketMessage(messageId: 0, command: 0);
    m.setBuffer(data);

    print("command ${m.command}");
    if (m.command == SocketMessage.c_dllplugin) {
      int op = m.getInt();
      int dllok = m.getByte();
      if (dllok == 0) {
        emit(BuyerDebtsStateError(m.getString()));
        return;
      }
      switch (op) {
        case SocketMessage.op_json_debts:
          break;
      }
    }
  }

}