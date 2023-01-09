import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflitealternative/event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flat file DB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'IO Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List file = [];
  DateTime? startTime;
  DateTime? endTime;
  String operation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Table(
          border: TableBorder.all(width: 1, color: Colors.black45),
          children: [
            const TableRow(children: [
              TableCell(child: Text('Operation')),
              TableCell(child: Text("Records")),
              TableCell(child: Text("Duration (sec)")),
            ]),
            TableRow(children: [
              TableCell(child: Text(operation)),
              TableCell(child: Text('$_counter')),
              TableCell(
                  child: Text(endTime != null
                      ? endTime!.difference(startTime!).inSeconds.toString()
                      : '')),
            ]),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: saveToFlatFiles,
            tooltip: 'Save',
            child: const Icon(Icons.save),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: readFromFlatFiles,
            tooltip: 'read',
            child: const Icon(Icons.print),
          ),
        ],
      ),
    );
  }

  void saveToFlatFiles([int records = 100000]) async {
    setState(() {
      operation = 'writing';
      startTime = DateTime.now();
      _counter = 0;
      endTime = null;
    });
    print('Write start time: $startTime');

    Event event = getEventObject();
    final directory = await getApplicationDocumentsDirectory();
    String toLog = '';
    for (int i = 0; i < records; i++) {
      event.id = i;
      toLog = "$toLog,${event.toMap()}";
      File logFile = File("${directory.path}/ $i.txt");
      await logFile.writeAsString(toLog, mode: FileMode.write);
      // setState(() {
      _counter++;
      // });
    }
    setState(() {
      endTime = DateTime.now();
    });
    print('Write end time: $endTime');
  }

  void readFromFlatFiles() async {
    setState(() {
      operation = 'reading';
      startTime = DateTime.now();
      endTime = null;
      _counter = 0;
    });
    print('Read start time: $startTime');

    final directory = await getApplicationDocumentsDirectory();

    file = Directory(directory.path).listSync();

    for (File e in file) {
      // setState(() {
      _counter++;
      // });
      final File file = File(e.path);
      var text = await file.readAsString();
      // print(text);
    }

    setState(() {
      endTime = DateTime.now();
    });
    print('Read end time: $endTime');
  }

  Event getEventObject() {
    return Event(
        1,
        'GMT+2',
        DateTime.now().toIso8601String(),
        'iPhone 13 Pro',
        {"flutter": "3.3.3", "IOS": "IOS 16.2"},
        "Tallinn",
        0,
        {"battery": "100%"},
        {"activity": "some activity data"},
        {
          "lat": "32.32",
          "long": "14.12",
        },
        {"operator": "Telia", "nertwork_code": "1234"},
        {"x": 123, "y": 123, "z": 123},
        {"x": 123, "y": 123, "z": 123},
        0,
        {"barometer": "some barometer data"},
        DateTime.now().millisecondsSinceEpoch - 1000,
        {"Snow": true},
        {"heart beat": "120/80", "steps": 1000},
        DateTime.now().millisecondsSinceEpoch.toDouble(),
        DateTime.now());
  }
}
