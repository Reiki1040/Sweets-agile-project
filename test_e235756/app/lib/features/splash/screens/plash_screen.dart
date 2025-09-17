import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffoldは画面の基本的な骨格を作ります
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // 背景色を設定
      // 画面の中央に要素を配置するためのWidget
      body: Center(
        // Columnを使って要素を縦に並べます
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 縦方向の中央に配置
          children: [
            // ロゴのプレースホルダー
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7FF),
                border: Border.all(color: const Color(0xFF4A69E2), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              // ロゴの代わりにアイコンを表示
              child: const Icon(
                Icons.phone_android,
                size: 40,
                color: Color(0xFF4A69E2),
              ),
            ),
            const SizedBox(height: 24), // 要素間のスペース

            // プロダクト名
            const Text(
              '就活コールフィルター',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12), // 要素間のスペース

            // タグライン
            const Text(
              '知らない電話の「不安」を「安心」に。',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}