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
  final List<ExposureLogModel> exposureLogs;
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
    this.exposureLogs = const [],
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
    'exposureLogs': exposureLogs.map((e) => e.toJson()).toList(),
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
    exposureLogs: map['exposureLogs'] != null
        ? List<ExposureLogModel>.from(
            map['exposureLogs'].map((e) => ExposureLogModel.fromJson(e)))
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
      exposureLogs: exposureLogs ?? this.exposureLogs,
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
  final DateTime exposureStart;
  final DateTime exposureEnd;
  final double uvIndex;
  final Duration duration;
  final DateTime logDate;

  ExposureLogModel({
    required this.exposureStart,
    required this.exposureEnd,
    required this.uvIndex,
    required this.duration,
    required this.logDate,
  });

  Map<String, dynamic> toJson() => {
        'exposureStart': exposureStart.toIso8601String(),
        'exposureEnd': exposureEnd.toIso8601String(),
        'uvIndex': uvIndex,
        'duration': duration.inSeconds,
        'logDate': logDate.toIso8601String(),
      };

  factory ExposureLogModel.fromJson(Map<String, dynamic> map) {
    return ExposureLogModel(
      exposureStart: DateTime.parse(map['exposureStart']),
      exposureEnd: DateTime.parse(map['exposureEnd']),
      uvIndex: (map['uvIndex'] ?? 0).toDouble(),
      duration: Duration(seconds: map['duration'] ?? 0),
      logDate: DateTime.parse(map['logDate']),
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


