import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class MatchingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  double distance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double radiusKm = 6371;

    final double dLat = _deg(lat2 - lat1);
    final double dLon = _deg(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg(lat1)) *
            cos(_deg(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusKm * c;
  }

  double _deg(double degrees) => degrees * (pi / 180);

  Future<String?> findBestWorker(
    Map<String, dynamic> job,
  ) async {
    final workers = await _db.collection('workers').get();

    double bestScore = double.negativeInfinity;
    String? bestWorkerId;

    final jobLat = (job['lat'] as num?)?.toDouble();
    final jobLng = (job['lng'] as num?)?.toDouble();
    final requiredSkill = job['requiredSkill']?.toString();

    if (jobLat == null || jobLng == null) {
      return null;
    }

    for (final worker in workers.docs) {
      final data = worker.data();

      if (data['isAvailable'] != true) {
        continue;
      }

      final workerLat = (data['lat'] as num?)?.toDouble();
      final workerLng = (data['lng'] as num?)?.toDouble();

      if (workerLat == null || workerLng == null) {
        continue;
      }

      final dist = distance(
        jobLat,
        jobLng,
        workerLat,
        workerLng,
      );

      final skillsRaw = data['skills'];
      final skills = skillsRaw is List
          ? skillsRaw.map((e) => e.toString()).toList()
          : <String>[];

      final skillMatch =
          requiredSkill != null && skills.contains(requiredSkill) ? 1.0 : 0.0;

      final rating =
          (data['rating'] as num?)?.toDouble() ?? 3.0;

      final score =
          (skillMatch * 50) +
          (rating * 10) -
          (dist * 2);

      if (score > bestScore) {
        bestScore = score;
        bestWorkerId = worker.id;
      }
    }

    return bestWorkerId;
  }

  Future<void> autoAssignJob(String jobId) async {
    final jobSnapshot = await _db.collection('jobs').doc(jobId).get();

    final data = jobSnapshot.data();

    if (data == null) {
      return;
    }

    final workerId = await findBestWorker(data);

    if (workerId == null) {
      return;
    }

    await _db.collection('jobs').doc(jobId).update({
      'autoAssignedWorkerId': workerId,
      'status': 'assigned',
    });
  }
}
