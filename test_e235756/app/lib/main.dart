import 'package:flutter/material.dart';
import 'package:my_app/features/splash/screens/splash_screen.dart'; // 作成するスプラッシュ画面をインポート

// main関数からアプリが起動します
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '就活コールフィルター',
      theme: ThemeData(
        // アプリ全体のテーマカラーを設定
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 最初に表示する画面としてSplashScreenを指定
      home: const SplashScreen(),
    );
  }
}