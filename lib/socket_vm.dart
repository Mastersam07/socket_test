import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ConnectionStatus { notConnected, connected, disconnected }

class SocketVm extends ChangeNotifier {
  // ! CONNECT AND LISTEN TO SOCKET
  io.Socket? _socket;
  io.Socket? get socket => _socket;

  ConnectionStatus _connectionStatus = ConnectionStatus.notConnected;
  ConnectionStatus get connectionStatus => _connectionStatus;
  void connectAndListen() {
    _socket = io.io(
        "https://dev.pluhg.com",
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableReconnection()
            .build());
    _socket!.connect();

    _socket!.onConnect((_) {
      print('connected $_');
      _connectionStatus = ConnectionStatus.connected;
      notifyListeners();
    });

    // ! WELCOME EVENT
    _socket!.on('welcome', (data) => print(data));

    _socket!.onDisconnect((_) {
      print('disconnect');
      _connectionStatus = ConnectionStatus.disconnected;
      notifyListeners();
    });
  }
}
