import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;

  ComingSoonScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title - Coming Soon'),
      ),
      body: Center(
        child: Text('$title Page Coming Soon!'),
      ),
    );
  }
}