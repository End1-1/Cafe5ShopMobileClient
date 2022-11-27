import 'dart:typed_data';

abstract class SocketInterface {
  void handler(Uint8List data);
  void connected();
  void authenticate();
  void disconnected();
}