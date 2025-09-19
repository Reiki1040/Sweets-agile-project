import 'package:flutter/material.dart';
import 'contact.dart'; // Contactモデル

/// 連絡先一覧を表示するページ（UIのみを担当）
class HomeScreen extends StatefulWidget {
  final List<Contact> contacts;
  final Function(Contact) onNavigateToDetail; // 詳細画面へ遷移するためのコールバック

  const HomeScreen({
    super.key,
    required this.contacts,
    required this.onNavigateToDetail,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    // initStateでは、親から渡されたデータで初期化する
    _updateFilteredContacts(widget.contacts);
  }

  // 親ウィジェットから渡されるデータが変更されたときに呼ばれる
  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 親のデータソース（_allContacts）が変更されたら、こちらも更新する
    if (widget.contacts != oldWidget.contacts) {
      _updateFilteredContacts(widget.contacts);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  // 検索とリストの更新を1つのメソッドにまとめる
  void _updateFilteredContacts(List<Contact> allContacts) {
    final query = _searchController.text;
    if (query.isEmpty) {
      _filteredContacts = allContacts;
    } else {
      _filteredContacts = allContacts.where((contact) {
        final queryLower = query.toLowerCase();
        return contact.companyName.toLowerCase().contains(queryLower) ||
            contact.personName.toLowerCase().contains(queryLower) ||
            contact.phoneNumber.contains(query);
      }).toList();
    }
  }

  /// 検索文字列に基づいて連絡先をフィルタリング
  void _filterContacts(String query) {
    setState(() {
      _updateFilteredContacts(widget.contacts);
    });
  }

  /// リストが空の場合のメッセージWidget
  Widget _buildEmptyState() {
    final isSearching = _searchController.text.isNotEmpty;
    final message = isSearching
        ? '登録されていません。\n就職活動に関係ない連絡の可能性があります。'
        : 'まだ連絡先が登録されていません。';

    return Center(
      child: Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], height: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBarを削除し、PaddingとTextFieldのみにする
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
              ? _buildEmptyState()
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
                          label: Text(contact.status.displayName, style: const TextStyle(color: Colors.white, fontSize: 12)),
                          backgroundColor: contact.status.displayColor,
                        ),
                        onTap: () {
                          widget.onNavigateToDetail(contact);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

