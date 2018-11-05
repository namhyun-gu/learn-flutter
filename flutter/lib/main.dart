import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat/chats.dart';
import 'package:simple_chat/intro.dart';
import 'package:simple_chat/users.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<String> _title = ['Users', 'Chats'];
  final List<Widget> _children = [UsersPage(), ChatsPage()];

  PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUserIdFromLocal().then((id) {
      if (id == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => IntroPage()));
      }
    });
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title[_currentIndex]),
        elevation: 1.0,
      ),
      body: PageView(
        children: _children,
        controller: _pageController,
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account), title: Text("Users")),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("Chats"))
        ],
        fixedColor: Colors.blueAccent[400],
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
      ),
    );
  }

  Future<String> _getUserIdFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pref_user_id');
  }

  _onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  _onTapTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}

