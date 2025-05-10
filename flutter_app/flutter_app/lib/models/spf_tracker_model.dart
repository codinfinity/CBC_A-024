import 'package:cloud_firestore/cloud_firestore.dart';

class SpfTrackerModel {
  final String uid;
  final int spfLevel;
  final DateTime appliedAt;
  final DateTime expiresAt;
  final double uvIndexAtTime;

  SpfTrackerModel({
    required this.uid,
    required this.spfLevel,
    required this.appliedAt,
    required this.expiresAt,
    required this.uvIndexAtTime,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'spfLevel': spfLevel,
    'appliedAt': appliedAt,
    'expiresAt': expiresAt,
    'uvIndexAtTime': uvIndexAtTime,
  };

  factory SpfTrackerModel.fromMap(Map<String, dynamic> map) => SpfTrackerModel(
    uid: map['uid'],
    spfLevel: map['spfLevel'],
    appliedAt: (map['appliedAt'] as Timestamp).toDate(),
    expiresAt: (map['expiresAt'] as Timestamp).toDate(),
    uvIndexAtTime: (map['uvIndexAtTime'] ?? 0).toDouble(),
  );
}
