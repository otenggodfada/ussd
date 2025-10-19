import 'package:flutter/material.dart';
import 'package:ussd_plus/theme/theme_generator.dart';
import 'package:ussd_plus/models/ussd_model.dart';

class USSDCodeCard extends StatelessWidget {
  final USSDCode code;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const USSDCodeCard({
    super.key,
    required this.code,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with code badge and favorite button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Code badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: ThemeGenerator.generateGradient(ThemeGenerator.themeNumber),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    code.code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                // Favorite Button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Remove from Favorites Button (only show if favorited)
                    if (code.isFavorite)
                      GestureDetector(
                        onTap: () {
                          onFavorite();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Remove',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    if (code.isFavorite) const SizedBox(width: 8),
                    
                    // Favorite Status Icon
                    GestureDetector(
                      onTap: () {
                        onFavorite();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: code.isFavorite 
                              ? Colors.red.withOpacity(0.15)
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: code.isFavorite 
                                ? Colors.red.withOpacity(0.3)
                                : theme.colorScheme.onSurface.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          code.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: code.isFavorite ? Colors.red : theme.colorScheme.onSurface.withOpacity(0.5),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Name and provider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.business_rounded,
                      size: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        code.provider,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
