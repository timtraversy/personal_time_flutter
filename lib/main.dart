import 'dart:async';

import 'package:flutter/material.dart';

import 'package:personal_time_flutter/data.dart';
import 'package:personal_time_flutter/buttons/buttons.dart';
import 'package:personal_time_flutter/display/display.dart';

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
            headline6: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black87),
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
  bool _initializing = true;
  Category _activeCategory;
  List<Category> _categories;
  bool _editing = false;

  List<Category> _blocks;

  @override
  void initState() {
    super.initState();
    _initializeAsynchronously();
  }

  void _initializeAsynchronously() async {
    final futures = [_loadCategories()];
    await Future.wait(futures);
  }

  Future<void> _loadBlocks() async {
    final blocks = await DataManager.fetchBlocks(0);
  }

  Future<void> _loadCategories() async {
    final categories = await DataManager.fetchCategories();
    setState(() => _categories = categories);
  }

  void _recordDataSinceAppWasQuit() async {}

  void _setInitialTimer() {
    final int _fifteenMinutesInMilliseconds = const Duration(minutes: 15).inMilliseconds;
    final int _nowInMilliseconds = DateTime.now().millisecondsSinceEpoch;
    final Duration _duration = Duration(
      milliseconds: _nowInMilliseconds -
          _nowInMilliseconds % _fifteenMinutesInMilliseconds +
          _fifteenMinutesInMilliseconds,
    );
    Timer(_duration, _fifteenMinuteTick());
  }

  _fifteenMinuteTick() {
    DataManager.writeBlock(categoryId: _activeCategory.id);
    setState(() => _blocks.add(_activeCategory));
    Timer(const Duration(minutes: 15), _fifteenMinuteTick());
  }

  void _onButtonPressed(Category selectedCategory) {
    setState(() => _activeCategory = _activeCategory == selectedCategory ? null : selectedCategory);
  }

  List<Widget> get _actions {
    List<IconButton> buttons = [];
    if (_editing) {
      buttons.addAll([
        IconButton(icon: Icon(Icons.undo), onPressed: null),
        IconButton(icon: Icon(Icons.redo), onPressed: null),
      ]);
    }
    buttons.add(IconButton(
      icon: Icon(_editing ? Icons.done : Icons.edit),
      onPressed: () => setState(() => _editing = !_editing),
    ));
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Time'),
        actions: _actions,
        centerTitle: true,
      ),
      body: SafeArea(
        child: _initializing
            ? Column(children: <Widget>[
                Display(activeCategory: _activeCategory),
                Expanded(
                  child: Buttons(
                    active: _activeCategory,
                    onPressed: _onButtonPressed,
                    categories: _categories,
                  ),
                )
              ])
            : Text('Loading'),
      ),
    );
  }
}
