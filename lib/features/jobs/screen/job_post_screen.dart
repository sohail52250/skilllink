import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobPostScreen extends StatefulWidget {
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  final title = TextEditingController();
  final desc = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    title.dispose();
    desc.dispose();
    super.dispose();
  }

  Future<void> postJob() async {
    if (title.text.trim().isEmpty || desc.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection("jobs").add({
        "title": title.text.trim(),
        "description": desc.text.trim(),
        "status": "open",
        "createdBy": "user_001", // 🔥 replace with FirebaseAuth later
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
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(title: const Text("Post Job")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: title,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Job Title",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: desc,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Job Description",
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