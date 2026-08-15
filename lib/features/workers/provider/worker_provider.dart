import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firestore_service.dart';
import '../model/worker_model.dart';

final workerFirestoreProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final workerProvider =
    StreamProvider<List<WorkerModel>>((ref) {
  final service = ref.watch(workerFirestoreProvider);

  return service.streamWorkers().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();

      return WorkerModel.fromMap(
        Map<String, dynamic>.from(data),
        doc.id,
      );
    }).toList();
  });
});
