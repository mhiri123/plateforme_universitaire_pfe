class Message {
  final String text;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String receiverId;
  final String receiverName;
  final String receiverRole;
  final DateTime time;

  Message({
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.receiverId,
    required this.receiverName,
    required this.receiverRole,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': text,
      'sender_id': senderId,
      'sender_username': senderName,
      'sender_role': senderRole,
      'receiver_id': receiverId,
      'receiver_username': receiverName,
      'receiver_role': receiverRole,
      'timestamp': _formatTimestamp(time),
    };
  }

  String _formatTimestamp(DateTime dateTime) {
    return "${dateTime.toIso8601String().split('.')[0]}";
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['message'],
      senderId: json['sender_id'].toString(),
      senderName: json['sender_username'],
      senderRole: json['sender_role'],
      receiverId: json['receiver_id'].toString(),
      receiverName: json['receiver_username'],
      receiverRole: json['receiver_role'],
      time: DateTime.parse(json['timestamp']),
    );
  }
}