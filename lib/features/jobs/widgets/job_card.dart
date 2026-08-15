import 'package:flutter/material.dart';
import '../../../core/theme/glass_container.dart';

class JobCard extends StatelessWidget {
  final String jobId;
  final String title;
  final String budget;
  final String city;
  final String status;

  final VoidCallback onBid;

  const JobCard({
    super.key,
    required this.jobId,
    required this.title,
    required this.budget,
    required this.city,
    required this.status,
    required this.onBid,
  });

  Color _statusColor() {
    switch (status) {
      case "open":
        return Colors.green;
      case "assigned":
        return Colors.orange;
      case "closed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔹 TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _statusColor(),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text("📍 $city",
              style: const TextStyle(color: Colors.white70)),
          Text("💰 $budget",
              style: const TextStyle(color: Colors.white70)),

          const SizedBox(height: 12),

          // 🔹 BID BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: status == "open" ? onBid : null,
              child: const Text("Place Bid"),
            ),
          ),
        ],
      ),
    );
  }
}