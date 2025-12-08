// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/api_service.dart';
import 'add_entry_screen.dart';
import 'entry_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<JournalEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final entries = await _apiService.fetchEntries();
      setState(() {
        _entries = entries;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openAddEntry() async {
    final newEntry = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEntryScreen(apiService: _apiService),
      ),
    );

    if (newEntry != null) {
      setState(() {
        _entries.add(newEntry);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wpis został dodany')),
      );
    }
  }

  void _openDetail(JournalEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryDetailScreen(entry: entry),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Wystąpił błąd:\n$_error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadEntries,
                child: const Text('Spróbuj ponownie'),
              ),
            ],
          ),
        ),
      );
    }

    if (_entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, size: 60),
              const SizedBox(height: 12),
              const Text(
                'Brak wpisów.\nDodaj pierwszy, aby rozpocząć swój Geo Journal!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _openAddEntry,
                child: const Text('Dodaj pierwszy wpis'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadEntries,
      child: ListView.builder(
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return ListTile(
            leading: const Icon(Icons.place),
            title: Text(entry.title),
            subtitle: Text(
              '${entry.locationLabel}\n${entry.createdAt.toLocal()}',
              maxLines: 2,
            ),
            isThreeLine: true,
            onTap: () => _openDetail(entry),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}
