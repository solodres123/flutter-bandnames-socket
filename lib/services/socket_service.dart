// ignore_for_file: constant_identifier_names, avoid_print, library_prefixes, unnecessary_this

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  ServerStatus get serverStatus => this._serverStatus;
  late IO.Socket _socket;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;
  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket= IO.io('http://192.168.1.71:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('mensaje-enviado-por-server', (payload) {
      print('nuevo-mensaje:');
      print('nombre:' + payload['nombre']);
      print('mensaje:' + payload['mensaje']);
      print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    });
  }
}
