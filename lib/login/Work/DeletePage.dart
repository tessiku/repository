import 'package:flutter/material.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({key}) : super(key: key);

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DeletePage'),
      ),
    );
  }
}
