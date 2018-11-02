import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_chat/chats.dart';
import 'package:simple_chat/users.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.grey[200],
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[200],
        systemNavigationBarIconBrightness: Brightness.dark));
    return MaterialApp(
      title: 'SimpleChat',
      theme: ThemeData(
          primaryColor: Colors.white, accentColor: Colors.blueAccent[400]),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title[_currentIndex]),
        elevation: 1.0,
      ),
      body: PageView(
        children: _children,
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account), title: Text("Users")),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("Chats"))
        ],
        fixedColor: Colors.blueAccent[400],
        onTap: onTapTapped,
        currentIndex: _currentIndex,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  void onTapTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}
