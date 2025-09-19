import 'package:flutter/material.dart';
import 'main_screen.dart'; // 遷移先であるMainScreen

/// ウェルカム画面
/// アプリの概要説明と利用開始の起点。
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // テーマから色を取得してUIに一貫性を持たせる
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // 左右に余白を追加
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 縦方向の中央揃え
              crossAxisAlignment: CrossAxisAlignment.stretch, // 横方向に引き伸ばす
              children: [
                // 各UI部品をメソッドとして呼び出し
                _buildLogo(context),
                const SizedBox(height: 40.0),
                _buildTitleSection(context),
                const SizedBox(height: 64.0),
                _buildStartButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ロゴ表示Widget
  Widget _buildLogo(BuildContext context) {
    return Icon(
      // ★ アイコンを管理・ビジネスを象徴するものに変更
      Icons.business_center,
      size: 100.0,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// タイトルと説明文表示Widget
  Widget _buildTitleSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          '就活電話管理',
          style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        Text(
          '就活生のための、\n企業の連絡先と選考状況を一元管理するアプリです。',
          textAlign: TextAlign.center, // テキストを中央揃え
          style: textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  /// 利用開始ボタンWidget
  Widget _buildStartButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        // MainScreenへ画面遷移
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      },
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('利用を開始する', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
    );
  }
}
