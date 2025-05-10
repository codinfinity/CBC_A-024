import 'package:cloud_firestore/cloud_firestore.dart';
class NotificationModel {
  final String uid;
  final String message;
  final String type; // e.g., 'alert', 'reminder'
  final DateTime timestamp;

  NotificationModel({
    required this.uid,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'message': message,
    'type': type,
    'timestamp': timestamp,
  };

  factory NotificationModel.fromMap(Map<String, dynamic> map) => NotificationModel(
    uid: map['uid'],
    message: map['message'],
    type: map['type'],
    timestamp: (map['timestamp'] as Timestamp).toDate(),
  );
}
