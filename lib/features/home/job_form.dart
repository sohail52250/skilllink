import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobForm extends StatefulWidget {
  const JobForm({super.key});

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();

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
        "createdBy": "client", // later replace with FirebaseAuth UID
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
                labelText: "Job Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: desc,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
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