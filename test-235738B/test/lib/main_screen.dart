import 'package:flutter/material.dart';
import 'home_screen.dart'; // 連絡先一覧ページ
import 'calendar_screen.dart'; // カレンダーページ
import 'contact.dart'; // Contactモデル
import 'add_contact_screen.dart'; // 新規登録画面
import 'contact_detail_screen.dart'; // 詳細画面

/// アプリのメインとなる画面（ボトムナビゲーションバーを持つ）
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // --- 状態管理：ここがアプリのデータ管理の中心 ---
  List<Contact> _allContacts = []; // finalを外して、リストを再代入可能にする

  /// 新規登録画面に遷移し、結果を受け取る
  void _navigateToAddContactScreen() async {
    final newContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
    );
    if (newContact != null) {
      setState(() {
        // ★修正点: 新しいリストを作成して再代入することで、変更を確実に通知する
        _allContacts = [..._allContacts, newContact];
      });
    }
  }

  /// 詳細画面に遷移し、結果（更新 or 削除）を受け取る
  void _navigateToDetailScreen(Contact contactToDetail) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailScreen(contact: contactToDetail),
      ),
    );

    setState(() {
      if (result == true) { // 削除された場合
        // ★修正点: 削除された要素を除いた新しいリストを作成
        _allContacts = _allContacts.where((contact) => contact != contactToDetail).toList();
      } else if (result is Contact) { // 更新された場合
        final index = _allContacts.indexOf(contactToDetail);
        if (index != -1) {
          // ★修正点: 更新された要素を差し替えた新しいリストを作成
          _allContacts = List.from(_allContacts)..[index] = result;
        }
      }
    });
  }
  // --- 状態管理ここまで ---

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // buildメソッドの中でページのリストを毎回生成する
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
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddContactScreen,
        backgroundColor: Colors.lightBlue,
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

