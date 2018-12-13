import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:simple_chat/model/chat.dart';
import 'package:simple_chat/utils.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;
  final String anotherUserName;

  ChatRoomPage(this.chatRoomId, this.anotherUserName, {Key key})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoomPage> {
  TextEditingController _chatTextController;
  String _currentUserId;

  @override
  void initState() {
    super.initState();
    _chatTextController = TextEditingController();
    Utils.getUserIdFromLocal().then((userId) {
      setState(() {
        _currentUserId = userId;
      });
    });
  }

  @override
  void dispose() {
    _chatTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.anotherUserName),
        elevation: 1.0,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[_buildBody(context), _buildForm(context)],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var chatStream = Firestore.instance
        .collection('chats')
        .where("chatRoomId", isEqualTo: widget.chatRoomId)
        .orderBy("timestamp")
        .snapshots();

    return Flexible(
        fit: FlexFit.tight,
        child: StreamBuilder<QuerySnapshot>(
          stream: chatStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || _currentUserId == null) return Text("");
            return _buildList(context, snapshot.data.documents);
          },
        ));
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot
          .map((data) {
            final chat = Chat.fromSnapshot(data);
            final chatTime = intl.DateFormat('a hh:mm').format(
                DateTime.fromMillisecondsSinceEpoch(int.parse(chat.timestamp)));
            final isUserChat = chat.userId == _currentUserId;

            return Padding(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 8.0, bottom: 0.0),
                child: Row(
                  textDirection:
                      isUserChat ? TextDirection.rtl : TextDirection.ltr,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          width: 200.0,
                          padding: EdgeInsets.all(8.0),
                          color:
                              isUserChat ? Colors.blueAccent[400] : Colors.grey,
                          child: Text(
                            chat.message,
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    SizedBox(width: 4.0),
                    Text(
                      chatTime,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ));
          })
          .where((item) => item != null)
          .toList(),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Material(
          child: TextFormField(
              style: TextStyle(
                color: Colors.black,
              ),
              controller: _chatTextController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Input text",
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.grey),
                    onPressed: _onSubmitPressed,
                  ))),
        ));
  }

  _onSubmitPressed() {
    var message = _chatTextController.text;
    if (message.isEmpty) return;
    _saveChats(_currentUserId, message, () {
      _chatTextController.text = "";
    });
  }

  _saveChats(String currentUserId, String message, VoidCallback callback) {
    var chat = Chat(widget.chatRoomId, currentUserId, message,
        Timestamp.now().millisecondsSinceEpoch.toString());
    Firestore.instance.collection('chats').add(chat.toMap()).then((ref) {
      callback();
    });
  }
}
