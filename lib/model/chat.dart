import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatRoomId;
  final String userId;
  final String message;
  final String timestamp;
  final DocumentReference reference;

  Chat(this.chatRoomId, this.userId, this.message, this.timestamp,
      {this.reference});

  Chat.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['chatRoomId'] != null),
        assert(map['userId'] != null),
        assert(map['message'] != null),
        assert(map['timestamp'] != null),
        chatRoomId = map['chatRoomId'],
        userId = map['userId'],
        message = map['message'],
        timestamp = map['timestamp'];

  Chat.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'userId': userId,
      'message': message,
      'timestamp': timestamp
    };
  }

  @override
  String toString() {
    return 'Chat{chatRoomId: $chatRoomId, userId: $userId, message: $message, timestamp: $timestamp}';
  }
}
