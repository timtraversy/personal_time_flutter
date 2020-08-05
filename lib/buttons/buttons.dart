import 'package:flutter/material.dart';

import 'package:personal_time_flutter/data.dart';
import 'package:personal_time_flutter/buttons/category_button.dart';

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

  Category categoryAtIndex(int index) => categories.length > index ? categories[index] : null;
}
