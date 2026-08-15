import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/firestore_service.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final city = TextEditingController();
  final budget = TextEditingController();

  final service = FirestoreService();

  bool isLoading = false;

  @override
  void dispose() {
    title.dispose();
    desc.dispose();
    city.dispose();
    budget.dispose();
    super.dispose();
  }

  Future<void> postJob() async {
    if (title.text.trim().isEmpty ||
        desc.text.trim().isEmpty ||
        city.text.trim().isEmpty ||
        budget.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await service.createJob({
        "title": title.text.trim(),
        "description": desc.text.trim(),
        "city": city.text.trim(),
        "budget": int.tryParse(budget.text.trim()) ?? 0,
        "status": "open",
        "createdBy": "user_001", // 🔥 replace with FirebaseAuth UID later
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Job")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: desc,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: city,
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: budget,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Budget",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : postJob,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Post Job"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}