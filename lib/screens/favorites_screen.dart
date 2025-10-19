import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ussd_plus/utils/ussd_data_service.dart';
import 'package:ussd_plus/utils/activity_service.dart';
import 'package:ussd_plus/models/ussd_model.dart';
import 'package:ussd_plus/models/activity_model.dart';
import 'package:ussd_plus/widgets/ussd_code_card.dart';
import 'package:ussd_plus/utils/admob_service.dart';
import 'package:ussd_plus/widgets/rewarded_ad_consent_dialog.dart';
import 'package:ussd_plus/widgets/loading_dialog.dart';
import 'package:ussd_plus/utils/coin_service.dart';
import 'package:ussd_plus/utils/premium_features_service.dart';
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with AutomaticKeepAliveClientMixin {
  List<USSDCode> _favoriteCodes = [];
  bool _isLoading = true;
  bool _showUSSD = true;
  bool _isPremiumActive = false;

  @override
  bool get wantKeepAlive => false; // Don't keep state alive, refresh each time

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final isActive = await PremiumFeaturesService.isFeatureActive(PremiumFeature.removeFavoritesWeek);
    setState(() {
      _isPremiumActive = isActive;
    });
  }

  @override
  void didUpdateWidget(FavoritesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload favorites when the widget updates
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    // Clear cache to get fresh data
    USSDDataService.clearCache();
    final sections = await USSDDataService.getOfflineUSSDData();
    final favorites = await USSDDataService.getFavoriteCodes(sections);

    setState(() {
      _favoriteCodes = favorites;
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite(USSDCode code) async {
    // If removing from favorites and user doesn't have premium, show ad
    if (code.isFavorite && !_isPremiumActive) {
      await _removeFromFavoritesWithAd(code);
      return;
    }
    
    // Normal toggle for adding to favorites or if user has premium
    final updatedCode = await USSDDataService.toggleFavorite(code);
    
    if (!mounted) return;
    
    setState(() {
      if (updatedCode.isFavorite) {
        // Add to favorites
        _favoriteCodes.add(updatedCode);
      } else {
        // Remove from favorites
        _favoriteCodes.removeWhere((c) => c.id == code.id);
      }
    });

    USSDDataService.clearCache();

    ActivityService.logActivity(
      type: ActivityType.ussdCodeFavorited,
      title: updatedCode.isFavorite ? 'Added to favorites' : 'Removed from favorites',
      description: '${updatedCode.name} - ${updatedCode.provider}',
      metadata: {'code': updatedCode.code, 'provider': updatedCode.provider},
    );

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${updatedCode.name} ${updatedCode.isFavorite ? 'added to' : 'removed from'} favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _removeFromFavoritesWithAd(USSDCode code) async {
    // Show consent dialog for watching ads to remove from favorites
    final consent = await RewardedAdConsentDialog.show(
      context: context,
      title: 'Remove from Favorites',
      description: 'Watch a short advertisement to remove this code from your favorites.',
    );

    if (consent == true) {
      // User chose "Watch Ad"
      if (AdMobService.isRewardedAdReady) {
        // Ad is ready, show it
        AdMobService.showRewardedAd(
          onRewarded: (reward) async {
            // Remove from favorites after watching ad
            final updatedCode = await USSDDataService.toggleFavorite(code);
            
            if (mounted) {
              setState(() {
                _favoriteCodes.removeWhere((c) => c.id == code.id);
              });
              
              USSDDataService.clearCache();
              
              ActivityService.logActivity(
                type: ActivityType.ussdCodeFavorited,
                title: 'Removed from favorites (after ad)',
                description: '${updatedCode.name} - ${updatedCode.provider}',
                metadata: {'code': updatedCode.code, 'provider': updatedCode.provider},
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${updatedCode.name} removed from favorites'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        );
      } else {
        // No ad ready, show loading animation and actively load ads
        if (mounted) {
          LoadingDialog.show(context, 'Preparing...');
        }
        
        // Start loading rewarded ads
        AdMobService.loadRewardedAd();
        
        // Wait for up to 10 seconds for ads to load
        bool adLoaded = false;
        for (int i = 0; i < 10; i++) {
          await Future.delayed(const Duration(seconds: 1));
          if (AdMobService.isRewardedAdReady) {
            adLoaded = true;
            break;
          }
        }
        
        // Hide loading dialog
        if (mounted) {
          LoadingDialog.hide(context);
        }
        
        if (adLoaded && mounted) {
          // Ad loaded within 10 seconds, show it
          AdMobService.showRewardedAd(
            onRewarded: (reward) async {
              // Remove from favorites after watching ad
              final updatedCode = await USSDDataService.toggleFavorite(code);
              
              if (mounted) {
                setState(() {
                  _favoriteCodes.removeWhere((c) => c.id == code.id);
                });
                
                USSDDataService.clearCache();
                
                ActivityService.logActivity(
                  type: ActivityType.ussdCodeFavorited,
                  title: 'Removed from favorites (after ad)',
                  description: '${updatedCode.name} - ${updatedCode.provider}',
                  metadata: {'code': updatedCode.code, 'provider': updatedCode.provider},
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${updatedCode.name} removed from favorites'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          );
        } else {
          // No ad loaded within 10 seconds, show message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ad not ready. Please try again later.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } else if (consent == false) {
      // User chose "No", don't remove from favorites
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removal cancelled'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.grey,
          ),
        );
      }
    }
    // If consent is null (dialog dismissed), do nothing
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        elevation: 0,
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadFavorites,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Tabs for USSD and SMS
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TabButton(
                          label: 'USSD Codes',
                          icon: Icons.phone_rounded,
                          isActive: _showUSSD,
                          onTap: () {
                            setState(() {
                              _showUSSD = true;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: _TabButton(
                          label: 'SMS',
                          icon: Icons.sms_rounded,
                          isActive: !_showUSSD,
                          onTap: () {
                            setState(() {
                              _showUSSD = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: _favoriteCodes.isEmpty
                      ? _buildEmptyState(theme)
                      : _buildFavoritesList(),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.2),
                  theme.colorScheme.primary.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_rounded,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Favorites Yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Add USSD codes and SMS to your favorites for quick access',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Browse USSD Codes'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      itemCount: _favoriteCodes.length,
      itemBuilder: (context, index) {
        final code = _favoriteCodes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: USSDCodeCard(
            code: code,
            onTap: () => _showCodeDetails(code),
            onFavorite: () => _toggleFavorite(code),
          ),
        );
      },
    );
  }

  void _showCodeDetails(USSDCode code) {
    ActivityService.logActivity(
      type: ActivityType.ussdCodeViewed,
      title: 'Viewed ${code.name}',
      description: '${code.provider} - ${code.code}',
      metadata: {'code': code.code, 'provider': code.provider},
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(code.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code: ${code.code}'),
            const SizedBox(height: 8.0),
            Text('Provider: ${code.provider}'),
            const SizedBox(height: 8.0),
            Text('Description: ${code.description}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Show consent dialog before showing rewarded ad
              final consent = await RewardedAdConsentDialog.show(
                context: context,
                title: 'Dial ${code.name}',
                description: 'Watch a short advertisement to dial this USSD code and support the app.',
              );

              if (consent == true) {
                // User chose "Watch Ad"
                if (AdMobService.isRewardedAdReady) {
                  // Ad is ready, show it
                  AdMobService.showRewardedAd(
                    onRewarded: (reward) async {
                      // Reward coins for watching ad
                      final newBalance = await CoinService.rewardForRewardedAd();
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Earned 10 coins! New balance: $newBalance coins'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                      
                      _performDial(code);
                    },
                  );
                } else {
                  // No ad ready, show loading animation and actively load ads
                  if (context.mounted) {
                    LoadingDialog.show(context, 'Preparing...');
                  }
                  
                  // Start loading rewarded ads
                  AdMobService.loadRewardedAd();
                  
                  // Wait for up to 10 seconds for ads to load
                  bool adLoaded = false;
                  for (int i = 0; i < 10; i++) {
                    await Future.delayed(const Duration(seconds: 1));
                    if (AdMobService.isRewardedAdReady) {
                      adLoaded = true;
                      break;
                    }
                  }
                  
                  // Hide loading dialog
                  if (context.mounted) {
                    LoadingDialog.hide(context);
                  }
                  
                  if (adLoaded && context.mounted) {
                    // Ad loaded within 10 seconds, show it
                    AdMobService.showRewardedAd(
                      onRewarded: (reward) async {
                        // Reward coins for watching ad
                        final newBalance = await CoinService.rewardForRewardedAd();
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Earned 10 coins! New balance: $newBalance coins'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                        
                        _performDial(code);
                      },
                    );
                  } else {
                    // No ad loaded within 10 seconds, dial anyway
                    _performDial(code);
                  }
                }
              } else if (consent == false) {
                // User chose "No", don't dial the code
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dialing cancelled'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
              }
              // If consent is null (dialog dismissed), do nothing
            },
            child: const Text('Dial Code'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDial(USSDCode code) async {
    try {
      // Make the direct call
      bool? result = await FlutterPhoneDirectCaller.callNumber(code.code);
      
      // Log copy/dial activity
      await ActivityService.logActivity(
        type: ActivityType.ussdCodeCopied,
        title: 'Dialed ${code.name}',
        description: code.code,
      );
      
      if (!context.mounted) return;
      
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
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Unable to make call'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.8),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? Colors.white
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

