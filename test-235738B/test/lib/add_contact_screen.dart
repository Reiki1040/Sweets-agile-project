import 'package:flutter/material.dart';

/// 連絡先の新規登録画面
class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  // 各テキストフィールドの入力を管理
  final _companyController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _urlController = TextEditingController();

  // ウィジェットが不要になった際に、リソースを解放
  @override
  void dispose() {
    _companyController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  /// 登録ボタンが押された時のメイン処理
  void _onRegisterButtonPressed() {
    final company = _companyController.text;
    final phone = _phoneController.text;
    final name = _nameController.text;
    final url = _urlController.text;

    // --- バリデーションチェック ---

    // 1. 必須項目のチェック
    if (company.isEmpty) {
      _showErrorDialog('企業名は必須項目です。');
      return; // 処理を中断
    }
    if (phone.isEmpty) {
      _showErrorDialog('電話番号は必須項目です。');
      return; // 処理を中断
    }

    // 2. 任意項目のチェック
    final List<String> emptyFields = [];
    if (name.isEmpty) {
      emptyFields.add('担当者名');
    }
    if (url.isEmpty) {
      emptyFields.add('WebサイトURL');
    }

    // 未入力の任意項目がある場合、確認ダイアログを表示
    if (emptyFields.isNotEmpty) {
      final fields = emptyFields.join('、'); // "、"で連結
      _showConfirmationDialog('$fieldsが未設定です。\nこのまま登録しますか？');
    } else {
      // 全ての項目が入力されていれば、そのまま登録処理へ
      _registerContact();
    }
  }

  /// 連絡先を登録する最終処理
  void _registerContact() {
    // 入力された情報を取得
    final company = _companyController.text;
    final name = _nameController.text;
    final phone = _phoneController.text;
    final url = _urlController.text;
    
    // TODO: ここで入力された情報をデータベースに保存する処理を将来的に追加
    print('--- 登録情報 ---');
    print('企業名: $company');
    print('担当者名: $name');
    print('電話番号: $phone');
    print('URL: $url');

    // 登録が完了したら、前の画面に戻る
    // mountedチェックは、非同期処理後にウィジェットがまだ存在するかを確認するお作法
    if (mounted) {
      Navigator.pop(context);
    }
  }

  /// エラーダイアログを表示する
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('入力エラー'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// 確認ダイアログを表示する
  void _showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('登録内容の確認'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                // 先にダイアログを閉じてから登録処理
                Navigator.pop(context);
                _registerContact();
              },
              child: const Text('登録する'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('連絡先の新規登録'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: '企業名 *', // 必須マーク
                  hintText: '株式会社 Example',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '担当者名',
                  hintText: '山田 太郎',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '電話番号 *', // 必須マーク
                  hintText: '090-1234-5678',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'WebサイトURL',
                  hintText: 'https://example.com',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _onRegisterButtonPressed, // 登録処理を呼び出し
                child: const Text('この内容で登録する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
