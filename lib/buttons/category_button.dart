import 'package:flutter/material.dart';

import 'package:personal_time_flutter/data.dart';

class CategoryButton extends StatelessWidget {
  CategoryButton({this.category, this.active, this.onPressed});
  final Category category, active;
  final Function(Category) onPressed;

  bool get isAssigned => category != null;

  bool get isActive => isAssigned && category == active;

  MaterialColor get color => isAssigned ? category.color : Colors.grey;

  @override
  Widget build(BuildContext context) {
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
            child: Text(isAssigned ? category.name : 'Assign')),
      ),
    );
  }
}
