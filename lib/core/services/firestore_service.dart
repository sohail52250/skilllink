import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _jobs =>
      _db.collection('jobs');

  CollectionReference<Map<String, dynamic>> get _workers =>
      _db.collection('workers');

  CollectionReference<Map<String, dynamic>> get _bids =>
      _db.collection('bids');

  Stream<QuerySnapshot<Map<String, dynamic>>> getJobs() {
    return _jobs.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamJobs() {
    return _jobs.orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamWorkers() {
    return _workers.snapshots();
  }

  Future<void> addJob(Map<String, dynamic> data) async {
    await _jobs.add(data);
  }

  Future<void> createJob(Map<String, dynamic> data) async {
    await addJob(data);
  }

  Future<void> addBid(Map<String, dynamic> data) async {
    await _bids.add(data);
  }

  Future<void> acceptBid(
    String jobId,
    String workerId,
  ) async {
    await _jobs.doc(jobId).update({
      'status': 'assigned',
      'assignedTo': workerId,
    });
  }

  Future<void> updateCredits(
    String userId,
    int value,
  ) async {
    await _db.collection('users').doc(userId).update({
      'credits': FieldValue.increment(value),
    });
  }
}

class JobLogic {
  static const String open = 'open';
  static const String assigned = 'assigned';
  static const String completed = 'completed';
}
