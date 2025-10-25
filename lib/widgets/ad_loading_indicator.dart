import 'package:flutter/material.dart';

class AdLoadingIndicator extends StatefulWidget {
  final String message;
  final String? subtitle;
  final double? progress;
  final bool showProgress;
  final Color? primaryColor;
  final Color? secondaryColor;

  const AdLoadingIndicator({
    super.key,
    required this.message,
    this.subtitle,
    this.progress,
    this.showProgress = false,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  State<AdLoadingIndicator> createState() => _AdLoadingIndicatorState();
}

class _AdLoadingIndicatorState extends State<AdLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _waveController;
  late AnimationController _fadeController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for the main container
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation for the ad icon
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Wave animation for the progress ring
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    // Fade animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    _waveController.repeat(reverse: true);
    _fadeController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _waveController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.colorScheme.primary;
    final secondaryColor = widget.secondaryColor ?? primaryColor.withOpacity(0.3);

    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated loading indicator
          AnimatedBuilder(
            animation: Listenable.merge([
              _pulseAnimation,
              _rotationAnimation,
              _waveAnimation,
            ]),
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer wave ring
                    if (widget.showProgress)
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: secondaryColor.withOpacity(_waveAnimation.value),
                            width: 2,
                          ),
                        ),
                      ),
                    
                    // Main container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primaryColor.withOpacity(0.3),
                            primaryColor.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: _rotationAnimation.value * 2 * 3.14159,
                          child: Icon(
                            Icons.ad_units_rounded,
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    
                    // Progress indicator overlay
                    if (widget.showProgress && widget.progress != null)
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: widget.progress,
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 24.0),
          
          // Animated text
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  children: [
                    Text(
                      widget.message,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 8.0),
                      Text(
                        widget.subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 24.0),
          
          // Loading dots animation
          _buildLoadingDots(primaryColor),
        ],
      ),
    );
  }

  Widget _buildLoadingDots(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            final delay = index * 0.2;
            final animationValue = (_waveAnimation.value + delay) % 1.0;
            final opacity = (1.0 - (animationValue - 0.5).abs() * 2).clamp(0.0, 1.0);
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
