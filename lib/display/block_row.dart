import 'package:flutter/material.dart';

import 'package:personal_time_flutter/data.dart';
import 'package:personal_time_flutter/display/block.dart';

class BlockRow extends StatelessWidget {
  BlockRow({
    @required this.startTime,
    @required this.categories,
    @required this.activeCategory,
  });

  final TimeOfDay startTime;
  final List<Category> categories;
  final Category activeCategory;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: List.generate(3, (j) => Expanded(child: hourSet(j))),
      ),
    );
  }

  Column hourSet(int column) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_hourString(column), style: TextStyle(color: Colors.black54)),
        Row(
          children: List.generate(
            4,
            (i) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Block(
                  category: categories[i],
                  activeCategory: activeCategory,
                  isCurrentBlock: null,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  String _hourString(int column) {
    final _hour = startTime.hourOfPeriod + column;
    final _isPM = startTime.period == DayPeriod.pm;
    return '$_hour ${_isPM ? 'PM' : 'AM'}';
  }
}
