import 'package:flutter/material.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({key}) : super(key: key);

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckPage'),
      ),
    );
  }
}
