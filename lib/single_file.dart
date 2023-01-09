import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflitealternative/event.dart';

class SingleFile extends StatefulWidget {
  const SingleFile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingleFileState();
}

class _SingleFileState extends State<SingleFile> {
  _SingleFileState();

  int recordsProcessed = 0;
  List file = [];
  DateTime? startTime;
  DateTime? endTime;
  String operation = '';
  late Directory directory;
  List<Event> events = [];

  @override
  void initState() {
    super.initState();

    getDocumentDirectory();
  }

  void getDocumentDirectory() async {
    directory = await getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              TableCell(child: Text('$recordsProcessed')),
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
            onPressed: writeToFlatFile,
            tooltip: 'write',
            child: const Icon(Icons.save),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: readFromFlatFile,
            tooltip: 'read',
            child: const Icon(Icons.print),
          ),
        ],
      ),
    );
  }

  void writeToFlatFile([int records = 100000]) async {
    try {
      setState(() {
        operation = 'writing';
        startTime = DateTime.now();
        recordsProcessed = 0;
        endTime = null;
      });
      print('Write start time: $startTime');

      Event event = getEventObject();
      File logFile = File("${directory.path}/oneFile.txt");
      for (int i = 0; i < records; i++) {
        event.id = i;
        var toLog = json.encode(event.toMap());
        await logFile.writeAsString('$toLog\n', mode: FileMode.append);
        recordsProcessed++;
      }
      setState(() {
        endTime = DateTime.now();
      });
      print('Write end time: $endTime');
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  void readFromFlatFile() async {
    try {
      setState(() {
        operation = 'reading';
        startTime = DateTime.now();
        endTime = null;
        recordsProcessed = 0;
      });
      print('Read start time: $startTime');

      File dataFile = File("${directory.path}/oneFile.txt");

      var content = await dataFile.readAsLines();

      content.forEach((element) {
        events.add(Event.map(json.decode(element)));
      });

      recordsProcessed = events.length;

      setState(() {
        endTime = DateTime.now();
      });
      print('Read end time: $endTime');
    } catch (e) {
      showMessage(context, e.toString());
    }
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

  showMessage(BuildContext context, String message) {
    print(message);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
