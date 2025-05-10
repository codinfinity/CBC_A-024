import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final int age;
  final String gender;
  final String skinType;
  final String email;
  final double currentUVIndex;
  final DateTime createdAt;

  // Subcollections - Now optional with default values
  final List<NotificationModel> notifications;
  final List<SPFTrackerModel> spfTracker;

  UserModel({
    required this.uid,
    required this.name,
    required this.age,
    required this.gender,
    required this.skinType,
    required this.email,
    required this.currentUVIndex,
    required this.createdAt,
    this.notifications = const [],
    this.spfTracker = const [],
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'age': age,
    'gender': gender,
    'skinType': skinType,
    'email': email,
    'currentUVIndex': currentUVIndex,
    'createdAt': createdAt.toIso8601String(),
    'notifications': notifications.map((n) => n.toJson()).toList(),
    'spfTracker': spfTracker.map((s) => s.toJson()).toList(),
  };

  factory UserModel.fromJson(Map<String, dynamic> map) => UserModel(
    uid: map['uid'],
    name: map['name'],
    age: map['age'],
    gender: map['gender'],
    skinType: map['skinType'],
    email: map['email'],
    currentUVIndex: (map['currentUVIndex'] ?? 0).toDouble(),
    createdAt: DateTime.parse(map['createdAt']),
    notifications: map['notifications'] != null
        ? List<NotificationModel>.from(
            map['notifications'].map((n) => NotificationModel.fromJson(n)))
        : [],
    spfTracker: map['spfTracker'] != null
        ? List<SPFTrackerModel>.from(
            map['spfTracker'].map((s) => SPFTrackerModel.fromJson(s)))
        : [],
  );

  UserModel copyWith({
    String? uid,
    String? name,
    int? age,
    String? gender,
    String? skinType,
    String? email,
    double? currentUVIndex,
    Duration? lastExposureDuration,
    DateTime? createdAt,
    List<NotificationModel>? notifications,
    List<ExposureLogModel>? exposureLogs,
    List<SPFTrackerModel>? spfTracker,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      skinType: skinType ?? this.skinType,
      email: email ?? this.email,
      currentUVIndex: currentUVIndex ?? this.currentUVIndex,
      createdAt: createdAt ?? this.createdAt,
      notifications: notifications ?? this.notifications,
      spfTracker: spfTracker ?? this.spfTracker,
    );
  }
}


// Subcollection models:

class NotificationModel {
  final String message;
  final String type; // e.g., 'alert', 'reminder'
  final DateTime timestamp;

  NotificationModel({
    required this.message,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'type': type,
    'timestamp': timestamp.toIso8601String(),
  };

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
      message: map['message'],
      type: map['type'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class ExposureLogModel {
  final double uvIndex;
  final DateTime timestamp;

  ExposureLogModel({
    required this.uvIndex,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'uvIndex': uvIndex,
    'timestamp': Timestamp.fromDate(timestamp),  // Save as Timestamp
  };

  factory ExposureLogModel.fromJson(Map<String, dynamic> map) {
    return ExposureLogModel(
      uvIndex: (map['uvIndex'] ?? 0).toDouble(),
      timestamp: (map['timestamp'] as Timestamp).toDate(),  // Convert Timestamp back to DateTime
    );
  }
}


class SPFTrackerModel {
  final double spfValue;
  final DateTime appliedAt;
  final DateTime expiresAt;

  SPFTrackerModel({
    required this.spfValue,
    required this.appliedAt,
    required this.expiresAt,
  });

  Map<String, dynamic> toJson() => {
    'spfValue': spfValue,
    'appliedAt': Timestamp.fromDate(appliedAt),
    'expiresAt': Timestamp.fromDate(expiresAt),
  };

  factory SPFTrackerModel.fromJson(Map<String, dynamic> map) {
    return SPFTrackerModel(
      spfValue: (map['spfValue'] ?? 0).toDouble(),
      appliedAt: (map['appliedAt'] as Timestamp).toDate(),
      expiresAt: (map['expiresAt'] as Timestamp).toDate(),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   final String uid;
//   final String name;
//   final int age;
//   final String gender;
//   final String skinType;
//   final String email;
//   final double currentUVIndex;
//   final DateTime createdAt;

//   UserModel({
//     required this.uid,
//     required this.name,
//     required this.age,
//     required this.gender,
//     required this.skinType,
//     required this.email,
//     required this.currentUVIndex,
//     required this.createdAt,
//   });

//   Map<String, dynamic> toJson() => {
//     'uid': uid,
//     'name': name,
//     'age': age,
//     'gender': gender,
//     'skinType': skinType,
//     'email': email,
//     'currentUVIndex': currentUVIndex,
//     'createdAt': createdAt.toIso8601String(),
//   };

//   factory UserModel.fromJson(Map<String, dynamic> map) => UserModel(
//     uid: map['uid'],
//     name: map['name'],
//     age: map['age'],
//     gender: map['gender'],
//     skinType: map['skinType'],
//     email: map['email'],
//     currentUVIndex: (map['currentUVIndex'] ?? 0).toDouble(),
//     createdAt: DateTime.parse(map['createdAt']),
//   );

//   UserModel copyWith({
//     String? uid,
//     String? name,
//     int? age,
//     String? gender,
//     String? skinType,
//     String? email,
//     double? currentUVIndex,
//     DateTime? createdAt,
//   }) {
//     return UserModel(
//       uid: uid ?? this.uid,
//       name: name ?? this.name,
//       age: age ?? this.age,
//       gender: gender ?? this.gender,
//       skinType: skinType ?? this.skinType,
//       email: email ?? this.email,
//       currentUVIndex: currentUVIndex ?? this.currentUVIndex,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }


