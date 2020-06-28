import 'dart:async';

import 'package:flutter/material.dart';

import 'package:personal_time_flutter/models.dart';

class Display extends StatelessWidget {
  Display({
    this.active,
    this.blocks,
    this.categories,
    this.startDate,
    this.onDaySwitched,
  });
  final Category active;
  final Map<DateTime, int> blocks;
  final List<Category> categories;
  final DateTime startDate;
  final ValueChanged<DateTime> onDaySwitched;

  final int initialPage = 5000;
  final PageController _pageController = PageController(initialPage: 5000);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        itemBuilder: (context, index) => DayDisplay(
          active: active,
          blocks: blocks,
          categories: categories,
          startDate: _startDateForIndex(index),
        ),
        controller: _pageController,
        onPageChanged: (i) => onDaySwitched(_startDateForIndex(i)),
      ),
    );
  }

  DateTime _startDateForIndex(int index) {
    int difference = index - initialPage;
    return startDate.add(Duration(days: difference));
  }
}

class DayDisplay extends StatelessWidget {
  DayDisplay({this.active, this.blocks, this.categories, this.startDate});
  final Category active;
  final Map<DateTime, int> blocks;
  final List<Category> categories;
  final DateTime startDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          (cell) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Block(
                row,
                col,
                cell,
                active: active,
                blocks: blocks,
                categories: categories,
                startDate: startDate,
              ),
            ),
          ),
        ))
      ],
    );
  }

  String hourString(int row, int col) {
    var hour = startDate.hour;
    hour -= 1;
    hour += row * 3 + col;
    hour %= 12;
    hour += 1;
    final isPM = row > 1 && row < 6;
    return '$hour ${isPM ? 'PM' : 'AM'}';
  }
}

class Block extends StatefulWidget {
  Block(this.row, this.col, this.cell,
      {this.active, this.blocks, this.categories, this.startDate});
  final int row, col, cell;
  final Category active;
  final Map<DateTime, int> blocks;
  final List<Category> categories;
  final DateTime startDate;

  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<Block> {
  final Color defaultColor = Colors.transparent;

  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 250), () => setState(() => opacity = 1));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.0),
          border: Border.all(color: borderColor),
        ),
        child: AnimatedOpacity(
          child: Container(
            color: color ?? defaultColor,
          ),
          duration: const Duration(seconds: 2),
          opacity: isCurrentBlock ? opacity : 1.0,
          onEnd: () => setState(() => opacity = 1 - opacity),
        ),
      ),
    );
  }

  bool get isCurrentBlock =>
      DateTime.now().isAfter(blockDate) &&
      DateTime.now().difference(blockDate).inMinutes < 15;

  DateTime get blockDate => widget.startDate.add(
      Duration(minutes: widget.row * 180 + widget.col * 60 + widget.cell * 15));

  Color get borderColor => color ?? Colors.black12;

  Color get color {
    if (isCurrentBlock && widget.active != null) {
      return widget.active.color;
    }
    final int categoryId = widget.blocks[blockDate];
    if (categoryId == null) {
      return null;
    }
    final Category category =
        widget.categories.singleWhere((category) => category.id == categoryId);
    return category.color;
  }
}
