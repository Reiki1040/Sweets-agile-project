import 'package:flutter/material.dart';
import 'add_contact_screen.dart'; // 新規登録画面
import 'contact.dart'; // Contactモデル
import 'contact_detail_screen.dart'; // 詳細画面

/// ホーム画面
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = _allContacts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 検索文字列に基づいて連絡先をフィルタリングするメソッド
  void _filterContacts(String query) {
    // 検索結果を格納する一時リスト
    final List<Contact> searchResult;
    if (query.isEmpty) {
      // クエリが空なら全件表示
      searchResult = _allContacts;
    } else {
      // クエリに一致するものを検索
      searchResult = _allContacts.where((contact) {
        final queryLower = query.toLowerCase();
        return contact.companyName.toLowerCase().contains(queryLower) ||
            contact.personName.toLowerCase().contains(queryLower) ||
            contact.phoneNumber.contains(query);
      }).toList();
    }
    // 画面を更新
    setState(() {
      _filteredContacts = searchResult;
    });
  }

  /// 新規登録画面に遷移し、結果を受け取るメソッド
  void _navigateToAddContactScreen() async {
    final newContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
    );

    if (newContact != null) {
      setState(() {
        _allContacts.add(newContact);
        _searchController.clear(); // 検索バーをクリア
        _filterContacts(''); // フィルタをリセット
      });
    }
  }

  /// 詳細画面に遷移し、結果（更新 or 削除）を受け取るメソッド
  void _navigateToDetailScreen(Contact contactToDetail) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailScreen(contact: contactToDetail),
      ),
    );

    if (result == true) { // 削除された場合
      setState(() {
        _allContacts.remove(contactToDetail);
        _filterContacts(_searchController.text);
      });
    } else if (result is Contact) { // 更新された場合
      setState(() {
        final index = _allContacts.indexOf(contactToDetail);
        if (index != -1) {
          _allContacts[index] = result;
        }
        _filterContacts(_searchController.text);
      });
    }
  }

  /// リストが空の場合に表示するメッセージWidget
  Widget _buildEmptyState() {
    // 検索バーに文字が入力されているかどうかでメッセージを分岐
    final isSearching = _searchController.text.isNotEmpty;
    final message = isSearching
        ? '登録されていません。\n就職活動に関係ない連絡の可能性があります。'
        : 'まだ連絡先が登録されていません。';

    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[600], height: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('連絡先一覧'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterContacts,
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
          Expanded(
            child: _filteredContacts.isEmpty
                ? _buildEmptyState() // リストが空の場合の表示
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(contact.companyName.isNotEmpty ? contact.companyName[0] : '?'),
                          ),
                          title: Text(contact.companyName),
                          subtitle: Text('${contact.personName} - ${contact.phoneNumber}'),
                          trailing: Chip(
                            label: Text(
                              contact.status.displayName,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: contact.status.displayColor,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                          ),
                          onTap: () {
                            _navigateToDetailScreen(contact);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddContactScreen,
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
