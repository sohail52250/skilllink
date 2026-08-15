import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/glass_container.dart';
import '../../../core/services/firestore_service.dart';
import '../bid_service.dart';

class BidScreen extends StatelessWidget {
  BidScreen({super.key});

  final FirestoreService firestore = FirestoreService();
  final BidService bidService = BidService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Job Bidding")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("bids")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bids available"));
          }

          final bids = snapshot.data!.docs;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // ðŸ”¹ JOB INFO (static for now, later dynamic via jobId)
              GlassContainer(
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fix Electrical Issue",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Budget: 5000 PKR"),
                    Text("City: Karachi"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ðŸ”¹ BIDS LIST
              GlassContainer(
                child: Column(
                  children: bids.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(data['workerName'] ?? "Unknown"),
                      subtitle: Text(data['message'] ?? ""),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${data['price']}"),
                          const SizedBox(height: 5),

                          if (data['status'] == "pending")
                            ElevatedButton(
                              onPressed: () async {
                                await bidService.acceptBid(
                                  jobId: data['jobId'],
                                  bidId: doc.id,
                                  workerId: data['workerId'],
                                  amount: data['price'],
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Bid Accepted"),
                                  ),
                                );
                              },
                              child: const Text("Accept"),
                            )
                          else
                            const Text(
                              "Accepted",
                              style: TextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
