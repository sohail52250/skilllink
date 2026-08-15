import 'package:flutter/material.dart';
import '../../../core/theme/glass_container.dart';

class WorkerCard extends StatelessWidget {
  final String name;
  final String trade;
  final String city;
  final double rating;
  final bool isAvailable;
  final VoidCallback? onTap;

  const WorkerCard({
    super.key,
    required this.name,
    required this.trade,
    required this.city,
    required this.rating,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔹 NAME + STATUS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Icon(
                    Icons.circle,
                    size: 10,
                    color: isAvailable ? Colors.green : Colors.red,
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Text(
                trade,
                style: const TextStyle(color: Colors.white70),
              ),

              Text(
                city,
                style: const TextStyle(color: Colors.white54),
              ),

              const SizedBox(height: 10),

              // 🔹 RATING
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}