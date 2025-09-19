import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; // httpパッケージ
import 'dart:convert'; // json変換用
import 'contact.dart';
import 'edit_contact_screen.dart';
import 'api_key.dart'; // APIキー

/// 連絡先の詳細情報を表示・編集する画面
class ContactDetailScreen extends StatefulWidget {
  final Contact contact;
  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late Contact _editableContact;
  bool _isResearching = false; // AIリサーチ中の状態管理

  @override
  void initState() {
    super.initState();
    _editableContact = widget.contact;
  }
  
  /// 編集画面に遷移し、結果を受け取る
  Future<void> _navigateToEditScreen() async {
    final updatedContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(
        builder: (context) => EditContactScreen(contact: _editableContact),
      ),
    );

    if (updatedContact != null) {
      setState(() {
        _editableContact = updatedContact;
      });
    }
  }

  /// 新しい予定を追加するためのダイアログを表示
  Future<void> _showAddEventDialog() async {
    final eventTitleController = TextEditingController();
    DateTime selectedDateTime = DateTime.now();

    final newEvent = await showDialog<ScheduleEvent>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('新しい予定を追加'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: eventTitleController,
                    decoration: const InputDecoration(labelText: '予定のタイトル'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 20),
                  Text('選択日時: ${DateFormat('yyyy/MM/dd HH:mm').format(selectedDateTime)}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(context: context, initialDate: selectedDateTime, firstDate: DateTime(2020), lastDate: DateTime(2030));
                          if (pickedDate != null) {
                            setDialogState(() {
                              selectedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, selectedDateTime.hour, selectedDateTime.minute);
                            });
                          }
                        }, 
                        child: const Text('日付を選択'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(selectedDateTime));
                          if (pickedTime != null) {
                            setDialogState(() {
                              selectedDateTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, pickedTime.hour, pickedTime.minute);
                            });
                          }
                        },
                        child: const Text('時間を選択'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
                TextButton(
                  onPressed: () {
                    if (eventTitleController.text.isNotEmpty) {
                      final event = ScheduleEvent(title: eventTitleController.text, date: selectedDateTime);
                      Navigator.pop(context, event);
                    }
                  },
                  child: const Text('追加'),
                ),
              ],
            );
          },
        );
      },
    );

    if (newEvent != null) {
      setState(() {
        final updatedEvents = List<ScheduleEvent>.from(_editableContact.events)..add(newEvent);
        updatedEvents.sort((a, b) => a.date.compareTo(b.date));
        _editableContact = _editableContact.copyWith(events: updatedEvents);
      });
    }
  }

  /// 新しいメモを追加するためのダイアログを表示
  Future<void> _showAddMemoDialog() async {
    final memoController = TextEditingController();
    final newMemoContent = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('通話メモを追加'),
          content: TextField(
            controller: memoController,
            decoration: const InputDecoration(hintText: '会話の内容を記録...'),
            autofocus: true,
            maxLines: 5,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
            TextButton(
              onPressed: () {
                if (memoController.text.isNotEmpty) {
                  Navigator.pop(context, memoController.text);
                }
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );

    if (newMemoContent != null) {
      setState(() {
        final newMemo = Memo(content: newMemoContent, createdAt: DateTime.now());
        final updatedMemos = [newMemo, ..._editableContact.memos];
        _editableContact = _editableContact.copyWith(memos: updatedMemos);
      });
    }
  }

  /// Gemini APIを使って企業情報をリサーチする
  Future<void> _researchCompany() async {
    setState(() { _isResearching = true; });

    if (geminiApiKey.isEmpty) {
      _showErrorDialog('APIキーが設定されていません。');
      setState(() { _isResearching = false; });
      return;
    }
    final apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$geminiApiKey';
    
    final payload = {
      "contents": [{"parts": [{"text": "${_editableContact.companyName}について、就活生向けに最新のニュース、事業内容、企業文化を簡潔にまとめてください。"}]}],
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
        _showErrorDialog('リサーチに失敗しました (エラーコード: ${response.statusCode})。');
      }
    } catch (e) {
      _showErrorDialog('エラーが発生しました: $e');
    } finally {
      setState(() { _isResearching = false; });
    }
  }

  /// AIのリサーチ結果を表示するダイアログ
  void _showResearchResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_editableContact.companyName} のリサーチ結果'),
        content: SingleChildScrollView(child: Text(result)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('閉じる'))],
      ),
    );
  }

  /// 汎用的なエラーダイアログ
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  // 電話をかける処理
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('電話をかけられません。')));
    }
  }

  // 削除確認ダイアログ表示
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('連絡先の削除'),
        content: const Text('この連絡先が削除されます。よろしいですか？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('キャンセル')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('削除', style: TextStyle(color: Colors.red))),
        ],
      ),
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
        appBar: AppBar(
          title: Text(_editableContact.companyName),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToEditScreen,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // --- 連絡先詳細セクション ---
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
            // --- AIリサーチボタン ---
            ElevatedButton.icon(
              onPressed: _isResearching ? null : _researchCompany,
              icon: _isResearching
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_awesome),
              label: const Text('AIで企業をリサーチ'),
            ),
            const SizedBox(height: 32),
            
            // --- 予定セクション ---
            _buildSectionHeader('関連する予定', onAdd: _showAddEventDialog),
            const Divider(),
            if (_editableContact.events.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Text('登録された予定はありません。')))
            else
              ..._editableContact.events.map((event) {
                return ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(event.title),
                  subtitle: Text(DateFormat('yyyy年M月d日 HH:mm').format(event.date)),
                );
              }).toList(),
            const SizedBox(height: 32),

            // --- 通話メモセクション ---
            _buildSectionHeader('通話メモ', onAdd: _showAddMemoDialog),
            const Divider(),
            if (_editableContact.memos.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Text('登録されたメモはありません。')))
            else
              ..._editableContact.memos.map((memo) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(memo.content),
                    subtitle: Text(DateFormat('yyyy年M月d日 HH:mm').format(memo.createdAt)),
                  ),
                );
              }).toList(),
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

  /// 詳細項目を整形して表示するためのプライベートメソッド
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

  /// セクションヘッダー（タイトルと追加ボタン）を表示するためのメソッド
  Widget _buildSectionHeader(String title, {required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_circle_outline, size: 20),
          label: const Text('追加'),
        ),
      ],
    );
  }
}

