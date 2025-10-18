import 'package:flutter/material.dart';
import 'package:ussd_plus/models/onboarding_model.dart';
import 'package:ussd_plus/screens/home_screen.dart';
import 'package:ussd_plus/utils/onboarding_service.dart';
import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late AnimationController _floatingController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatingAnimation;
  
  int _currentPage = 0;
  final List<OnboardingPage> _pages = OnboardingData.getPages();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);
    
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_floatingController);
    
    _animationController.forward();
    _backgroundController.repeat();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _backgroundController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await OnboardingService.completeOnboarding();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.background,
              theme.colorScheme.background.withOpacity(0.95),
              theme.colorScheme.surface.withOpacity(0.8),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            _buildAnimatedBackground(theme),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Premium header with skip button
                  _buildPremiumHeader(theme),
                  
                  // Page content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                        _animationController.reset();
                        _animationController.forward();
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return _buildPremiumPage(_pages[index], theme);
                      },
                    ),
                  ),
                  
                  // Premium bottom section
                  _buildPremiumBottomSection(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(ThemeData theme) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return CustomPaint(
          painter: PremiumBackgroundPainter(
            _backgroundAnimation.value,
            _floatingAnimation.value,
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildPremiumHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button with premium styling
          if (_currentPage > 0)
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _previousPage,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 80),
          
          // Skip button with premium styling
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _skipOnboarding,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPage(OnboardingPage page, ThemeData theme) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Premium icon section
                Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: _buildPremiumIcon(page, theme),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Premium content
                Transform.translate(
                  offset: Offset(0, _slideAnimation.value * 0.5),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          // Title with premium typography
                          Text(
                            page.title,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Description with premium styling
                          Text(
                            page.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                              height: 1.6,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Premium features list
                          if (page.features.isNotEmpty)
                            _buildPremiumFeatures(page.features, theme),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumIcon(OnboardingPage page, ThemeData theme) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(90),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(0.2),
            blurRadius: 45,
            spreadRadius: 0,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated background pattern
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return CustomPaint(
                painter: IconBackgroundPainter(
                  _floatingAnimation.value,
                  theme.colorScheme.onPrimary.withOpacity(0.1),
                ),
                size: const Size(180, 180),
              );
            },
          ),
          
          // Main icon
          Center(
            child: Text(
              page.iconData,
              style: const TextStyle(fontSize: 80),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeatures(List<String> features, ThemeData theme) {
    return Column(
      children: features.map((feature) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.check_rounded,
                color: theme.colorScheme.onPrimary,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                feature,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildPremiumBottomSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
      child: Column(
        children: [
          // Premium page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                width: _currentPage == index ? 32.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  gradient: _currentPage == index
                      ? LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        )
                      : null,
                  color: _currentPage == index
                      ? null
                      : theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: _currentPage == index
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Premium navigation button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _nextPage,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _currentPage == _pages.length - 1 
                            ? Icons.rocket_launch_rounded
                            : Icons.arrow_forward_ios_rounded,
                        color: theme.colorScheme.onPrimary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painters for premium effects
class PremiumBackgroundPainter extends CustomPainter {
  final double animationValue;
  final double floatingValue;
  final Color primaryColor;
  final Color secondaryColor;

  PremiumBackgroundPainter(
    this.animationValue,
    this.floatingValue,
    this.primaryColor,
    this.secondaryColor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;

    // Animated floating orbs
    for (int i = 0; i < 15; i++) {
      final x = (i * 73.0 + animationValue * 100) % size.width;
      final y = (i * 47.0 + floatingValue * 50) % size.height;
      final radius = 3.0 + (i % 4) * 2.0;
      final opacity = (0.05 + (i % 3) * 0.03) * (0.5 + 0.5 * math.sin(animationValue * 2 * math.pi + i));
      
      paint.color = (i % 2 == 0 ? primaryColor : secondaryColor).withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Geometric patterns
    for (int i = 0; i < 8; i++) {
      final x = (i * 89.0 + animationValue * 30) % size.width;
      final y = (i * 67.0 + floatingValue * 40) % size.height;
      final shapeSize = 12.0 + (i % 3) * 6.0;
      final opacity = 0.03 + (i % 2) * 0.02;
      
      paint.color = primaryColor.withOpacity(opacity);
      
      if (i % 3 == 0) {
        // Draw circles
        canvas.drawCircle(Offset(x, y), shapeSize, paint);
      } else if (i % 3 == 1) {
        // Draw rounded rectangles
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(x, y), width: shapeSize, height: shapeSize),
            const Radius.circular(4),
          ),
          paint,
        );
      } else {
        // Draw diamonds
        final path = Path();
        path.moveTo(x, y - shapeSize);
        path.lineTo(x + shapeSize, y);
        path.lineTo(x, y + shapeSize);
        path.lineTo(x - shapeSize, y);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class IconBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  IconBackgroundPainter(this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Animated concentric circles
    for (int i = 0; i < 5; i++) {
      final circleRadius = (radius * 0.2 * (i + 1)) * (0.8 + 0.4 * math.sin(animationValue * 2 * math.pi + i));
      final opacity = (0.1 - i * 0.02) * (0.5 + 0.5 * math.sin(animationValue * 3 * math.pi + i));
      
      paint.color = color.withOpacity(opacity);
      canvas.drawCircle(center, circleRadius, paint);
    }

    // Animated dots around the circle
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30.0) * (math.pi / 180) + animationValue * 2 * math.pi;
      final dotRadius = 2.0 + math.sin(animationValue * 4 * math.pi + i) * 1.0;
      final dotX = center.dx + math.cos(angle) * (radius * 0.7);
      final dotY = center.dy + math.sin(angle) * (radius * 0.7);
      
      paint.color = color.withOpacity(0.3 + 0.2 * math.sin(animationValue * 2 * math.pi + i));
      canvas.drawCircle(Offset(dotX, dotY), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
