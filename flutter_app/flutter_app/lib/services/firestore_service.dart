// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/spf_tracker_model.dart';
import '../models/exposure_model.dart';

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

  /// SPF TRACKING SUBCOLLECTION ----------------------

  Future<void> addSPFTracking(String uid, SpfTrackerModel spfData) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('spfTracking')
        .doc(spfData.appliedAt.toIso8601String())
        .set(spfData.toJson());
  }

  Future<List<SpfTrackerModel>> getSPFTracking(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).collection('spfTracking').get();
    return snapshot.docs.map((doc) => SpfTrackerModel.fromJson(doc.data())).toList();
  }

  /// UV EXPOSURE SUBCOLLECTION -----------------------

  Future<void> addUVExposure(String uid, ExposureModel uvData) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('uvData')
        .doc(uvData.date.toIso8601String())
        .set(uvData.toJson());
  }

  Future<List<ExposureModel>> getUVExposure(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).collection('uvData').get();
    return snapshot.docs.map((doc) => ExposureModel.fromJson(doc.data())).toList();
  }

  /// STREAM UV EXPOSURE DATA (real-time updates) -----

  Stream<List<ExposureModel>> streamUVExposure(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('uvData')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ExposureModel.fromJson(doc.data())).toList());
  }
}
