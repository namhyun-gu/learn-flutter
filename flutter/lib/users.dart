import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/model/chat_room.dart';
import 'package:simple_chat/model/user.dart';
import 'package:simple_chat/utils.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String currentUserId;

  @override
  void initState() {
    super.initState();
    Utils.getUserIdFromLocal().then((userId) {
      currentUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot
          .map((data) {
            final user = User.fromSnapshot(data);
            if (user.reference.documentID != currentUserId) {
              return _buildListItem(context, user);
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, User user) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent[400],
            child: Text(user.name[0].toUpperCase()),
          ),
          title: Text(user.name),
          onTap: () {
            _onUserTapped(user.reference.documentID);
          },
        ),
        Divider(
          height: 4.0,
          indent: 72.0,
        )
      ],
    );
  }

  _onUserTapped(String tappedUserId) {
    _saveChatRoom([currentUserId, tappedUserId], (ref) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Created chat room (${ref.documentID})')));
    });
  }

  _saveChatRoom(List<String> userIds, void callback(DocumentReference ref)) {
    Firestore.instance
        .collection('chat_rooms')
        .add(ChatRoom(userIds).toMap())
        .then((ref) {
      callback(ref);
    });
  }
}
