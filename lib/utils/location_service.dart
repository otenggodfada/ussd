import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String _autoDetectKey = 'auto_detect_country';
  static const String _detectedCountryKey = 'detected_country';
  
  /// Check if auto-detection is enabled
  static Future<bool> isAutoDetectEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoDetectKey) ?? true; // Default to enabled
  }
  
  /// Enable or disable auto-detection
  static Future<void> setAutoDetect(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoDetectKey, enabled);
  }
  
  /// Get last detected country from cache
  static Future<String?> getDetectedCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_detectedCountryKey);
  }
  
  /// Save detected country to cache
  static Future<void> saveDetectedCountry(String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_detectedCountryKey, country);
  }
  
  /// Check if location permission is granted
  static Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || 
           permission == LocationPermission.whileInUse;
  }
  
  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return permission == LocationPermission.always || 
           permission == LocationPermission.whileInUse;
  }
  
  /// Detect user's country based on GPS location
  static Future<String?> detectCountryFromLocation() async {
    try {
      // Check if auto-detect is enabled
      final autoDetect = await isAutoDetectEnabled();
      if (!autoDetect) {
        return null;
      }
      
      // Check location permission
      final hasPermission = await hasLocationPermission();
      if (!hasPermission) {
        final granted = await requestLocationPermission();
        if (!granted) {
          print('Location permission denied');
          return null;
        }
      }
      
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        return null;
      }
      
      // Get current position with timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low, // Low accuracy is fine for country detection
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Location timeout'),
      );
      
      // Get placemarks from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isEmpty) {
        print('No placemarks found');
        return null;
      }
      
      final placemark = placemarks.first;
      final countryCode = placemark.isoCountryCode;
      final countryName = placemark.country;
      
      print('Detected country: $countryName ($countryCode)');
      print('Full placemark: ${placemark.toString()}');
      
      // Map country code to our supported countries
      final detectedCountry = _mapCountryCodeToSupportedCountry(countryCode, countryName);
      
      if (detectedCountry != null) {
        await saveDetectedCountry(detectedCountry);
      }
      
      return detectedCountry;
    } catch (e) {
      print('Error detecting country: $e');
      return null;
    }
  }
  
  /// Map ISO country code to supported countries
  static String? _mapCountryCodeToSupportedCountry(String? countryCode, String? countryName) {
    if (countryCode == null && countryName == null) return null;
    
    // Try mapping by country code first
    if (countryCode != null) {
      switch (countryCode.toUpperCase()) {
        case 'GH':
          return 'Ghana';
        case 'NG':
          return 'Nigeria';
        case 'KE':
          return 'Kenya';
        case 'TZ':
          return 'Tanzania';
        case 'UG':
          return 'Uganda';
        case 'ZA':
          return 'South Africa';
        case 'RW':
          return 'Rwanda';
        case 'IN':
          return 'India';
        case 'US':
          return 'USA';
      }
    }
    
    // Try mapping by country name as fallback
    if (countryName != null) {
      final name = countryName.toLowerCase();
      if (name.contains('ghana')) return 'Ghana';
      if (name.contains('nigeria')) return 'Nigeria';
      if (name.contains('kenya')) return 'Kenya';
      if (name.contains('tanzania')) return 'Tanzania';
      if (name.contains('uganda')) return 'Uganda';
      if (name.contains('south africa')) return 'South Africa';
      if (name.contains('rwanda')) return 'Rwanda';
      if (name.contains('india')) return 'India';
      if (name.contains('united states') || name.contains('america')) return 'USA';
    }
    
    return null; // Country not supported
  }
  
  /// Get country with auto-detection fallback
  static Future<String> getCountryWithAutoDetect(String defaultCountry) async {
    // Check if auto-detect is enabled
    final autoDetect = await isAutoDetectEnabled();
    if (!autoDetect) {
      return defaultCountry;
    }
    
    // Try to get cached detected country first
    final cachedCountry = await getDetectedCountry();
    if (cachedCountry != null) {
      return cachedCountry;
    }
    
    // Try to detect country from location
    final detectedCountry = await detectCountryFromLocation();
    if (detectedCountry != null) {
      return detectedCountry;
    }
    
    // Fall back to default
    return defaultCountry;
  }
  
  /// Get list of supported country codes
  static List<String> getSupportedCountryCodes() {
    return ['GH', 'NG', 'KE', 'TZ', 'UG', 'ZA', 'RW', 'IN', 'US'];
  }
  
  /// Get list of supported countries
  static List<String> getSupportedCountries() {
    return [
      'Ghana',
      'Nigeria',
      'Kenya',
      'Tanzania',
      'Uganda',
      'South Africa',
      'Rwanda',
      'India',
      'USA'
    ];
  }
}

