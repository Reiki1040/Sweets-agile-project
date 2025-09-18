import 'package:flutter/material.dart';
import 'contact.dart'; // Contactモデルをインポート

/// 連絡先の新規登録画面
class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _companyController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _urlController = TextEditingController();
  SelectionStatus _selectedStatus = SelectionStatus.entry;

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

    // 1. 必須項目のチェック
    if (company.isEmpty) {
      _showErrorDialog('企業名は必須項目です。');
      return;
    }
    if (phone.isEmpty) {
      _showErrorDialog('電話番号は必須項目です。');
      return;
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
      final fields = emptyFields.join('、');
      _showConfirmationDialog('$fieldsが未設定です。\nこのまま登録しますか？');
    } else {
      // 全ての項目が入力されていれば、そのまま登録
      _registerContact();
    }
  }

  /// 連絡先を登録する最終処理
  void _registerContact() {
    final newContact = Contact(
      companyName: _companyController.text,
      personName: _nameController.text,
      phoneNumber: _phoneController.text,
      url: _urlController.text,
      status: _selectedStatus,
    );
    if (mounted) {
      Navigator.pop(context, newContact);
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
                Navigator.pop(context); // ダイアログを閉じる
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
                decoration: const InputDecoration(labelText: '企業名 *'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '担当者名'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: '電話番号 *'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'WebサイトURL'),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<SelectionStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: '選考ステータス',
                  border: OutlineInputBorder(),
                ),
                items: SelectionStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.displayName),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _onRegisterButtonPressed,
                child: const Text('この内容で登録する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

