import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'job_details_page.dart';

class LiveJobsTest extends StatelessWidget {
  const LiveJobsTest({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              color: Colors.white10,
              child: ListTile(
                title: Text(
                  data['title'] ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  data['city'] ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  "₹${data['budget'] ?? 0}",
                  style: const TextStyle(color: Colors.white),
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JobDetailsPage(
                        jobId: doc.id,
                        jobData: data,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}