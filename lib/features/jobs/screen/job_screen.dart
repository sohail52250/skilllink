import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/job_provider.dart';
import 'post_job_screen.dart';

class JobScreen extends ConsumerWidget {
  const JobScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PostJobScreen(),
                ),
              );
            },
          )
        ],
      ),

      // 🔥 BODY
      body: jobsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text("Error: $e"),
        ),

        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text("No jobs available"),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(jobStreamProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final job = list[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      job.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text("${job.city} • ${job.budget} PKR"),
                    ),

                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: job.status == "open"
                            ? Colors.green.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        job.status,
                        style: TextStyle(
                          color: job.status == "open"
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),

                    // 🔥 CLICK JOB
                    onTap: () {
                      // TODO: open JobDetailScreen (next step)
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}