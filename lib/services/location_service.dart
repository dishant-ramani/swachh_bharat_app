import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permissions
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permissions
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current position with permission handling
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled, prompt user to enable them
      throw Exception('Location services are disabled. Please enable them and try again.');
    }

    // Check location permissions
    permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if not granted
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        // User denied the permission, handle accordingly
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Get address from coordinates
  static Future<List<Placemark>> getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      return await placemarkFromCoordinates(latitude, longitude);
    } catch (e) {
      throw Exception('Failed to get address from coordinates: $e');
    }
  }

  // Calculate distance between two points in meters
  static double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Get formatted address string from placemarks
  static String formatAddress(Placemark placemark) {
    return '''
    ${placemark.street ?? ''}
    ${placemark.subLocality ?? ''}
    ${placemark.locality ?? ''}
    ${placemark.administrativeArea ?? ''}
    ${placemark.postalCode ?? ''}
    ${placemark.country ?? ''}
    '''.replaceAll('\n', ', ').replaceAll(RegExp(r'\s+, '), ', ').trim();
  }

  // Get current address
  static Future<String> getCurrentAddress() async {
    try {
      final position = await determinePosition();
      final placemarks = await getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return formatAddress(placemarks.first);
      } else {
        return '${position.latitude}, ${position.longitude}';
      }
    } catch (e) {
      throw Exception('Failed to get current address: $e');
    }
  }
}
