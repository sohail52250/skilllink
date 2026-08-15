import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobForm extends StatefulWidget {
  const JobForm({super.key});

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    cityController.dispose();
    budgetController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> submitJob() async {
    if (titleController.text.isEmpty ||
        cityController.text.isEmpty ||
        budgetController.text.isEmpty ||
        descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('jobs').add({
        "title": titleController.text.trim(),
        "city": cityController.text.trim(),
        "budget": int.tryParse(budgetController.text) ?? 0,
        "description": descController.text.trim(),
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
              controller: titleController,
              decoration: const InputDecoration(labelText: "Job Title"),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: "City"),
            ),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Budget"),
            ),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitJob,
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