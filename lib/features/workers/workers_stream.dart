import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkersStream extends StatelessWidget {
  const WorkersStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            return Card(
              color: Colors.white10,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: Text(
                  data['name'] ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  data['skill'] ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            );
          },
        );
      },
    );
  }
}