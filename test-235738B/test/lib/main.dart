import 'package:flutter/material.dart';
import 'welcome_screen.dart';

// アプリの開始
void main() {
  runApp(const MyApp());
}

// アプリ全体の設定
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 最初に表示する画面指定
      home: const WelcomeScreen(),
    );
  }
}