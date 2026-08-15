import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final _db = FirebaseFirestore.instance;

  Future<void> sendNotification(
    String userId,
    String title,
    String message,
  ) async {
    await _db.collection('notifications').add({
      "userId": userId,
      "title": title,
      "message": message,
      "createdAt": DateTime.now(),
    });
  }

  Stream<List<QueryDocumentSnapshot>> userNotifications(String uid) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((s) => s.docs);
  }
}