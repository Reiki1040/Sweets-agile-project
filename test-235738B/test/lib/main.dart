import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'auth_gate.dart';

// main関数。アプリの起動点。
void main() async {
  // Flutter/Firebaseの初期化処理を保証。
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja_JP');

  // Firebaseの初期化。
  await Firebase.initializeApp(
     options: const FirebaseOptions(
      apiKey: "AIzaSyABK6Jb4Qi2w43C3ob_ldiAKSJJo6JvnZc",
      authDomain: "enpit2025-agileproduct.firebaseapp.com",
      projectId: "enpit2025-agileproduct",
      storageBucket: "enpit2025-agileproduct.firebasestorage.app",
      messagingSenderId: "496935912283",
      appId: "1:496935912283:web:a3af1e37e43159fe5ed07e",
      measurementId: "G-VZPGQZT07Q"
    ),
  );
  runApp(const MyApp());
}

// アプリ本体。
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
      // 最初に表示する画面。
      home: const AuthGate(),
    );
  }
}

