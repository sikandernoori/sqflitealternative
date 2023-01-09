import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflitealternative/event.dart';

class UsingSqfLite extends StatefulWidget {
  const UsingSqfLite({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UsingSqfLiteState();
}

class _UsingSqfLiteState extends State<UsingSqfLite> {
  _UsingSqfLiteState();

  int recordsProcessed = 0;
  List file = [];
  DateTime? startTime;
  DateTime? endTime;
  String operation = '';
  late Directory directory;
  List<Event> events = [];

  late Database database;

  @override
  void initState() {
    super.initState();

    initDb();
  }

  void initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'main.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Event(id INTEGER PRIMARY KEY, timestamp DOUBLE NOT NULL, timezone TEXT, datetime TEXT, no_address INT, gps TEXT, network TEXT, locator TEXT, battery TEXT, activity TEXT, gyroscope TEXT, accelerometer TEXT, proximity_changing INT, device TEXT, barometer TEXT, build TEXT, synced_at INT, weather TEXT, health TEXT)');
    });
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
              TableCell(child: Text("Duration (milli sec)")),
            ]),
            TableRow(children: [
              TableCell(child: Text(operation)),
              TableCell(child: Text('$recordsProcessed')),
              TableCell(
                  child: Text(endTime != null
                      ? endTime!
                          .difference(startTime!)
                          .inMilliseconds
                          .toString()
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
      Event event = getEventObject();

      // await database.transaction((txn) async {
      //   for (int i = 0; i < records; i++) {
      //     event.id = i;
      //     var toInsert = json.encode(event.toMap());
      //     await txn
      //         .rawInsert('INSERT INTO Events(event) VALUES(${event.toMap()})');
      //   }
      // });

      for (int i = 1; i <= records; i++) {
        event.id = i;

        int res = await database.insert("Event", event.toDb());
        recordsProcessed++;
      }
      setState(() {
        endTime = DateTime.now();
      });
    } catch (e) {
      showMessage(this.context, e.toString());
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
      var eventsMap =
          await database.rawQuery('SELECT * FROM Event ORDER BY timestamp');

      for (var element in eventsMap) {
        events.add(Event.map(element));
      }
      setState(() {
        endTime = DateTime.now();
        recordsProcessed = events.length;
      });
    } catch (e) {
      showMessage(this.context, e.toString());
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
