import 'dart:convert';
import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/screens/buyer_debts_screen/buyer_debts_action.dart';
import 'package:cafe5_shop_mobile_client/screens/buyer_debts_screen/buyer_debts_state.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../client_socket.dart';
import '../../client_socket_interface.dart';
import '../../freezed/debt.dart';
import '../../translator.dart';

class BuyerDebtsBlock extends Bloc<BuyerDebtsAction, BuyerDebtsState> implements SocketInterface {
  BuyerDebtsBlock(super.initialState) {
    ClientSocket.socket.addInterface(this);
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_json_debts);
    ClientSocket.send(m);
  }

  Future<void> eventToState(BuyerDebtsAction a) async {
    emit(BuyerDebtsStateProgress());
    if (a is BuyerDebtsActionLoad) {
      SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_json_debts);
      ClientSocket.send(m);
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
    emit(BuyerDebtsStateError(tr('Disconnected from server')));
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
          String json = m.getString();
          Debts debts = Debts.fromJson({'debts' : jsonDecode(json)});
          emit(BuyerDebtsStateReady(debts));
          break;
      }
    }
  }

}