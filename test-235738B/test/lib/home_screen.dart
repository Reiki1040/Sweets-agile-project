import 'package:flutter/material.dart';
import 'contact.dart';

/// 連絡先一覧を表示するページ（UIのみを担当）。
class HomeScreen extends StatefulWidget {
  final List<Contact> contacts;
  final Function(Contact) onNavigateToDetail;

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
  SelectionStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.contacts != oldWidget.contacts) {
      _applyFilters();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text;
    List<Contact> searchResult = widget.contacts;

    if (query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      searchResult = searchResult.where((contact) {
        final phoneNumberWithoutHyphens = contact.phoneNumber.replaceAll('-', '');
        return contact.companyName.toLowerCase().contains(queryLower) ||
            contact.personName.toLowerCase().contains(queryLower) ||
            phoneNumberWithoutHyphens.startsWith(query);
      }).toList();
    }

    if (_selectedStatusFilter != null) {
      searchResult = searchResult.where((contact) {
        return contact.status == _selectedStatusFilter;
      }).toList();
    }
    
    setState(() {
      _filteredContacts = searchResult;
    });
  }

  Widget _buildStatusFilters() {
    final allFilters = [null, ...SelectionStatus.values];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: allFilters.map((status) {
          final isSelected = _selectedStatusFilter == status;
          final count = status == null
              ? widget.contacts.length
              : widget.contacts.where((c) => c.status == status).length;
          final labelText = '${status?.displayName ?? 'すべて'} [$count]';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(labelText),
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
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
        ),
        _buildStatusFilters(),
        const SizedBox(height: 8),
        Expanded(
          child: _filteredContacts.isEmpty
              ? const Center(child: Text('該当する連絡先はありません。'))
              : ListView.builder(
                  itemCount: _filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = _filteredContacts[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text(contact.companyName.isNotEmpty ? contact.companyName[0] : '')),
                        title: Text(contact.companyName),
                        subtitle: Text('${contact.personName} - ${contact.phoneNumber}'),
                        trailing: Chip(
                          label: Text(contact.status.displayName, style: const TextStyle(color: Colors.white)),
                          backgroundColor: contact.status.displayColor,
                        ),
                        onTap: () => widget.onNavigateToDetail(contact),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

