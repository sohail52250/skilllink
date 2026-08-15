import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firestore_service.dart';
import '../model/job_model.dart';

final firestoreProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final jobStreamProvider =
    StreamProvider<List<JobModel>>((ref) {
  final service = ref.watch(firestoreProvider);

  return service.streamJobs().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();

      return JobModel.fromMap(
        Map<String, dynamic>.from(data),
        doc.id,
      );
    }).toList();
  });
});
