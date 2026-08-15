import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/worker_provider.dart';

class WorkerScreen extends ConsumerWidget {
  const WorkerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workersAsync = ref.watch(workerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("SkillLink Workers"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: workersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text(
            "Error: $e",
            style: const TextStyle(color: Colors.white),
          ),
        ),

        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "No workers found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.95,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final w = list[index];

              return GestureDetector(
                onTap: () {
                  // TODO: WorkerProfileScreen(w.id)
                },

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            // 👤 Avatar
                            const CircleAvatar(
                              radius: 22,
                              child: Icon(Icons.person),
                            ),

                            const SizedBox(height: 10),

                            // NAME
                            Text(
                              w.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 4),

                            // TRADE
                            Text(
                              w.trade,
                              style: const TextStyle(color: Colors.white70),
                            ),

                            const SizedBox(height: 4),

                            // CITY
                            Text(
                              w.city,
                              style: const TextStyle(color: Colors.white54),
                            ),

                            const SizedBox(height: 8),

                            // ⭐ RATING + STATUS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "⭐ ${w.rating}",
                                  style: const TextStyle(color: Colors.amber),
                                ),

                                const SizedBox(width: 8),

                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: w.isAvailable
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}