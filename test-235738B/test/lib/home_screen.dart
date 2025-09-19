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

  // 選択中のステータスフィルターを管理する状態変数
  SelectionStatus? _selectedStatusFilter; // nullの場合は「すべて」を示す

  @override
  void initState() {
    super.initState();
    _applyFilters(); // 初期表示時にフィルターを適用
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.contacts != oldWidget.contacts) {
      _applyFilters(); // 親ウィジェットのデータが更新されたらフィルターを再適用
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// テキスト検索とステータスフィルターの両方を適用するメソッド
  void _applyFilters() {
    final query = _searchController.text;
    List<Contact> searchResult;

    // 1. テキスト検索フィルタリング
    if (query.isEmpty) {
      searchResult = widget.contacts;
    } else {
      final queryLower = query.toLowerCase();
      searchResult = widget.contacts.where((contact) {
        final phoneNumberWithoutHyphens = contact.phoneNumber.replaceAll('-', '');
        return contact.companyName.toLowerCase().contains(queryLower) ||
            contact.personName.toLowerCase().contains(queryLower) ||
            phoneNumberWithoutHyphens.startsWith(query);
      }).toList();
    }

    // 2. 選考ステータスフィルタリング
    if (_selectedStatusFilter != null) {
      searchResult = searchResult.where((contact) {
        return contact.status == _selectedStatusFilter;
      }).toList();
    }
    
    // 画面を更新
    setState(() {
      _filteredContacts = searchResult;
    });
  }

  /// リストが空の場合に表示するメッセージWidget
  Widget _buildEmptyState() {
    final isSearching = _searchController.text.isNotEmpty || _selectedStatusFilter != null;
    final message = isSearching
        ? '条件に一致する連絡先はありません。'
        : 'まだ連絡先が登録されていません。';

    return Center(
      child: Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], height: 1.5)),
    );
  }

  /// ステータスフィルタ用のチップを生成するWidget
  Widget _buildStatusFilters() {
    final List<SelectionStatus?> allFilters = [null, ...SelectionStatus.values];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: allFilters.map((status) {
          final isSelected = _selectedStatusFilter == status;
          
          // ★修正点：各ステータスの件数を計算
          final count = status == null
              ? widget.contacts.length // 「すべて」の場合は総件数
              : widget.contacts.where((c) => c.status == status).length;
          
          final labelText = '${status?.displayName ?? 'すべて'} : $count';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(labelText), // ★修正点：件数付きのラベルを表示
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedStatusFilter = selected ? status : null;
                  _applyFilters();
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => _applyFilters(),
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
        _buildStatusFilters(),
        const SizedBox(height: 8),
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

