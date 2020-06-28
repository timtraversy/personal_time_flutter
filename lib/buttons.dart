import 'package:flutter/material.dart';

import 'package:personal_time_flutter/models.dart';

class Buttons extends StatelessWidget {
  Buttons({this.active, this.onPressed, this.categories});
  final Category active;
  final Function(Category) onPressed;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = List.generate(
        5,
        (i) => Row(children: <Widget>[
              CategoryButton(
                category: categoryAtIndex(i * 2),
                active: active,
                onPressed: onPressed,
              ),
              CategoryButton(
                category: categoryAtIndex(i * 2 + 1),
                active: active,
                onPressed: onPressed,
              ),
            ]));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(children: list),
    );
  }

  Category categoryAtIndex(int index) =>
      categories.length > index ? categories[index] : null;
}

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
