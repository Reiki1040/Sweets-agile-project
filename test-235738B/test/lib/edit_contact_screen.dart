import 'package:flutter/material.dart';
import 'contact.dart';

/// 既存の連絡先情報を編集するための画面
class EditContactScreen extends StatefulWidget {
  final Contact contact;
  const EditContactScreen({super.key, required this.contact});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  // 各テキストフィールドの入力を管理
  late final TextEditingController _companyController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    // 渡された連絡先データでコントローラーを初期化
    _companyController = TextEditingController(text: widget.contact.companyName);
    _nameController = TextEditingController(text: widget.contact.personName);
    _phoneController = TextEditingController(text: widget.contact.phoneNumber);
    _urlController = TextEditingController(text: widget.contact.url);
  }

  @override
  void dispose() {
    _companyController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  /// 保存ボタンが押された時の処理
  void _onSaveButtonPressed() {
    // 必須項目チェック
    if (_companyController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('企業名と電話番号は必須です。')),
      );
      return;
    }

    // 編集後のデータで新しいContactオブジェクトを作成
    final updatedContact = widget.contact.copyWith(
      companyName: _companyController.text,
      personName: _nameController.text,
      phoneNumber: _phoneController.text,
      url: _urlController.text,
    );
    
    // 更新されたデータを渡しながら前の画面（詳細画面）に戻る
    Navigator.pop(context, updatedContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('連絡先の編集'),
        actions: [
          // 保存ボタン
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _onSaveButtonPressed,
          ),
        ],
      ),
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
          ],
        ),
      ),
    );
  }
}
