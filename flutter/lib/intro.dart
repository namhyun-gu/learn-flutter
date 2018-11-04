import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat/main.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  TextEditingController _nameTextController;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        body: Builder(
      builder: (context) => _buildBody(context, theme),
    ));
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(),
            _buildCenter(context, theme),
            _buildBottom(context, theme)
          ],
        ));
  }

  Widget _buildCenter(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("What's your name?", style: theme.textTheme.headline),
        SizedBox(height: 40.0),
        TextFormField(
          controller: _nameTextController,
          decoration: InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              hintText: 'Input name'),
        ),
      ],
    );
  }

  Widget _buildBottom(BuildContext context, ThemeData theme) {
    return RaisedButton(
        child: const Text('START'),
        color: theme.accentColor,
        textColor: Colors.white,
        onPressed: () {
          _onButtonPressed(context);
        });
  }

  _onButtonPressed(BuildContext context) {
    var name = _nameTextController.text;
    if (name.isEmpty) {
      _showNoInputDialog(context);
      return;
    }

    _saveUserToRemote(name, (refId) {
      _saveUserToLocal(refId);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    });
  }

  _saveUserToRemote(String name, void callback(String refId)) {
    Firestore.instance.collection('users').add({'name': name}).then((ref) {
      callback(ref.documentID);
    });
  }

  _saveUserToLocal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pref_user_id', id);
  }

  _showNoInputDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Can\'t Start"),
            content: Text('No name from input'),
            actions: [
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
