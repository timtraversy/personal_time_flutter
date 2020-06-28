import 'package:flutter/material.dart';

import 'package:personal_time_flutter/models.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.categories});
  final List<Category> categories;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(),
    );
  }
}
