import 'dart:async';
import 'package:skilllink/services/update_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pub_semver/pub_semver.dart';

import 'package:skilllink/generated/app_localizations.dart';

import '../../../core/role/role_manager.dart';
import '../../../core/language/language_service.dart';

import 'worker_form.dart';
import 'job_form.dart';
import 'live_jobs_test.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale)? onLocaleChange;

  const HomeScreen({super.key, this.onLocaleChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String query = "";

  final String currentVersion = "1.0.0";
  String? latestVersion;
  String? apkUrl;
  bool forceUpdate = false;

  Timer? _updateTimer;

  static const bg = Color(0xFFEAF6FF);
  static const card = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFF5B6B7A);
  static const primary = Color(0xFF4DA3FF);
  static const success = Color(0xFF00C2A8);
  static const warning = Color(0xFFFFB703);
  static const purple = Color(0xFF9B5DE5);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdate();
    });

    if (_updateTimer?.isActive != true) {
      _updateTimer = Timer.periodic(
        const Duration(hours: 6),
        (_) => checkForUpdate(),
      );
    }
  }

  Future<void> changeLanguage(String code) async {
    await LanguageService.save(code);
    widget.onLocaleChange?.call(Locale(code));
  }

  Version? tryParseVersion(String? v) {
    final value = v?.trim();
    if (value == null || value.isEmpty) return null;

    try {
      return Version.parse(value);
    } catch (_) {
      return null;
    }
  }

  Future<void> checkForUpdate() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('version')
          .get();

      if (!doc.exists || doc.data() == null) return;

      final data = doc.data()!;

      latestVersion = data['latest_version']?.toString();
      final rawUrl = data['apk_url']?.toString();

      if (rawUrl != null && rawUrl.startsWith("http")) {
        apkUrl = rawUrl;
      }

      final current = tryParseVersion(currentVersion);
      final latest = tryParseVersion(latestVersion);

      if (current != null && latest != null && latest > current) {
        if (mounted) {
          setState(() => forceUpdate = true);

          Future.delayed(Duration.zero, () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text("Update Available"),
                content: const Text(
                  "A new version of SkillLink is available. Please update to continue.",
                ),
                actions: [
                  TextButton(
                    onPressed: openAPK,
                    child: const Text("Update"),
                  ),
                ],
              ),
            );
          });
        }
      }
    } catch (e) {
      debugPrint("Update check failed: $e");
    }
  }

  Future<void> openAPK() async {
    final url = (apkUrl != null && apkUrl!.startsWith("http"))
        ? apkUrl!
        : "https://yourdomain.com/skilllink.apk";

    final uri = Uri.parse(url);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("APK open failed: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open download link")),
        );
      }
    }
  }

  void shareApp() {
  final url = (apkUrl != null && apkUrl!.startsWith("http"))
      ? apkUrl!
      : "https://yourdomain.com/skilllink.apk";

  Share.share(
    "SkillLink Marketplace\n"
    "Find Jobs & Workers Easily\n"
    "Download: $url",
  );
}
ButtonStyle button3D(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      elevation: 10,
      shadowColor: color.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18),
    );
  }

  Widget featureCard(IconData icon, String title, String desc) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primary.withOpacity(0.2),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = RoleManager.getRole();
    final t = AppLocalizations.of(context)!;

    final mainUI = Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          "SkillLink",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: primary),
            onSelected: changeLanguage,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'ur', child: Text('Urdu')),
              PopupMenuItem(value: 'ar', child: Text('Arabic')),
              PopupMenuItem(value: 'nl', child: Text('Dutch')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.share, color: primary),
            onPressed: shareApp,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.work_outline, size: 70, color: primary),
              const SizedBox(height: 12),
              const Text(
                "SkillLink Marketplace",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Find Jobs • Hire Workers • Grow Faster",
                style: TextStyle(color: textMuted),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primary, Color(0xFF00C2A8)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Text(
                      "Honest work and halal earning is a form of worship.",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "SkillLink supports practical skills and trusted earning opportunities.",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text("Current Role: $role"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: searchController,
                onChanged: (v) {
                  setState(() {
                    query = v;
                  });
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: t.searchJobs,
                  prefixIcon: const Icon(Icons.search, color: primary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF673AB7), Color(0xFF00BFA5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 14,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.school_rounded, size: 42, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text(
                      "Learn, Grow & Earn",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Ready to take your next step? Explore Learn & Earn Hub for practical learning, valuable skills, and new earning opportunities.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF673AB7),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text(
                          "Visit Learn & Earn Hub",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          await launchUrl(Uri.parse("https://learn-earnhub.vercel.app/"), mode: LaunchMode.externalApplication);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: button3D(success),
                      icon: const Icon(Icons.work),
                      label: Text(t.postJob),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const JobForm(),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: button3D(primary),
                      icon: const Icon(Icons.person),
                      label: Text(t.findWork),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WorkerForm(),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: button3D(warning),
                  icon: const Icon(Icons.download),
                  label: Text(t.installApp),
                  onPressed: openAPK,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: button3D(purple),
                  icon: const Icon(Icons.share),
                  label: Text(t.shareApp),
                  onPressed: shareApp,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                t.whySkillLink,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              featureCard(
                Icons.flash_on,
                "Instant Matching",
                "Get jobs or workers in seconds",
              ),
              featureCard(
                Icons.security,
                "Trusted Network",
                "Direct client-worker communication",
              ),
              featureCard(
                Icons.location_city,
                "Local Jobs",
                "Find nearby opportunities",
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: LiveJobsTest(query: query),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: const Column(
                  children: [
                    Text(
                      "Disclaimer / Legal Notice",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "SkillLink is a digital job marketplace platform designed to connect skilled workers, freelancers, and employers in a transparent and efficient way. Users can post jobs, find local work opportunities, and directly communicate with each other.\n\n"
                      "The platform does not act as an employer, recruiter, contractor, or payment intermediary. All agreements, payments, and service responsibilities are strictly between users.\n\n"
                      "SkillLink promotes trusted local employment, freelance work, and skill-based earning opportunities. We encourage users to verify profiles, job details, and terms before engaging in any transaction.\n\n"
                      "Keywords: jobs near me, hire workers, freelancers marketplace, local job search, skill based earning, online job platform.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          color: Colors.transparent,
        ),
        mainUI,
      ],
    );
  }
}

class LiveJobsTest extends StatelessWidget {
  final String query;

  const LiveJobsTest({super.key, this.query = ""});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final docs = snapshot.data!.docs;

        final filtered = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final title = (data['title'] ?? '').toString().toLowerCase();
          final location =
              (data['location'] ?? '').toString().toLowerCase();
          final q = query.toLowerCase();

          return title.contains(q) || location.contains(q);
        }).toList();

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            final job = filtered[i];
            return ListTile(
              title: Text(job['title']),
              subtitle: Text(job['location']),
            );
          },
        );
      },
    );
  }
}
