import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  Stream<QuerySnapshot> getJobs() {
    return FirebaseFirestore.instance
        .collection("jobs")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(title: const Text("Jobs")),

      body: StreamBuilder<QuerySnapshot>(
        stream: getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No jobs available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              final data = job.data() as Map<String, dynamic>;

              return _jobCard(
                title: data["title"] ?? "",
                desc: data["description"] ?? "",
                budget: data["budget"]?.toString() ?? "0",
                onTap: () {
                  // 🔥 later: JobDetailScreen(jobId: job.id)
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _jobCard({
    required String title,
    required String desc,
    required String budget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              desc,
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 10),

            Text(
              "Budget: \$$budget",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}