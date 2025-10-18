import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ussd_plus/models/ussd_model.dart';
import 'package:ussd_plus/utils/ussd_data_service.dart';
import 'package:ussd_plus/utils/activity_service.dart';
import 'package:ussd_plus/models/activity_model.dart';
import 'package:ussd_plus/theme/theme_generator.dart';
class QuickDialCard extends StatefulWidget {
  const QuickDialCard({super.key});

  @override
  State<QuickDialCard> createState() => _QuickDialCardState();
}

class _QuickDialCardState extends State<QuickDialCard> {
  List<USSDCode> _favorites = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  bool _autoScrolling = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    
    final sections = await USSDDataService.getOfflineUSSDData();
    final favorites = await USSDDataService.getFavoriteCodes(sections);
    
    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });

    // Start auto-scroll if we have favorites
    if (_favorites.isNotEmpty && mounted) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted || _favorites.isEmpty) return;
    
    _autoScrolling = true;
    
    while (_autoScrolling && mounted) {
      await Future.delayed(const Duration(seconds: 3));
      
      if (!mounted || !_autoScrolling) break;
      
      // Calculate next scroll position
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      
      if (currentScroll >= maxScroll - 10) {
        // Reached end, scroll back to start
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        // Scroll forward by 250 pixels or to end
        final nextPosition = (currentScroll + 250).clamp(0.0, maxScroll);
        _scrollController.animateTo(
          nextPosition,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _stopAutoScroll() {
    _autoScrolling = false;
  }

  Future<void> _dialCode(USSDCode code) async {
    try {
      // Make the direct call
      bool? result = await FlutterPhoneDirectCaller.callNumber(code.code);
      
      // Log activity
      await ActivityService.logActivity(
        type: ActivityType.ussdCodeCopied,
        title: 'Quick dialed ${code.name}',
        description: code.code,
        metadata: {'code': code.code, 'provider': code.provider},
      );
      
      if (!mounted) return;
      
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dialing ${code.code}...'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to dial ${code.code}'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Unable to make call'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_favorites.isEmpty) {
      return const SizedBox.shrink(); // Don't show if no favorites
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: ThemeGenerator.generateGradient(ThemeGenerator.themeNumber),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Dial',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${_favorites.length} favorite${_favorites.length == 1 ? '' : 's'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tap to dial',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Horizontal scrolling list with shadow overlays
        SizedBox(
          height: 120,
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    _stopAutoScroll();
                  } else if (notification is ScrollEndNotification) {
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) _startAutoScroll();
                    });
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final code = _favorites[index];
                    return _buildQuickDialItem(code, theme);
                  },
                ),
              ),
              
              // Left shadow overlay
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFF1A1A1A),
                          const Color(0xFF1A1A1A).withOpacity(0.5),
                          const Color(0xFF1A1A1A).withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Right shadow overlay
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          const Color(0xFF1A1A1A),
                          const Color(0xFF1A1A1A).withOpacity(0.8),
                          const Color(0xFF1A1A1A).withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickDialItem(USSDCode code, ThemeData theme) {
    return GestureDetector(
      onTap: () => _dialCode(code),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
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
            
            // Name and provider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.business_rounded,
                      size: 10,
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

