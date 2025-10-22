import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = 60,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.25),
            child: Image.asset(
              'assets/icons/logo.jpg',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to original design if image fails to load
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6366F1), // Indigo
                        Color(0xFF8B5CF6), // Purple
                      ],
                    ),
                    borderRadius: BorderRadius.circular(size * 0.25),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dialpad_rounded,
                          color: Colors.white,
                          size: size * 0.35,
                        ),
                        SizedBox(height: size * 0.02),
                        Text(
                          '*#',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size * 0.22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.2),
          Text(
            'USSD+',
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'Mobile Code Manager',
            style: TextStyle(
              fontSize: size * 0.15,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}

