import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // 日本語化のためにインポート
import 'welcome_screen.dart';

// main関数。アプリの起動点。
void main() async { // asyncを追加
  // Flutterの初期化を保証
  WidgetsFlutterBinding.ensureInitialized();
  // カレンダーの日本語化データを初期化
  await initializeDateFormatting('ja_JP');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '就活コール管理',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WelcomeScreen(),
    );
  }
}
