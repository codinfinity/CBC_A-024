import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  final String uid;
  final String email;
  final String skinType;
  final double cumulativeExposure;
  final DateTime lastUpdated;

  UserModel({
    required this.uid,
    required this.email,
    required this.skinType,
    required this.cumulativeExposure,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'skinType': skinType,
    'cumulativeExposure': cumulativeExposure,
    'lastUpdated': lastUpdated,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'],
    email: map['email'],
    skinType: map['skinType'],
    cumulativeExposure: (map['cumulativeExposure'] ?? 0).toDouble(),
    lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
  );
}
