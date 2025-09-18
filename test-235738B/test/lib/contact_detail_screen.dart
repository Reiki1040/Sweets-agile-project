import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'contact.dart';
import 'api_key.dart'; // 作成したapi_key.dartをインポート

/// 連絡先の詳細情報を表示・編集する画面。
class ContactDetailScreen extends StatefulWidget {
  final Contact contact;
  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late Contact _editableContact;
  bool _isResearching = false;

  @override
  void initState() {
    super.initState();
    _editableContact = widget.contact;
  }
  
  /// Gemini APIを使って企業情報をリサーチする。
  Future<void> _researchCompany() async {
    setState(() {
      _isResearching = true;
    });

    // --- ★修正点：ハードコードされたキーを削除し、外部から注入されたキーを使用 ---
    if (geminiApiKey.isEmpty) {
      _showErrorDialog('APIキーが設定されていません。');
      setState(() { _isResearching = false; });
      return;
    }
    final apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$geminiApiKey';
    
    final payload = {
      "contents": [{
        "parts": [{
          "text": "${_editableContact.companyName}について、就活生向けに最新のニュース、事業内容、企業文化を簡潔にまとめてください。"
        }]
      }],
      "tools": [{"google_search": {}}],
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final researchResult = data['candidates'][0]['content']['parts'][0]['text'];
          _showResearchResultDialog(researchResult);
        } else {
          _showErrorDialog('予期せぬ形式のレスポンスを受け取りました。');
        }
      } else {
        print('API Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        _showErrorDialog('リサーチに失敗しました (エラーコード: ${response.statusCode})。');
      }
    } catch (e) {
      _showErrorDialog('エラーが発生しました: $e');
    } finally {
      setState(() {
        _isResearching = false;
      });
    }
  }

  // ... (その他のメソッドは変更なし)
  /// AIのリサーチ結果を表示するダイアログ。
  void _showResearchResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${_editableContact.companyName} のリサーチ結果'),
          content: SingleChildScrollView(child: Text(result)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }

  /// 汎用的なエラーダイアログ。
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// 電話をかける処理。
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      _showErrorDialog('このデバイスでは電話をかけることができません。');
    }
  }

  /// 削除確認ダイアログを表示。
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('連絡先の削除'),
          content: const Text('この連絡先が削除されます。よろしいですか？'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('キャンセル')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('削除', style: TextStyle(color: Colors.red))),
          ],
        );
      },
    ).then((isDeleteConfirmed) {
      if (isDeleteConfirmed == true) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context, _editableContact);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_editableContact.companyName)),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildDetailItem('企業名', _editableContact.companyName),
            const SizedBox(height: 24),
            _buildDetailItem('担当者名', _editableContact.personName.isNotEmpty ? _editableContact.personName : '未設定'),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: _buildDetailItem('電話番号', _editableContact.phoneNumber),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () => _makePhoneCall(_editableContact.phoneNumber),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailItem('WebサイトURL', _editableContact.url.isNotEmpty ? _editableContact.url : '未設定'),
            const SizedBox(height: 32),
            DropdownButtonFormField<SelectionStatus>(
              value: _editableContact.status,
              decoration: const InputDecoration(labelText: '選考ステータス', border: OutlineInputBorder()),
              items: SelectionStatus.values.map((status) {
                return DropdownMenuItem(value: status, child: Text(status.displayName));
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _editableContact = _editableContact.copyWith(status: newValue);
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isResearching ? null : _researchCompany,
              icon: _isResearching
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_awesome),
              label: const Text('AIで企業をリサーチ'),
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
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

