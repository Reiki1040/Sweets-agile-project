import 'package:flutter/material.dart';
import 'main_screen.dart'; // 遷移先であるMainScreen

/// ウェルカム画面
/// アプリの概要説明と利用開始の起点。
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0), // 左右に余白を追加
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 縦方向の中央揃え
            children: [
              // 各UI部品をメソッドとして呼び出し
              _buildLogo(),
              const SizedBox(height: 32.0),
              _buildTitleSection(),
              const SizedBox(height: 48.0),
              _buildStartButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// ロゴ表示Widget
  Widget _buildLogo() {
    return const Icon(
      Icons.security,
      size: 100.0,
      color: Colors.blue,
    );
  }

  /// タイトルと説明文表示Widget
  Widget _buildTitleSection() {
    return Column(
      children: [
        const Text(
          '就活電話管理',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        const Text(
          '知らない番号からの着信を自動で識別し、\n迷惑電話からあなたを守ります。',
          textAlign: TextAlign.center, // テキストを中央揃え
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      ],
    );
  }

  /// 利用開始ボタンWidget
  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // MainScreenへ画面遷移
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // ボタンの背景色
        foregroundColor: Colors.white, // ボタンの文字色
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
      ),
      child: const Text('利用を開始する', style: TextStyle(fontSize: 16.0)),
    );
  }
}
