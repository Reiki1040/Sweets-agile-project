import 'package:flutter/material.dart';

class HelloWorldScreen extends StatelessWidget {
  const HelloWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('千原Sweetsラバーズ'),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}