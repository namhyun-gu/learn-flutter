import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/model/chat_room.dart';
import 'package:simple_chat/utils.dart';
import 'package:simple_chat/widget/chat_room_item.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({Key key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  String currentUserId;

  @override
  void initState() {
    super.initState();
    Utils.getUserIdFromLocal().then((userId) {
      setState(() {
        currentUserId = userId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('chat_rooms').snapshots(),
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
            final chatRoom = ChatRoom.fromSnapshot(data);
            if (chatRoom.userIds.contains(currentUserId)) {
              return ChatRoomItem(currentUserId, chatRoom);
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .toList(),
    );
  }
}
