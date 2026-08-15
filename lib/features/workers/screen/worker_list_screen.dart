import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/worker_provider.dart';
import '../model/worker_model.dart';

class WorkerListScreen extends ConsumerWidget {
  const WorkerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workersAsync = ref.watch(workerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(title: const Text("Workers")),

      body: workersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text(
            "Error: $e",
            style: const TextStyle(color: Colors.white),
          ),
        ),

        data: (workers) {
          if (workers.isEmpty) {
            return const Center(
              child: Text(
                "No workers found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final worker = workers[index];

              return _workerCard(worker);
            },
          );
        },
      ),
    );
  }

  Widget _workerCard(WorkerModel worker) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [

          const CircleAvatar(
            child: Icon(Icons.person),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  worker.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "${worker.trade} • ${worker.rating} ⭐",
                  style: const TextStyle(color: Colors.white70),
                ),

                Text(
                  worker.city,
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),

          // 🔥 Future: Hire button
          ElevatedButton(
            onPressed: () {
              // TODO: open worker profile / hire flow
            },
            child: const Text("Hire"),
          ),
        ],
      ),
    );
  }
}