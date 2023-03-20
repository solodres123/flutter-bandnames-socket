import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  static const name = 'andres';
  static const mensaje = 'hola desde flutter';


  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('ServerStatus:${socketService.serverStatus}')],
      )),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.message),
       onPressed: () {
         socketService.emit('nuevo-mensaje', {'nombre': name, 'mensaje': mensaje});
       },
     ),
    );
  }
}
