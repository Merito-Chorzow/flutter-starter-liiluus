// lib/screens/add_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/journal_entry.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key, required this.apiService});

  final ApiService apiService;

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final LocationService _locationService = LocationService();

  double? _latitude;
  double? _longitude;

  bool _isSaving = false;
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final Position pos = await _locationService.getCurrentPosition();
      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Pobrano lokalizację: ${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nie udało się pobrać lokalizacji: $e')),
      );
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final entry = JournalEntry(
      id: '', // MockAPI nada ID po stronie serwera
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      createdAt: DateTime.now(),
      latitude: _latitude,
      longitude: _longitude,
    );

    try {
      final created = await widget.apiService.createEntry(entry);
      if (!mounted) return;
      Navigator.pop(context, created);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nie udało się zapisać wpisu: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationText = (_latitude != null && _longitude != null)
        ? 'Lat: ${_latitude!.toStringAsFixed(4)}, Lng: ${_longitude!.toStringAsFixed(4)}'
        : 'Lokalizacja nieustawiona';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj wpis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Tytuł',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Podaj tytuł';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Opis',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Podaj opis';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: Text(locationText)),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed:
                                _isGettingLocation ? null : () => _getLocation(),
                            icon: _isGettingLocation
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.my_location),
                            label: const Text('Pobierz lokalizację'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Uwaga: jeśli odmówisz dostępu do lokalizacji, '
                        'zobaczysz komunikat o błędzie (test natywnej funkcji).',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Zapisz wpis'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
