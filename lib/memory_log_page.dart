import 'package:flutter/material.dart';

class MemoryLogPage extends StatefulWidget {
  @override
  _MemoryLogPageState createState() => _MemoryLogPageState();
}

class _MemoryLogPageState extends State<MemoryLogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory'),
      ),
      body: Center(
        child: Text('This is the Memory Log Page'),
      ),
    );
  }
}