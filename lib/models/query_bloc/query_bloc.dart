import 'dart:typed_data';

import 'package:cafe5_shop_mobile_client/models/query_bloc/query_action.dart';
import 'package:cafe5_shop_mobile_client/models/query_bloc/query_state.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../client_socket.dart';
import '../../client_socket_interface.dart';
import '../../translator.dart';

class QueryBloc extends Bloc<QueryAction, QueryState>
    implements SocketInterface {
  QueryBloc(super.initialState) {
    ClientSocket.socket.addInterface(this);
    SocketMessage m = SocketMessage.dllplugin(SocketMessage.op_json_debts);
    ClientSocket.send(m);
  }

  Future<void> eventToState(QueryAction a) async {
    emit(const QueryStateProgress());
    if (a is QueryActionLoad) {
      SocketMessage m = SocketMessage.dllplugin(a.op);
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
    emit(QueryStateError(error: tr('Disconnected from server')));
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
        emit(QueryStateError(error: m.getString()));
        return;
      }
      String json = m.getString();
      emit(QueryStateReady(op: op, data: json));
    }
  }
}
