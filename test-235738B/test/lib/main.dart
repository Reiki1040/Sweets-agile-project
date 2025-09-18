import 'package:flutter/material.dart';
import 'welcome_screen.dart';

// main関数からアプリが起動します
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '就活コール管理',
      theme: ThemeData(
        // アプリ全体のテーマカラーを設定
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 最初に表示する画面としてSplashScreenを指定
      home: const WelcomeScreen(),
    );
  }
}