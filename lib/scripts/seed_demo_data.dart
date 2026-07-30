/// ============================================================
/// DEMO SEED SCRIPT — lib/scripts/seed_demo_data.dart
/// ============================================================
///
/// PURPOSE:
///   Seeds a fully self-contained demo dataset in Firestore.
///   The sample_test_file.txt is already permanently uploaded to
///   Firebase Storage — no upload step needed.
///   All documents use IDs prefixed with "DEMO_" and carry an
///   `isDemo: true` marker — NO real data is ever read or modified.
///
/// HOW TO RUN:
///   flutter run -t lib/scripts/seed_demo_data.dart
///
/// HOW TO CLEAN UP (remove all demo data):
///   Set [_runCleanupInstead = true] below, then run again.
///
/// SAFETY:
///   • Storage path  →  demo_files/sample_test_file.txt (already uploaded)
///   • Firestore IDs →  DEMO_jobSeeker_Ahmad       (original demo job seeker)
///                      DEMO_project_SampleTestFile
///                      DEMO_company_Elevate        (original demo company)
///                      DEMO_employee_Ahmad
///   • NEW top-notch →  DEMO_jobSeeker_Sara         (5 badges, 4 projects, 3 work exp)
///                      DEMO_company_NexCore        (3 jobs, strengths, achievements)
///                      DEMO_badge_Sara_*           (5 badge docs)
///                      DEMO_result_Sara_*          (5 result docs)
///                      DEMO_project_Sara_*         (4 project docs)
///                      DEMO_job_NexCore_*          (3 job post docs)
/// ============================================================

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:elevate_app/firebase_options.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';

// ──────────────────────────────────────────────────────────────────────────
// ▼  SET THIS TO true TO DELETE ALL DEMO DATA INSTEAD OF SEEDING  ▼
const bool _runCleanupInstead = false;
// ──────────────────────────────────────────────────────────────────────────

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    dotenv.load(fileName: '.env'),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  runApp(const _SeedApp());
}

class _SeedApp extends StatelessWidget {
  const _SeedApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Seed Script',
      theme: ThemeData.dark(),
      home: const _SeedScreen(),
    );
  }
}

class _SeedScreen extends StatefulWidget {
  const _SeedScreen();

  @override
  State<_SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<_SeedScreen> {
  String _status = _runCleanupInstead
      ? '🗑  Ready to delete all demo data.\n\nPress the button below.'
      : '📦  Ready to seed demo data.\n\nPress the button below.';
  bool _running = false;
  bool _done = false;

  // ── Main action ──────────────────────────────────────────────────────────

  Future<void> _run() async {
    if (_running) return;
    setState(() {
      _running = true;
      _status = _runCleanupInstead
          ? '🗑  Deleting demo data…'
          : '⬆️  Starting seed…';
    });

    try {
      if (_runCleanupInstead) {
        await _cleanup();
      } else {
        await _seed();
      }
    } catch (e, st) {
      _log('❌  ERROR: $e\n\n$st');
    } finally {
      setState(() {
        _running = false;
        _done = true;
      });
    }
  }

  // ── Seed ─────────────────────────────────────────────────────────────────

  Future<void> _seed() async {
    // Upload step removed — sample_test_file.txt is permanently stored in
    // Firebase Storage at demo_files/sample_test_file.txt and the URL is
    // hardcoded in FirebaseService._demoFileDownloadUrl.

    // Seed Firestore documents (uses the hardcoded URL automatically)
    _log('🔥  Seeding original demo documents…');
    final firebaseService = FirebaseService();
    await firebaseService.seedDemoProject();
    _log('   ✔  Demo JobSeeker   → DEMO_jobSeeker_Ahmad');
    _log('   ✔  Demo Project     → DEMO_project_SampleTestFile');
    _log('   ✔  Demo Company     → DEMO_company_Elevate');
    _log('   ✔  Demo Employee    → DEMO_employee_Ahmad');

    _log('\n🚀  Seeding top-notch demo accounts…');
    await firebaseService.seedTopNotchDemo();
    _log('   ✔  JobSeeker        → DEMO_jobSeeker_Sara');
    _log('     • 5 skill results (Flutter 95%, React 92%, Python 75%, ML 97%, Cloud 82%)');
    _log('     • 5 badges        (3× Gold, 2× Silver)');
    _log('     • 4 portfolio projects');
    _log('     • 3 work experiences, 2 education entries, 1 community post');
    _log('   ✔  Company          → DEMO_company_NexCore (NexCore Technologies)');
    _log('     • 3 active job posts (Flutter / ML / Cloud)');
    _log('     • 2 employees, strengths, achievements, 1240 followers');

    _log('\n✅  SEED COMPLETE!\n'
        'Top-notch profiles are live in Firebase.\n'
        'Sara Khan  →  jobSeekers/DEMO_jobSeeker_Sara\n'
        'NexCore    →  companies/DEMO_company_NexCore\n'
        'Original Ahmad demo also seeded (DEMO_jobSeeker_Ahmad).');
  }

  // ── Cleanup ──────────────────────────────────────────────────────────────

  Future<void> _cleanup() async {
    // Delete demo Firestore documents only.
    // Note: demo_files/sample_test_file.txt is kept in Firebase Storage
    // permanently so the download URL remains valid.
    _log('🗑  Deleting Firestore demo documents…');
    final firebaseService = FirebaseService();
    await firebaseService.deleteDemoData();
    _log('   ✔  Deleted all DEMO_ Firestore documents.');

    _log('\n✅  CLEANUP COMPLETE. All demo Firestore data removed.\n'
        '   (Storage file kept so download URL stays valid.\n'
        '    Original Ahmad + NexCore/Sara data all deleted.)');
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _log(String msg) {
    print(msg);
    setState(() => _status = '$_status\n$msg');
  }

  // ── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final actionLabel = _runCleanupInstead
        ? '🗑  Delete all demo data'
        : '🚀  Run seed';

    return Scaffold(
      appBar: AppBar(
        title: Text(_runCleanupInstead
            ? 'Demo Cleanup Script'
            : 'Demo Seed Script'),
        backgroundColor: _runCleanupInstead
            ? Colors.red.shade900
            : const Color(0xFF1A1A2E),
      ),
      backgroundColor: const Color(0xFF12121F),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status log box
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _done
                        ? Colors.greenAccent.withValues(alpha: 0.5)
                        : Colors.white12,
                  ),
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  child: SelectableText(
                    _status,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action button
            if (!_done)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _running ? null : _run,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _runCleanupInstead
                        ? Colors.red.shade700
                        : const Color(0xFF6C63FF),
                    disabledBackgroundColor: Colors.white12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _running
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          actionLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            else
              Column(
                children: [
                  Text(
                    _runCleanupInstead
                        ? '🎉 Cleanup complete!'
                        : '🎉 Seed complete!',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _runCleanupInstead
                        ? 'All demo data has been removed from Firebase.'
                        : 'Demo data is live in Firebase.\nYou can now run the main app.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
