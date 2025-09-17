// Flutterのマテリアルデザイン部品をインポート
import 'package:flutter/material.dart';

// プログラムが最初に実行される場所
void main() {
  // MyAppウィジェットを画面に表示する
  runApp(const MyApp());
}

// アプリ本体のウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // このウィジェットの見た目を定義
  @override
  Widget build(BuildContext context) {
    // マテリアルデザインのアプリを作成
    return MaterialApp(
      // ホーム画面の定義
      home: Scaffold(
        // 画面上部のバー（アプリバー）
        appBar: AppBar(
          // バーに表示するタイトル
          title: const Text('Sweetsラバーズ'),
        ),
        // 画面の中央部分
        body: const Center(
          // 中央にテキストを配置して表示
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}