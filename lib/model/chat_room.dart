import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final DocumentReference reference;
  final List<dynamic> userIds;
  final String latestMessage;

  ChatRoom(this.userIds, {this.reference, this.latestMessage});

  ChatRoom.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['userIds'] != null),
        userIds = map['userIds'],
        latestMessage = map['latestMessage'];

  ChatRoom.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() {
    return {'userIds': userIds, 'latestMessage': latestMessage};
  }

  @override
  String toString() {
    return 'ChatRoom{userIds: $userIds, latestMessage: $latestMessage}';
  }
}
