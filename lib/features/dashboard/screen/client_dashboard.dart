import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/glass_container.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  Stream<Map<String, int>> getStats() async* {
    yield* FirebaseFirestore.instance
        .collection('jobs')
        .snapshots()
        .asyncMap((jobsSnap) async {
      final bidsSnap =
          await FirebaseFirestore.instance.collection('bids').get();

      return {
        "activeJobs": jobsSnap.docs
            .where((doc) => doc['status'] == 'open')
            .length,
        "pendingBids": bidsSnap.docs
            .where((doc) => doc['status'] == 'pending')
            .length,
      };
    });
  }

  Stream<QuerySnapshot> getRecentJobs() {
    return FirebaseFirestore.instance
        .collection('jobs')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isWeb
            ? Row(
                children: [
                  Expanded(child: _buildStats()),
                  const SizedBox(width: 20),
                  Expanded(child: _buildJobs()),
                ],
              )
            : Column(
                children: [
                  _buildStats(),
                  const SizedBox(height: 20),
                  _buildJobs(),
                ],
              ),
      ),
    );
  }

  // 🔹 STATS SECTION
  Widget _buildStats() {
    return StreamBuilder<Map<String, int>>(
      stream: getStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;

        return GlassContainer(
          child: Column(
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text("Active Jobs: ${data['activeJobs']}"),
              Text("Pending Bids: ${data['pendingBids']}"),
            ],
          ),
        );
      },
    );
  }

  // 🔹 JOBS SECTION
  Widget _buildJobs() {
    return GlassContainer(
      child: StreamBuilder<QuerySnapshot>(
        stream: getRecentJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text("No recent jobs");
          }

          final jobs = snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Recent Jobs",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              ...jobs.map((job) {
                final data = job.data() as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['title'] ?? ""),
                  subtitle: Text("Status: ${data['status']}"),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}