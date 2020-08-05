import 'package:flutter/material.dart';

import 'package:personal_time_flutter/data.dart';
import 'package:personal_time_flutter/display/block_row.dart';

class Display extends StatefulWidget {
  Display({@required this.activeCategory, @required this.categories});

  final Map<DateTime, int> blocks = Map();

  final Category activeCategory;
  final Category activeCategory;

  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          return BlockRow(startTime: null, activeCategory: null);
        });
  }
}
