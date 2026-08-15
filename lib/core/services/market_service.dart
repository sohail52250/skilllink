import 'package:cloud_firestore/cloud_firestore.dart';

class MarketService {
  final db = FirebaseFirestore.instance;

  // ASSIGN WORKER
  Future<void> assignWorker(String jobId, String workerId) async {
    await db.collection('jobs').doc(jobId).update({
      "assignedWorkerId": workerId,
      "status": "assigned",
    });
  }

  // COMPLETE JOB
  Future<void> completeJob(String jobId) async {
    await db.collection('jobs').doc(jobId).update({
      "status": "completed",
    });
  }

  // CREDIT SYSTEM
  Future<void> rewardWorker(String workerId, int credits) async {
    await db.collection('users').doc(workerId).update({
      "credits": FieldValue.increment(credits),
    });
  }

  Future<void> deductCredits(String userId, int credits) async {
    await db.collection('users').doc(userId).update({
      "credits": FieldValue.increment(-credits),
    });
  }
}