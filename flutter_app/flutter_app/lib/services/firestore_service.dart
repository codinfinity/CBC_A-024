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

  /// Exposure logs are now also embedded
  Future<void> addUVExposure(String uid, ExposureLogModel uvData) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return;

    final user = UserModel.fromJson(doc.data()!);
    final updatedLogs = [...user.exposureLogs, uvData];

    await _db.collection('users').doc(uid).update({
      'exposureLogs': updatedLogs.map((e) => e.toJson()).toList(),
    });
  }

  Future<void> logExposureIfHighUV(String uid, double uvIndex) async {
  if (uvIndex <= 3) return;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final exposureLogRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('exposureLogs');

  // You can optimize this to get only today's logs
  final logsSnap = await exposureLogRef
      .where('logDate', isEqualTo: today.toIso8601String())
      .get();

  if (logsSnap.docs.isNotEmpty) {
    // Extend the last log by 30 minutes
    final last = ExposureLogModel.fromJson(logsSnap.docs.last.data());

    final updated = ExposureLogModel(
      exposureStart: last.exposureStart,
      exposureEnd: now,
      uvIndex: uvIndex,
      duration: last.duration + const Duration(minutes: 30),
      logDate: today,
    );

    await exposureLogRef.doc(logsSnap.docs.last.id).set(updated.toJson());
  } else {
    final newLog = ExposureLogModel(
      exposureStart: now.subtract(const Duration(minutes: 30)),
      exposureEnd: now,
      uvIndex: uvIndex,
      duration: const Duration(minutes: 30),
      logDate: today,
    );

    await exposureLogRef.add(newLog.toJson());
  }
}


  Future<List<ExposureLogModel>> getUVExposure(String uid) async {
  final logsSnap = await _db
      .collection('users')
      .doc(uid)
      .collection('exposureLogs')
      .get();

  return logsSnap.docs
      .map((doc) => ExposureLogModel.fromJson(doc.data()))
      .toList();
}
}
