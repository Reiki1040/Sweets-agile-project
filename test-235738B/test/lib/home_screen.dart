import 'package:flutter/material.dart';
import 'add_contact_screen.dart'; // 新規登録画面

// 連絡先データを表現するためのクラス（モデル）
// NOTE: 将来的には別のファイル（例: models/contact.dart）に分けるのがおすすめです。
class Contact {
  final String companyName;
  final String personName;
  final String phoneNumber;

  // コンストラクタ
  const Contact({
    required this.companyName,
    required this.personName,
    required this.phoneNumber,
  });
}

/// ホーム画面
/// 連絡先の一覧表示と検索機能を持つ。
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // すべての連絡先を保持するリスト（ダミーデータ）
  // NOTE: 将来的にこの部分はデータベースから取得するデータに置き換わります。
  final List<Contact> _allContacts = [
    const Contact(companyName: '株式会社A', personName: '山田 太郎', phoneNumber: '090-1111-1111'),
    const Contact(companyName: 'Bエージェント', personName: '鈴木 花子', phoneNumber: '080-2222-2222'),
    const Contact(companyName: '株式会社C', personName: '佐藤 一郎', phoneNumber: '070-3333-3333'),
    const Contact(companyName: 'Dエージェント', personName: '高橋 次郎', phoneNumber: '090-4444-4444'),
  ];

  // 検索結果を保持するためのリスト
  List<Contact> _filteredContacts = [];

  // initStateはウィジェットが作成された最初の瞬間に一度だけ呼ばれる
  @override
  void initState() {
    super.initState();
    // 最初はすべての連絡先を表示
    _filteredContacts = _allContacts;
  }

  // 検索文字列に基づいて連絡先をフィルタリングするメソッド
  void _filterContacts(String query) {
    // 検索クエリが空の場合は、すべての連絡先を表示
    if (query.isEmpty) {
      setState(() {
        _filteredContacts = _allContacts;
      });
      return;
    }
    // 新しい検索結果を格納するリスト
    final List<Contact> searchResult = [];
    for (final contact in _allContacts) {
      // 会社名、担当者名、電話番号のいずれかにクエリが含まれていたら結果に追加
      if (contact.companyName.toLowerCase().contains(query.toLowerCase()) ||
          contact.personName.toLowerCase().contains(query.toLowerCase()) ||
          contact.phoneNumber.contains(query)) {
        searchResult.add(contact);
      }
    }
    // 画面を更新して、フィルタリングされたリストを表示
    setState(() {
      _filteredContacts = searchResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('連絡先一覧'),
        automaticallyImplyLeading: false, // 戻るボタンを非表示
      ),
      body: Column(
        children: [
          // 検索バー
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterContacts, // 入力が変わるたびにフィルタリングメソッドを呼び出す
              decoration: InputDecoration(
                labelText: '検索',
                hintText: '企業名, 担当者名, 電話番号...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          // 連絡先リスト
          // Expandedを使うことで、残りのスペースすべてをリストが使うようになる
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(contact.companyName[0]),
                    ),
                    title: Text(contact.companyName),
                    subtitle: Text('${contact.personName} - ${contact.phoneNumber}'),
                    onTap: () {
                      // TODO: タップしたら詳細画面に遷移する処理を将来的に追加
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // 新規登録ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ボタンが押されたら新規登録画面に遷移
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactScreen()),
          );
        },
        backgroundColor: Colors.lightBlue, // ボタンの色を水色に変更
        child: const Icon(Icons.add),
      ),
    );
  }
}

