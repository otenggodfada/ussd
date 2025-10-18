import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_plus/theme/theme_generator.dart';
import 'package:ussd_plus/screens/home_screen.dart';
import 'package:ussd_plus/models/ussd_model.dart';
import 'package:ussd_plus/models/sms_model.dart';
import 'package:ussd_plus/utils/admob_service.dart';
import 'package:ussd_plus/utils/revenuecat_service.dart';

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
  
  // Initialize AdMob and RevenueCat
  await AdMobService.initialize();
  await RevenueCatService.initialize();
  
  runApp(const USSDPlusApp());
}

Future<void> _requestPermissions() async {
  // Only request permissions on mobile platforms
  if (Platform.isAndroid || Platform.isIOS) {
    // Request SMS permission for Android/iOS
    if (await Permission.sms.isDenied) {
      await Permission.sms.request();
    }
    
    // Request notification permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
}

class USSDPlusApp extends StatelessWidget {
  const USSDPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'USSD+',
      debugShowCheckedModeBanner: false,
      theme: ThemeGenerator.generateTheme(1), // Default theme
      home: const HomeScreen(),
    );
  }
}
