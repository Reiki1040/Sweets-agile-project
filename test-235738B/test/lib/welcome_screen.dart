// lib/welcome_screen.dart

import 'package:flutter/material.dart';
import 'hello_world_screen.dart'; // HelloWorldScreenを使うためにインポート

// 1番目の画面：ウェルカムスクリーン
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.security,
              size: 100.0,
              color: Colors.blue,
            ),
            const SizedBox(height: 32.0),
            const Text(
              '就活コールフィルター',
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '知らない番号からの着信を自動で識別し、\n迷惑電話からあなたを守ります。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 48.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelloWorldScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              child: const Text('利用を開始する', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}