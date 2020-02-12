import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  Map<int, Category> blocks = Map();
  Map<Category, int> fifteenBlock = Map();

  String timeString = '00:00:00';
  final emptyTime = '00:00:00';

  DateTime startTime;
  int nextFifteenStart;

  int get currentUnixTime =>
      (DateTime.now().millisecondsSinceEpoch / 1000).floor();

  Category active;

  void setNextFifteenStart() {
    setState(() {
      nextFifteenStart = currentUnixTime - currentUnixTime % 900 + 900;
    });
  }

  @override
  void initState() {
    super.initState();
    setNextFifteenStart();
    Timer.periodic(Duration(seconds: 1), (Timer t) => tick());
  }

  tick() {
    if (active != null) {
      // update timeString
      final length = DateTime.now().difference(startTime);
      setState(() {
        timeString = length.toString().split('.').first.padLeft(8, "0");
      });
    }

    if (currentUnixTime > nextFifteenStart) {
      // set that block color
      if (active != null) {
        fifteenBlock[active] =
            DateTime.now().difference(startTime).inMilliseconds;
      }
      blocks[nextFifteenStart] = majorityOfBlock();
      setNextFifteenStart();
      fifteenBlock.clear();
    }
  }

  Category majorityOfBlock() {
    if (fifteenBlock.isEmpty) {
      return null;
    }

    Category maxCategory;
    int maxTime = 0;

    fifteenBlock.forEach((key, value) {
      if (value > maxTime) {
        maxTime = value;
        maxCategory = key;
      }
    });

    return maxCategory;
  }

  onButtonPressed(Category selectedCategory) {
    setState(() => timeString = emptyTime);
    if (active == selectedCategory) {
      int timeDiff = DateTime.now().difference(startTime).inMilliseconds;
      if (timeDiff * 1000 > 10) {
        fifteenBlock[active] = timeDiff;
      }
      startTime = null;
      active = null;
      return;
    }
    setState(() {
      active = selectedCategory;
      startTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today'),
        actions: <Widget>[IconButton(icon: Icon(Icons.edit), onPressed: () {})],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Blocks(blocks),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    timeString,
                    style: Theme.of(context).textTheme.headline3.copyWith(
                        color: active != null
                            ? CategoryColor.values[active.index]
                            : Colors.grey),
                  ),
                ],
              ),
              Buttons(active, onButtonPressed)
            ],
          ),
        ),
      ),
    );
  }
}

class Blocks extends StatefulWidget {
  Blocks(this.blocks);
  final Map<int, Category> blocks;

  @override
  _BlocksState createState() => _BlocksState();
}

class _BlocksState extends State<Blocks> {
  int start;
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    DateTime time;
    if (now.hour > 6) {
      time = DateTime(now.year, now.month, now.day - 6, 0);
    } else {
      time = DateTime(now.year, now.month, now.day - 1, 6, 30);
    }
    start = (time.millisecondsSinceEpoch / 1000).floor();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
          children: List.generate(
              8,
              (i) => Expanded(
                    child: Row(
                        children: List.generate(
                            3, (j) => Expanded(child: hourColumn(i, j)))),
                  ))),
    );
  }

  Widget hourColumn(int row, int col) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(hourString(row, col), style: TextStyle(color: Colors.black54)),
        Row(
          children: List.generate(
            4,
            (k) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.0),
                        border: Border.all(color: Colors.black12),
                        color: blockCategory(row * col * k)),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Color blockCategory(int index) {
    Category category = widget.blocks[start + index * 900];
    if (category != null) {
      return CategoryColor.values[category.index];
    }
    return null;
  }

  String hourString(int row, int col) {
    var hour = 6;
    hour -= 1;
    hour += row * 3 + col;
    hour %= 12;
    hour += 1;
    final isPM = row > 1 && row < 6;
    return '$hour ${isPM ? 'PM' : 'AM'}';
  }
}

class Buttons extends StatelessWidget {
  Buttons(this.active, this.onPressed);
  final Category active;
  final Function(Category) onPressed;
  @override
  Widget build(BuildContext context) {
    final List<Widget> list = List.generate(
      (Category.values.length / 2).floor(),
      (i) => Row(
        children: <Widget>[
          CategoryButton(
              category: Category.values[i * 2],
              active: active,
              onPressed: onPressed),
          CategoryButton(
              category: Category.values[i * 2 + 1],
              active: active,
              onPressed: onPressed),
        ],
      ),
    );
    list.add(Row(
      children: <Widget>[
        CategoryButton(
            category: Category.Maintenance,
            active: active,
            onPressed: onPressed),
      ],
    ));
    return Column(children: list);
  }
}

class CategoryButton extends StatelessWidget {
  CategoryButton({this.category, this.active, this.onPressed});
  final Category category, active;
  final Function(Category) onPressed;

  bool get isActive => category == active;
  MaterialColor get color => CategoryColor.values[category.index];

  @override
  Widget build(BuildContext context) {
    final enumParts = category.toString().split('.');
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: RawMaterialButton(
          textStyle: TextStyle(color: isActive ? Colors.white : color),
          highlightElevation: 0.0,
          highlightColor: color.shade100,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: color),
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: isActive ? color : Colors.transparent,
          padding: const EdgeInsets.all(0),
          onPressed: () => onPressed(category),
          child: Text(enumParts[1]),
        ),
      ),
    );
  }
}

class CategoryColor {
  static final values = [
    Colors.red,
    Colors.teal,
    Colors.blue,
    Colors.orange,
    Colors.brown,
    Colors.pink,
    Colors.cyan,
    Colors.purple,
    Colors.green,
  ];
}

enum Category {
  Entertainment,
  Productive,
  Sleep,
  Reading,
  Exercise,
  Dating,
  Friends,
  Work,
  Maintenance,
}
