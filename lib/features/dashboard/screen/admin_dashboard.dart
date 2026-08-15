import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Stream<Map<String, int>> getStats() async* {
    yield* FirebaseFirestore.instance
        .collection('jobs')
        .snapshots()
        .asyncMap((jobsSnap) async {
      final usersSnap =
          await FirebaseFirestore.instance.collection('users').get();
      final workersSnap =
          await FirebaseFirestore.instance.collection('workers').get();
      final bidsSnap =
          await FirebaseFirestore.instance.collection('bids').get();

      return {
        "users": usersSnap.size,
        "workers": workersSnap.size,
        "jobs": jobsSnap.size,
        "bids": bidsSnap.size,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: StreamBuilder<Map<String, int>>(
        stream: getStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [

                _card("Users", data['users'] ?? 0, Icons.person),
                _card("Workers", data['workers'] ?? 0, Icons.engineering),
                _card("Jobs", data['jobs'] ?? 0, Icons.work),
                _card("Bids", data['bids'] ?? 0, Icons.gavel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(String title, int value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 10),
            Text(
              "$value",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}