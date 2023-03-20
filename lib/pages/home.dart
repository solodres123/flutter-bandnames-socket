import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/pages/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
//   Band(id: '1', name: 'filetes necesarios', votes: 75),
//   Band(id: '2', name: 'los cara huevo', votes: 14),
//   Band(id: '3', name: 'la banda del patio', votes: 35),
//   Band(id: '4', name: 'yo, yo mismo y yo', votes: 21),
  ];
//
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on(
        'bandas-activas',
        (payload) => {
              // ignore: unnecessary_this
              this.bands =
                  (payload as List).map((band) => Band.fromMap(band)).toList(),

              setState(() {})
            });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10),
                child:
                    (((socketService.serverStatus == ServerStatus.Connecting) |
                            (socketService.serverStatus == ServerStatus.Online))
                        ? Icon(
                            Icons.signal_wifi_statusbar_4_bar_sharp,
                            color: Colors.blue[300],
                          )
                        : Icon(
                            Icons
                                .signal_wifi_statusbar_connected_no_internet_4_sharp,
                            color: Colors.red,
                          )))
          ],
          centerTitle: true,
          title: const Text('Las bandas chachipistachis',
              style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            _showGraph(),
            Expanded(
              child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _bandTile(bands[index])),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          elevation: 1,
          onPressed: () {
            addNewBand();
          },
        ));
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => {
        print('direction: $direction'),
        print('id:${band.id}'),
        socketService.socket.emit('erased-band', {'id': band.id})
      },
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        color: Colors.red[400],
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('borrar',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing:
            Text(band.votes.toString(), style: const TextStyle(fontSize: 20)),
        onTap: () {
          socketService.socket.emit('new-vote', {'id': band.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('metele otra loco'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 1,
                  onPressed: () {
                    addBandToList(textController.text);
                  },
                  child: const Text('Añadir'))
            ],
          );
        },
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: const Text('hola niña de la curva'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => addBandToList(textController.text),
                  child: const Text('Añadir')),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('new-band', {'name': name});
    }
    Navigator.pop(context);
  }

  _showGraph() {
    Map<String, double> dataMap = {};
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 2.2,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
    
      
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      ),
    );
  }
}
