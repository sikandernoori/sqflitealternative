import 'package:flutter/material.dart';
import 'package:sqflitealternative/multi_file.dart';
import 'package:sqflitealternative/single_file.dart';
import 'package:sqflitealternative/using_sqflite.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'SqfLite vs Flat file';
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(_title),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget(this.title, {super.key});
  final String title;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    SingleFile(),
    MultiFile(),
    UsingSqfLite()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _pageTitle() {
    if (_selectedIndex == 0) {
      return 'Single file storage';
    } else if (_selectedIndex == 1) {
      return 'Multi file storage';
    } else if (_selectedIndex == 2) {
      return 'SqfLite storage';
    } else {
      return 'sqfLite vs Flat file';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle()),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Single files',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Multiple file',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'SqfLite',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
