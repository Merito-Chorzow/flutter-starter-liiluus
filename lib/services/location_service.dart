// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Usługi lokalizacji są wyłączone');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Odmówiono dostępu do lokalizacji');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Dostęp do lokalizacji został trwale zablokowany. Zmień to w ustawieniach systemu.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
