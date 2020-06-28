import 'dart:async';

import 'package:flutter/material.dart';

import 'package:personal_time_flutter/models.dart';
import 'package:personal_time_flutter/buttons.dart';
import 'package:personal_time_flutter/display.dart';
import 'package:personal_time_flutter/settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Time',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,
          textTheme: TextTheme(
            headline6: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.black87),
          ),
          actionsIconTheme: IconThemeData(color: Colors.black87),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TODO: make this settable
  final List<Category> _categories = [
    Category(name: 'Entertainment', color: Colors.blue, id: 1),
    Category(name: 'Productive', color: Colors.green, id: 2),
    Category(name: 'Reading', color: Colors.deepOrange, id: 3),
    Category(name: 'Exercise', color: Colors.red, id: 4),
    Category(name: 'Dating', color: Colors.pink, id: 5),
    Category(name: 'Friends', color: Colors.purple, id: 6),
    Category(name: 'Maintenance', color: Colors.brown, id: 7),
    Category(name: 'Work', color: Colors.cyan, id: 8),
    Category(name: 'Sleep', color: Colors.blue, id: 9),
    Category(name: 'Waste Time', color: Colors.lime, id: 10),
  ];

  // TODO: make this settable
  DateTime _initialStartDate;
  DateTime _displayStartDate;

  Map<DateTime, int> _blocks = Map();

  Category _activeCategory;
  bool _editing = false;

  @override
  void initState() {
    super.initState();

    final _now = DateTime.now();
    final _nextTick = DateTime(
      _now.year,
      _now.month,
      _now.day,
      _now.hour,
      _now.minute - _now.minute % 15 + 15,
    );
    Timer(_nextTick.difference(_now), _fifteenMinuteTick);

    _initialStartDate = DateTime(
      _now.year,
      _now.month,
      _now.day - 1,
      _now.hour + 9,
    );
    _displayStartDate = _initialStartDate;
  }

  _fifteenMinuteTick() {
    return;
    if (_activeCategory != null) {
      final _now = DateTime.now();
      final _closestFifteenIncrement = (_now.minute / 15).round() * 15;
      final DateTime _date = DateTime(
        _now.year,
        _now.month,
        _now.day,
        _now.hour,
        _closestFifteenIncrement,
      );
      setState(() => _blocks[_date] = _activeCategory.id);
    }
    Timer(const Duration(minutes: 15), _fifteenMinuteTick());
  }

  void _onButtonPressed(Category selectedCategory) {
    setState(() => _activeCategory =
        _activeCategory == selectedCategory ? null : selectedCategory);
  }

  String get _title {
    if (_initialStartDate == _displayStartDate) {
      return 'Today';
    }
    final _endDate = _displayStartDate.add(const Duration(days: 1));
    String _dateText =
        '${months[_displayStartDate.month - 1]} ${_displayStartDate.day}';
    if (_displayStartDate != _endDate) {
      _dateText += ' - ${months[_endDate.month - 1]} ${_endDate.day}';
    }
    return _dateText;
  }

  static const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Nov',
    'Oct',
    'Dec',
  ];

  void _onDaySwitched(DateTime startDate) {
    setState(() => _displayStartDate = startDate);
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  void _goToToday() {
    _onDaySwitched(_initialStartDate);
  }

  Widget get _leading {
    if (_editing) {
      return IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => setState(() => _editing = false),
      );
    }
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: _goToSettings,
    );
  }

  List<Widget> get _actions {
    return [
      Visibility(
        visible: _editing,
        child: IconButton(icon: Icon(Icons.undo), onPressed: null),
      ),
      Visibility(
        visible: _editing,
        child: IconButton(icon: Icon(Icons.redo), onPressed: null),
      ),
      IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: _goToToday,
      ),
      IconButton(
        icon: Icon(_editing ? Icons.done : Icons.edit),
        onPressed: () => setState(() => _editing = !_editing),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        leading: _leading,
        actions: _actions,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Display(
              active: _activeCategory,
              blocks: _blocks,
              categories: _categories,
              startDate: _initialStartDate,
              onDaySwitched: _onDaySwitched,
            ),
            Buttons(
              active: _activeCategory,
              onPressed: _onButtonPressed,
              categories: _categories,
            )
          ],
        ),
      ),
    );
  }
}
