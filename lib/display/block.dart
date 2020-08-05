import 'package:flutter/material.dart';

import 'package:personal_time_flutter/data.dart';

class Block extends StatefulWidget {
  Block({
    @required this.category,
    @required this.activeCategory,
    @required this.isCurrentBlock,
  });

  final Category category;
  final Category activeCategory;
  final bool isCurrentBlock;

  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<Block> {
  double _opacity = 1.0;

  Color get _color => widget.category.color;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.0),
          border: Border.all(color: _color ?? Colors.black12),
        ),
        child: AnimatedOpacity(
          child: Container(color: _color ?? Colors.transparent),
          duration: const Duration(seconds: 2),
          opacity: _opacity,
          onEnd: widget.isCurrentBlock ? () => setState(() => _opacity = 1 - _opacity) : null,
        ),
      ),
    );
  }

  // bool get _isCurrentBlock =>
  //     DateTime.now().isAfter(_blockDate) &&
  //     DateTime.now().difference(_blockDate).inMinutes < 15;

  // DateTime get _blockDate => widget.startDate.add(
  //     Duration(minutes: widget.row * 180 + widget.col * 60 + widget.cell * 15));

  // Color get _borderColor => _color ?? Colors.black12;
}
