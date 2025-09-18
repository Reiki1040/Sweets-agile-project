import 'package:flutter/material.dart';
import 'contact.dart'; // Contactモデル。

/// 連絡先の詳細情報を表示・編集する画面。
class ContactDetailScreen extends StatefulWidget {
  final Contact contact;
  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  // 編集中の連絡先情報を保持する。
  late Contact _editableContact;

  @override
  void initState() {
    super.initState();
    // 最初に渡された連絡先情報で初期化。
    _editableContact = widget.contact;
  }

  /// 削除確認ダイアログを表示する。
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog<bool>( // 戻り値の型を<bool>に指定。
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('連絡先の削除'),
          content: const Text('この連絡先が削除されます。よろしいですか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // falseを返してダイアログを閉じる。
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // trueを返してダイアログを閉じる。
              },
              child: const Text('削除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ).then((isDeleteConfirmed) {
      // ダイアログで「削除」が押された場合（isDeleteConfirmedがtrueの場合）。
      if (isDeleteConfirmed == true) {
        // `true`を返しながら、この詳細画面自体も閉じる。
        // これでホーム画面に「削除された」ことが伝わる。
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // デフォルトの「戻る」動作を一旦無効化。
      onPopInvoked: (didPop) {
        // Popが試みられた際に呼ばれる。
        if (didPop) return;
        // 更新された連絡先データを渡しながら、手動で画面を閉じる。
        Navigator.pop(context, _editableContact);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editableContact.companyName),
        ),
        // ListViewを使って画面全体をスクロール可能にする。
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildDetailItem('企業名', _editableContact.companyName),
            const SizedBox(height: 24),
            _buildDetailItem('担当者名', _editableContact.personName.isNotEmpty ? _editableContact.personName : '未設定'),
            const SizedBox(height: 24),
            _buildDetailItem('電話番号', _editableContact.phoneNumber),
            const SizedBox(height: 24),
            _buildDetailItem('WebサイトURL', _editableContact.url.isNotEmpty ? _editableContact.url : '未設定'),
            const SizedBox(height: 32),
            // 選考ステータス編集ドロップダウン
            DropdownButtonFormField<SelectionStatus>(
              value: _editableContact.status,
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
                    // 状態を更新。
                    _editableContact = _editableContact.copyWith(status: newValue);
                  });
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showDeleteConfirmationDialog(context),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          child: const Icon(Icons.delete),
        ),
      ),
    );
  }

  /// 詳細項目を整形して表示するためのプライベートメソッド。
  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

