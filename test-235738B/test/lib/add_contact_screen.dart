import 'package:flutter/material.dart';
import 'contact.dart';

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
  SelectionStatus _selectedStatus = SelectionStatus.notSelected;

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

    if (company.isEmpty) {
      _showErrorDialog('企業名は必須項目です。');
      return;
    }
    if (phone.isEmpty) {
      _showErrorDialog('電話番号は必須項目です。');
      return;
    }
    
    final name = _nameController.text;
    final url = _urlController.text;
    final List<String> emptyFields = [];
    if (name.isEmpty) emptyFields.add('担当者名');
    if (url.isEmpty) emptyFields.add('WebサイトURL');

    if (emptyFields.isNotEmpty) {
      final fields = emptyFields.join('、');
      _showConfirmationDialog('$fieldsが未設定です。\nこのまま登録しますか？');
    } else {
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
      events: const [], // 新規登録時は空の予定リスト
    );
    if (mounted) {
      Navigator.pop(context, newContact);
    }
  }

  /// エラーダイアログ表示
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('入力エラー'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  /// 確認ダイアログ表示
  void _showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登録内容の確認'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _registerContact();
            },
            child: const Text('登録する'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('連絡先の新規登録')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _companyController, decoration: const InputDecoration(labelText: '企業名 *')),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: '担当者名')),
            const SizedBox(height: 16),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: '電話番号 *'), keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            TextField(controller: _urlController, decoration: const InputDecoration(labelText: 'WebサイトURL'), keyboardType: TextInputType.url),
            const SizedBox(height: 16),
            DropdownButtonFormField<SelectionStatus>(
              value: _selectedStatus,
              items: SelectionStatus.values.map((status) {
                return DropdownMenuItem(value: status, child: Text(status.displayName));
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() { _selectedStatus = value; });
              },
              decoration: const InputDecoration(labelText: '選考ステータス', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _onRegisterButtonPressed, child: const Text('この内容で登録する')),
          ],
        ),
      ),
    );
  }
}

