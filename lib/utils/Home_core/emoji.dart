import 'package:flutter/material.dart';

class Messges extends StatefulWidget {
  final String id;
  const Messges({super.key, required this.id});

  @override
  State<Messges> createState() => _MessgesState();
}

class _MessgesState extends State<Messges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id),
      ),
    );
  }
}
