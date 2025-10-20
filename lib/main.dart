import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_plus/theme/theme_generator.dart';
import 'package:ussd_plus/screens/splash_screen.dart';
import 'package:ussd_plus/screens/onboarding_screen.dart';
import 'package:ussd_plus/screens/no_internet_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ussd_plus/models/ussd_model.dart';
import 'package:ussd_plus/models/sms_model.dart';
import 'package:ussd_plus/utils/admob_service.dart';
import 'package:ussd_plus/utils/location_service.dart';
import 'package:ussd_plus/utils/onboarding_service.dart';
import 'package:ussd_plus/utils/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(USSDSectionAdapter());
  Hive.registerAdapter(USSDCodeAdapter());
  Hive.registerAdapter(SMSMessageAdapter());
  Hive.registerAdapter(SMSCategoryAdapter());

  // Open boxes
  await Hive.openBox('ussd_codes');
  await Hive.openBox('sms_messages');
  await Hive.openBox('app_settings');

  // Request permissions
  await _requestPermissions();

  // Initialize location service and detect country
  await _initializeLocationAndDetectCountry();

  // Initialize AdMob
  await AdMobService.initialize();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize Notifications
  await NotificationService.initialize();

  runApp(const USSDPlusApp());
}

Future<void> _requestPermissions() async {
  // Only request permissions on mobile platforms (not web)
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    // Request SMS permission for Android/iOS
    if (await Permission.sms.isDenied) {
      await Permission.sms.request();
    }

    // Request notification permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Request location permission for country detection
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }
}

Future<void> _initializeLocationAndDetectCountry() async {
  // Only run on mobile platforms (not web)
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    try {
      // Check if auto-detect is enabled (default: true)
      final autoDetectEnabled = await LocationService.isAutoDetectEnabled();

      if (autoDetectEnabled) {
        // Try to detect country from location
        final detectedCountry =
            await LocationService.detectCountryFromLocation();

        if (detectedCountry != null) {
          print('🌍 Auto-detected country: $detectedCountry');
        } else {
          print('⚠️ Could not auto-detect country, using default');
        }
      }
    } catch (e) {
      print('❌ Error during location initialization: $e');
      // Continue app initialization even if location fails
    }
  }
}

class USSDPlusApp extends StatefulWidget {
  const USSDPlusApp({super.key});

  @override
  State<USSDPlusApp> createState() => _USSDPlusAppState();
}

class _USSDPlusAppState extends State<USSDPlusApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // App open ads disabled - no ads shown on foreground
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'USSD+',
      debugShowCheckedModeBanner: false,
      theme: ThemeGenerator.generateTheme(1), // Default theme
      home: const ConnectivityGate(child: AppInitializer()),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final onboardingCompleted =
          await OnboardingService.isOnboardingCompleted();

      setState(() {
        _showOnboarding = !onboardingCompleted;
        _isLoading = false;
      });
    } catch (e) {
      // If there's an error, show onboarding as fallback
      setState(() {
        _showOnboarding = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }

    if (_showOnboarding) {
      return const OnboardingScreen();
    }

    return const SplashScreen();
  }
}

class ConnectivityGate extends StatefulWidget {
  final Widget child;
  const ConnectivityGate({super.key, required this.child});

  @override
  State<ConnectivityGate> createState() => _ConnectivityGateState();
}

class _ConnectivityGateState extends State<ConnectivityGate> {
  bool _isInitializing = true;
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final hasConnection = results.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn);

      if (mounted) {
        setState(() {
          _hasConnection = hasConnection;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasConnection = true; // Assume connected on error
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        // Handle initial state
        if (_isInitializing) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final results = snapshot.data;
        final hasConnection = results == null
            ? _hasConnection // Use cached state if no new data
            : results.any((r) =>
                r == ConnectivityResult.mobile ||
                r == ConnectivityResult.wifi ||
                r == ConnectivityResult.ethernet ||
                r == ConnectivityResult.vpn);

        // Update cached state
        if (results != null) {
          _hasConnection = hasConnection;
        }

        // Use AnimatedSwitcher for smooth transitions
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: hasConnection
              ? Container(
                  key: const ValueKey('connected'),
                  child: widget.child,
                )
              : Container(
                  key: const ValueKey('disconnected'),
                  child: const NoInternetScreen(),
                ),
        );
      },
    );
  }
}
