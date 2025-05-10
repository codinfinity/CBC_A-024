import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// USERS COLLECTION ------------------------------

  Future<void> addUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? UserModel.fromJson(doc.data()!) : null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    await _db.collection('users').doc(uid).update(updates);
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  /// SPF TRACKING (handled inside UserModel.spfTracker now) ----------

  Future<void> addSPFTracking(String uid, SPFTrackerModel spfData) async {
    final userDoc = await _db.collection('users').doc(uid).get();
    if (!userDoc.exists) return;

    final user = UserModel.fromJson(userDoc.data()!);
    final updatedSPFList = [...user.spfTracker, spfData];

    await _db.collection('users').doc(uid).update({
      'spfTracker': updatedSPFList.map((e) => e.toJson()).toList(),
    });
  }

  Future<List<SPFTrackerModel>> getSPFTracking(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return [];

    final user = UserModel.fromJson(doc.data()!);
    return user.spfTracker;
  }
  
Future<SPFTrackerModel?> getLatestSPFTracking(String uid) async {
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('spf_tracker')
      .doc('latest')
      .get();

  if (!doc.exists) return null;

  final data = doc.data()!;
  return SPFTrackerModel(
    spfValue: data['spfvalue']?.toDouble() ?? 0,
    appliedAt: (data['appliedAt'] as Timestamp).toDate(),
    expiresAt: (data['expiresAt'] as Timestamp).toDate(),
  );
}

  /// Exposure logs are now also embedded
Future<List<ExposureLogModel>> getTodayUVLogs(String uid) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final logsSnap = await _db
      .collection('users')
      .doc(uid)
      .collection('exposureLogs')
      .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
      .orderBy('timestamp')
      .get();

  return logsSnap.docs
      .map((doc) => ExposureLogModel.fromJson(doc.data()))
      .toList();
}


Future<List<double>> getWeeklyExposureDurations(String uid) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final List<double> weeklyData = [];

  for (int i = 0; i < 7; i++) {
    final day = now.subtract(Duration(days: 6 - i));
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    if (day.isAfter(today)) {
      weeklyData.add(0); // Add 0 for future dates
      continue;
    }

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('exposureLogs')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timestamp', isLessThan: Timestamp.fromDate(end))
        .orderBy('timestamp')
        .get();

    final logs = snapshot.docs.map((d) => ExposureLogModel.fromJson(d.data())).toList();
    Duration total = Duration.zero;

    for (int j = 0; j < logs.length - 1; j++) {
      if (logs[j].uvIndex > 3) {
        total += logs[j + 1].timestamp.difference(logs[j].timestamp);
      }
    }

    weeklyData.add(total.inMinutes.toDouble());
  }

  return weeklyData;
}



Future<List<ExposureLogModel>> getTodayUVFrom7to7(String uid) async {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day, 7);
  final end = DateTime(now.year, now.month, now.day, 19);

  final snapshot = await _db
      .collection('users')
      .doc(uid)
      .collection('exposureLogs')
      .where('timestamp', isGreaterThan: Timestamp.fromDate(start))
      .where('timestamp', isLessThan: Timestamp.fromDate(end))
      .orderBy('timestamp')
      .get();

  return snapshot.docs.map((d) => ExposureLogModel.fromJson(d.data())).toList();
}

}