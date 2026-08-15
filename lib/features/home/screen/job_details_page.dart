import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  final String jobId;
  final Map<String, dynamic> jobData;

  const JobDetailsPage({
    super.key,
    required this.jobId,
    required this.jobData,
  });

  Future<void> applyJob() async {
    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(jobId)
        .collection('applications')
        .add({
      "workerId": "guest_worker",
      "status": "pending",
      "appliedAt": FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(jobData['title'] ?? "Job Details")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobData['title'] ?? '',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("City: ${jobData['city'] ?? ''}"),
            Text("Budget: ₹${jobData['budget'] ?? 0}"),

            const SizedBox(height: 20),

            Text(jobData['description'] ?? "No description"),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                await applyJob();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Applied Successfully")),
                );
              },
              child: const Text("Apply to Job"),
            ),
          ],
        ),
      ),
    );
  }
}