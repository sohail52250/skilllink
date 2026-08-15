import 'package:cloud_firestore/cloud_firestore.dart';

class BidService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> placeBid(
    Map<String, dynamic> data,
  ) async {
    await _db.collection('bids').add(data);
  }

  Future<void> acceptBid({
    required String jobId,
    required String bidId,
    required String workerId,
    required int amount,
  }) async {
    await _db.collection('bids').doc(bidId).update({
      'status': 'accepted',
    });

    await _db.collection('jobs').doc(jobId).update({
      'status': 'assigned',
      'assignedWorker': workerId,
      'finalPrice': amount,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getJobs() {
    return _db
        .collection('jobs')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
