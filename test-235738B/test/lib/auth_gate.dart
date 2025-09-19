import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart'; // ログイン後のメイン画面
import 'login_screen.dart'; // ログイン前の画面

/// 認証状態に応じて画面を振り分けるWidget
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Firebaseの認証状態の変化をリアルタイムで監視
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 接続待機中はローディング表示
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ユーザーがログインしている場合
        if (snapshot.hasData) {
          // MainScreenを表示
          return const MainScreen();
        }

        // ユーザーがログインしていない場合
        return const LoginScreen();
      },
    );
  }
}

