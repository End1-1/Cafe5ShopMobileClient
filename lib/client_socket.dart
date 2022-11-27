import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cafe5_shop_mobile_client/client_socket_interface.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';

class ClientSocket {

  static late ClientSocket socket;
  static int _socketState = 0;
  static SecureSocket? _socket;
  String remoteAddress;
  int remotePort;
  final BytesBuilder _tempBuffer = BytesBuilder();
  static List<SocketInterface> _interfaces =[];

  ClientSocket ({required this.remoteAddress, required this.remotePort});

  static void init(String ip, int port) async {
    socket = ClientSocket(remoteAddress: ip, remotePort: port);
  }

  Future<void> connect(bool wait) async {
    if (wait) {
      while (_interfaces.isEmpty) {
        await Future.delayed(const Duration(seconds: 5));
      }
    }
    connectToServer();
  }

  Future<bool> connectToServer() async {
    if (_socket != null) {
      _socket!.destroy();
    }
    print("${DateTime.now()} Connect to ${socket.remoteAddress}:${socket.remotePort}");
    await SecureSocket.connect(socket.remoteAddress, socket.remotePort, timeout: Duration(seconds: 3), onBadCertificate: (x){return true;}).then((s) {
      print("${DateTime.now()} Socket connected ${s.hashCode}");
      _socket = s;
      _listenSocket();
      setSocketState(1);
    }).onError((error, stackTrace) {
      print(error);
      setSocketState(0);
      _reconnectToServer();
    });

    return true;
  }

  void _listenSocket() async {
    _socket!.listen((data) {
      _tempBuffer.add(data);
      //print(data);
      int expectedSize = 0;
      do {
        expectedSize = SocketMessage.calculateDataSize(_tempBuffer);
        if (expectedSize <= _tempBuffer.length - 17) {
          print(_tempBuffer.length);
          for (SocketInterface s in _interfaces) {
            try {
              s.handler(_tempBuffer.toBytes().sublist(0, expectedSize + 17));
            } catch (e) {
              print(e.toString());
            }
          }
          BytesBuilder bb = BytesBuilder();
          bb.add(_tempBuffer.toBytes().sublist(expectedSize + 17, _tempBuffer
              .toBytes()
              .length));
          _tempBuffer.clear();
          if (bb.length > 0) {
            _tempBuffer.add(bb.toBytes());
            expectedSize = SocketMessage.calculateDataSize(_tempBuffer);
            if (expectedSize > _tempBuffer.length - 17) {
              expectedSize = 0;
            }
          } else {
            expectedSize = 0;
          }
        } else {
          break;
        }
      } while (expectedSize != 0);
    }, onDone: () {
      setSocketState(0);
      print("Socket disconnected ${_socket.hashCode}");
      _reconnectToServer();
    }, onError: (err)  {
      setSocketState(0);
      print("socket error $err ${_socket.hashCode}");
    });
  }

  Future<bool> _reconnectToServer() async {
    const int sec = 2;
    print("Wait $sec second");
    await Future.delayed(const Duration(seconds: sec));
    print("Socket reconnecting... ${_socket.hashCode}");
    await connectToServer();
    return true;
  }

  void addInterface(SocketInterface si) {
    _interfaces.add(si);
    print("addInterface ${_interfaces.length}: ${_interfaces.join(",")}");
  }

  void removeInterface(SocketInterface si) {
    print("remove Interface ${si.runtimeType}");
    _interfaces.remove(si);
    print("after removeInterface ${_interfaces.length}: ${_interfaces.join(",")}");
  }

  static String imageConnectionState() {
    switch (_socketState) {
      case 0:
        return "images/wifi_off.png";
      case 1:
        return "images/wifib.png";
      case 2:
        return "images/wifi_on.png";
    }
    return "images/wifi_off.png";
  }

  static int send(SocketMessage m) {
    try {
      if (_socket == null) {
        print("socket is null");
        return 0;
      }
      print("Send data ${_socket.hashCode}");
      _socket!.add(m.data());
    } catch (e) {
      print(e);
      return 0;
    }
    return m.messageId;
  }

  static void setSocketState(int state) {
    _socketState = state;
    print("setSocketState $state for ${_interfaces.length}: ${_interfaces.join(",")}");
    for (SocketInterface s in _interfaces) {
      switch (_socketState) {
         case 0:
           s.disconnected();
           break;
         case 1:
           s.connected();
           break;
        case 2:
          s.authenticate();
          break;
      }
    }
  }

}