import '../enum/enum12.dart';

class MessageModel {
  final String senderId;
  final String reciverId;
  final String message;
  final MessageEnum type;
  final DateTime time;
  final String messageId;
  final bool isSeen;
  //final String groupId;

  MessageModel({
    required this.senderId,
    required this.reciverId,
    required this.message,
    required this.type,
    required this.time,
    required this.messageId,
    required this.isSeen,
    //required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'message': message,
      'type': type.type,
      'time': time.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
     // 'groupd':groupId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        senderId: map['senderId'],
        reciverId: map['reciverId'],
        message: map['message'],
        type: (map['type'] as String).toEnum(),
        time: DateTime.fromMillisecondsSinceEpoch(map['time']),
        messageId: map['messageId'],
        isSeen: map['isSeen'],
      //groupId: map['groupId']
        );
    }
}