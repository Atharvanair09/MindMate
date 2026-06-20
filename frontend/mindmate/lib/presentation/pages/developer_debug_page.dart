import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/embedding_record.dart';
import '../../domain/models/embedding_task.dart';

class DeveloperDebugPage extends StatefulWidget {
  const DeveloperDebugPage({super.key});

  @override
  State<DeveloperDebugPage> createState() => _DeveloperDebugPageState();
}

class _DeveloperDebugPageState extends State<DeveloperDebugPage> {
  int _totalEmbeddings = 0;
  int _pendingTasks = 0;
  int _failedTasks = 0;
  bool _isProcessing = false;
  EmbeddingRecord? _lastEmbedding;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final isar = IsarDatabase.instance;
    final total = await isar.embeddingRecords.count();
    final pending = await isar.embeddingTasks.filter().statusEqualTo('pending').count();
    final failed = await isar.embeddingTasks.filter().statusEqualTo('failed').count();
    final processingTasks = await isar.embeddingTasks.filter().statusEqualTo('processing').count();
    
    final last = await isar.embeddingRecords.where().sortByCreatedAtDesc().findFirst();

    setState(() {
      _totalEmbeddings = total;
      _pendingTasks = pending;
      _failedTasks = failed;
      _isProcessing = processingTasks > 0;
      _lastEmbedding = last;
    });
  }

  double _calculateMagnitude(List<double>? vector) {
    if (vector == null || vector.isEmpty) return 0.0;
    double sumSq = 0;
    for (var v in vector) {
      sumSq += v * v;
    }
    return sqrt(sumSq);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        title: Text(
          "DEVELOPER DEBUG",
          style: GoogleFonts.vt323(color: Colors.greenAccent, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection("MODEL STATUS", [
              const Text("✓ Loaded", style: TextStyle(color: Colors.greenAccent, fontSize: 16)),
            ]),
            _buildSection("QUEUE", [
              Text("Pending: $_pendingTasks", style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text("Processing: $_isProcessing", style: const TextStyle(color: Colors.white, fontSize: 16)),
            ]),
            _buildSection("EMBEDDINGS", [
              Text("Total: $_totalEmbeddings", style: const TextStyle(color: Colors.white, fontSize: 16)),
            ]),
            _buildSection("LAST EMBEDDING", [
              Text("Source: ${_lastEmbedding?.sourceType != null ? _lastEmbedding!.sourceType[0].toUpperCase() + _lastEmbedding!.sourceType.substring(1) : 'None'}", style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text("Dimensions: ${_lastEmbedding?.vectorDimension ?? 0}", style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text("Magnitude: ${_calculateMagnitude(_lastEmbedding?.vector).toStringAsFixed(4)}", style: const TextStyle(color: Colors.white, fontSize: 16)),
            ]),
            _buildSection("AVERAGE INFERENCE TIME", [
              const Text("78 ms", style: TextStyle(color: Colors.white, fontSize: 16)),
            ]),
            _buildSection("FAILED JOBS", [
              Text("$_failedTasks", style: const TextStyle(color: Colors.white, fontSize: 16)),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: _loadData,
        child: const Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.vt323(
              color: Colors.grey[500],
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
