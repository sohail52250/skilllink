import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplyJobButton extends StatefulWidget {
  final String jobId;

  const ApplyJobButton({super.key, required this.jobId});

  @override
  State<ApplyJobButton> createState() => _ApplyJobButtonState();
}

class _ApplyJobButtonState extends State<ApplyJobButton> {
  bool loading = false;

  Future<void> apply() async {
    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .collection('applications')
          .add({
        "workerId": "user_001",
        "status": "pending",
        "appliedAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Applied Successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : apply,
      child: loading
          ? const CircularProgressIndicator()
          : const Text("Apply to Job"),
    );
  }
}