import 'package:flutter/material.dart';
import 'package:simple_chat/chats.dart';
import 'package:simple_chat/intro.dart';
import 'package:simple_chat/users.dart';
import 'package:simple_chat/utils.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Utils.getUserIdFromLocal().then((id) {
      if (id == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => IntroPage()));
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _childTitle = ['Users', 'Chats'];
    final _children = [UsersPage(), ChatsPage()];

    return Scaffold(
      appBar: AppBar(
        title: Text(_childTitle[_currentIndex]),
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
