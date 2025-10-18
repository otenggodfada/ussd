import 'package:flutter/material.dart';
import 'package:ussd_plus/screens/home_screen.dart';
import 'package:ussd_plus/utils/location_service.dart';
import 'package:ussd_plus/utils/ussd_data_service.dart';
import 'package:ussd_plus/widgets/app_logo.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  String _statusText = 'Initializing...';
  bool _isDetectingLocation = false;
  double _progress = 0.0;
  String _appVersion = '';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Get app info
      setState(() {
        _statusText = 'Initializing...';
        _progress = 0.1;
      });
      
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Step 2: Check location permission and auto-detect
      setState(() {
        _statusText = 'Detecting your location...';
        _isDetectingLocation = true;
        _progress = 0.3;
      });
      
      final autoDetectEnabled = await LocationService.isAutoDetectEnabled();
      if (autoDetectEnabled) {
        final detectedCountry = await LocationService.detectCountryFromLocation();
        
        if (detectedCountry != null) {
          setState(() {
            _statusText = 'Detected: $detectedCountry';
            _progress = 0.5;
          });
          await Future.delayed(const Duration(milliseconds: 800));
        } else {
          setState(() {
            _statusText = 'Using default country...';
            _progress = 0.5;
          });
          await Future.delayed(const Duration(milliseconds: 400));
        }
      } else {
        setState(() {
          _statusText = 'Manual country selection enabled';
          _progress = 0.5;
        });
        await Future.delayed(const Duration(milliseconds: 400));
      }
      
      // Step 3: Load USSD data
      setState(() {
        _statusText = 'Loading USSD codes...';
        _isDetectingLocation = false;
        _progress = 0.7;
      });
      
      await USSDDataService.getOfflineUSSDData();
      
      // Step 4: Complete
      setState(() {
        _statusText = 'Ready!';
        _progress = 1.0;
      });
      
      await Future.delayed(const Duration(milliseconds: 600));
      
      // Navigate to home screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _statusText = 'Error occurred';
        _isDetectingLocation = false;
        _progress = 0.0;
      });
      
      // Show error for 3 seconds then navigate
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }
  
  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _progress = 0.0;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Use app's background color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Clean app logo
              _buildCleanLogo(theme),
              
              const SizedBox(height: 40),
              
              // App name with clean typography
              _buildCleanAppName(theme),
              
              const SizedBox(height: 12),
              
              // Simple tagline
              _buildCleanTagline(theme),
              
              const SizedBox(height: 80),
              
              // Clean progress section
              _buildCleanProgressSection(theme),
              
              const SizedBox(height: 60),
              
              // App version
              _buildCleanVersionInfo(theme),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCleanLogo(ThemeData theme) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary, // Use app's primary color
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: AppLogo(size: 80, showText: false),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCleanAppName(ThemeData theme) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Text(
            'USSD+',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface, // Use app's text color
              letterSpacing: 2,
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCleanTagline(ThemeData theme) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value * 0.8,
          child: Text(
            'Your USSD Code Companion',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCleanProgressSection(ThemeData theme) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Column(
            children: [
              // Status text
              Text(
                _statusText,
                style: TextStyle(
                  fontSize: 16,
                  color: _hasError ? Colors.red[400] : theme.colorScheme.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Simple progress bar
              Container(
                width: 200,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 200 * _progress,
                  decoration: BoxDecoration(
                    color: _hasError ? Colors.red[400] : theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Progress percentage
              Text(
                '${(_progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Simple loading indicator
              if (_isDetectingLocation)
                _buildCleanLocationIndicator(theme)
              else if (_hasError)
                _buildCleanErrorIndicator(theme)
              else
                _buildCleanLoadingIndicator(theme),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildCleanLocationIndicator(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_searching_rounded,
          color: theme.colorScheme.secondary, // Use app's accent color
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Detecting location...',
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  Widget _buildCleanErrorIndicator(ThemeData theme) {
    return Column(
      children: [
        Icon(
          Icons.error_outline_rounded,
          color: Colors.red[400],
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          'Something went wrong',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red[400],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary, // Use app's primary color
            foregroundColor: theme.colorScheme.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Retry'),
        ),
      ],
    );
  }
  
  Widget _buildCleanLoadingIndicator(ThemeData theme) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }
  
  Widget _buildCleanVersionInfo(ThemeData theme) {
    if (_appVersion.isEmpty) return const SizedBox.shrink();
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value * 0.5,
          child: Text(
            'v$_appVersion',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      },
    );
  }
}
