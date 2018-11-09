import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/chat_room.dart';
import 'package:simple_chat/model/chat_room.dart';
import 'package:simple_chat/model/user.dart';

class ChatRoomItem extends StatefulWidget {
  final String currentUserId;
  final ChatRoom chatRoomItem;

  ChatRoomItem(this.currentUserId, this.chatRoomItem);

  @override
  _ChatRoomItemState createState() => _ChatRoomItemState();
}

class _ChatRoomItemState extends State<ChatRoomItem> {
  String anotherUserName = "";

  @override
  void initState() {
    super.initState();
    var anotherUserId = widget.chatRoomItem.userIds
        .firstWhere((id) => id != widget.currentUserId);
    _getUserById(anotherUserId, (user) {
      setState(() {
        anotherUserName = user.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatRoom = widget.chatRoomItem;
    final chatRoomId = chatRoom.reference.documentID;
    final latestMessage = chatRoom.latestMessage;

    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor: anotherUserName.isNotEmpty
                ? Colors.blueAccent[400]
                : Colors.grey,
            child: Text(anotherUserName.isNotEmpty
                ? anotherUserName[0].toUpperCase()
                : ""),
          ),
          title: Text(anotherUserName),
          subtitle: Text(
              latestMessage != null && anotherUserName.isNotEmpty
                  ? latestMessage
                  : "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatRoomPage(chatRoomId, anotherUserName)));
          },
        ),
        Divider(
          height: 4.0,
          indent: 72.0,
        )
      ],
    );
  }

  _getUserById(String userId, void callback(User user)) {
    Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((snapshot) {
      callback(User.fromSnapshot(snapshot));
    });
  }
}
