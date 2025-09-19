import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ログイン・新規登録画面
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// ログイン処理
  Future<void> _signIn() async {
    setState(() { _isLoading = true; });
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(_translateErrorCode(e.code));
    } finally {
      if(mounted) setState(() { _isLoading = false; });
    }
  }

  /// 新規登録処理
  Future<void> _signUp() async {
    setState(() { _isLoading = true; });
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(_translateErrorCode(e.code));
    } finally {
      if(mounted) setState(() { _isLoading = false; });
    }
  }

  /// Firebaseのエラーコードを日本語に変換
  String _translateErrorCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'メールアドレスの形式が正しくありません。';
      case 'weak-password':
        return 'パスワードは6文字以上で入力してください。';
      case 'email-already-in-use':
        return 'このメールアドレスは既に使用されています。';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'メールアドレスまたはパスワードが間違っています。';
      default:
        return 'エラーが発生しました。しばらくしてから再度お試しください。';
    }
  }

  /// エラーダイアログ表示
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン または 新規登録')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    // ★修正点：ヘルパーテキストを追加
                    helperText: '有効なメールアドレスを入力してください。',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'パスワード',
                    // ★修正点：ヘルパーテキストを追加
                    helperText: '6文字以上で入力してください。',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: _signIn, child: const Text('ログイン')),
                      ElevatedButton(onPressed: _signUp, child: const Text('新規登録')),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

