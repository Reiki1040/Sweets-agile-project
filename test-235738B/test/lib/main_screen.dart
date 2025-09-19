import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'contact.dart';
import 'add_contact_screen.dart';
import 'contact_detail_screen.dart';

/// アプリのメイン画面。データ管理と画面遷移を担当。
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Contact> _allContacts = [];

  /// 新規登録画面へ遷移し、結果を受け取る。
  void _navigateToAddContactScreen() async {
    final newContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
    );
    if (newContact != null) {
      setState(() {
        _allContacts = [..._allContacts, newContact];
      });
    }
  }

  /// 詳細画面へ遷移し、結果（更新 or 削除）を受け取る。
  void _navigateToDetailScreen(Contact contactToDetail) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailScreen(contact: contactToDetail),
      ),
    );

    setState(() {
      if (result == true) { // 削除された場合
        _allContacts = _allContacts.where((c) => c != contactToDetail).toList();
      } else if (result is Contact) { // 更新された場合
        final index = _allContacts.indexOf(contactToDetail);
        if (index != -1) {
          _allContacts = List.from(_allContacts)..[index] = result;
        }
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        contacts: _allContacts,
        onNavigateToDetail: _navigateToDetailScreen,
      ),
      CalendarScreen(
        contacts: _allContacts,
      ),
    ];
    final List<String> pageTitles = ['連絡先一覧', 'カレンダー'];

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[_selectedIndex]),
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddContactScreen,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: '連絡先',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'カレンダー',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

