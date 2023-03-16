import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'filetes necesarios', votes: 75),
    Band(id: '2', name: 'los cara huevo', votes: 14),
    Band(id: '3', name: 'la banda del patio', votes: 35),
    Band(id: '4', name: 'yo, yo mismo y yo', votes: 21),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: const Text('Las bandas chachipistachis',
              style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (BuildContext context, int index) =>
                _bandTile(bands[index])),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          elevation: 1,
          onPressed: () {
            addNewBand();
          },
        ));
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => {
        print('direction: $direction'),
        print('id:${band.id}')
        //TODO llamar borrado en el server
      },
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        color: Colors.red[400],
        child: const Align
        ( alignment: Alignment.centerLeft,
          child: Text('borrar',
            style: TextStyle( 
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold
            )
          ),
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
          print(band.name);
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
            content:CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                  onPressed: () =>addBandToList(textController.text),
                  child: const Text('Añadir')
                  ),
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
    if (name.length > 1) {
      bands.add(Band(id: (bands.length + 1).toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
    
  }
}
