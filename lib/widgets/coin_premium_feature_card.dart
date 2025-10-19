import 'package:flutter/material.dart';
import 'package:ussd_plus/utils/coin_service.dart';
import 'package:ussd_plus/utils/premium_features_service.dart';
import 'package:ussd_plus/widgets/rewarded_ad_consent_dialog.dart';
import 'package:ussd_plus/utils/admob_service.dart';

class CoinPremiumFeatureCard extends StatefulWidget {
  final PremiumFeature feature;
  final VoidCallback? onFeatureActivated;

  const CoinPremiumFeatureCard({
    super.key,
    required this.feature,
    this.onFeatureActivated,
  });

  @override
  State<CoinPremiumFeatureCard> createState() => _CoinPremiumFeatureCardState();
}

class _CoinPremiumFeatureCardState extends State<CoinPremiumFeatureCard> {
  bool _isLoading = false;
  bool _isActive = false;
  String _remainingTime = '';

  @override
  void initState() {
    super.initState();
    _checkFeatureStatus();
  }

  Future<void> _checkFeatureStatus() async {
    final isActive = await PremiumFeaturesService.isFeatureActive(widget.feature);
    final remainingTime = await PremiumFeaturesService.getFeatureRemainingTimeString(widget.feature);
    
    if (mounted) {
      setState(() {
        _isActive = isActive;
        _remainingTime = remainingTime;
      });
    }
  }

  Future<void> _activateFeature() async {
    final featureInfo = PremiumFeaturesService.getFeatureInfo()[widget.feature]!;
    
    setState(() => _isLoading = true);

    // Show consent dialog for watching ads to earn coins
    final consent = await RewardedAdConsentDialog.show(
      context: context,
      title: 'Earn Coins',
      description: 'Watch a short advertisement to earn coins and unlock ${featureInfo['name']}.',
    );

    if (consent == true) {
      // Show rewarded ad
      if (AdMobService.isRewardedAdReady) {
        AdMobService.showRewardedAd(
          onRewarded: (reward) async {
            await _processReward();
          },
        );
      } else {
        // No ad ready, show message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ad not ready. Please try again later.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processReward() async {
    try {
      // Award coins for watching ad
      final newBalance = await CoinService.rewardForRewardedAd();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Earned 10 coins! New balance: $newBalance coins'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      // Get feature cost
      int cost = 0;
      switch (widget.feature) {
        case PremiumFeature.removeAdsWeek:
          cost = CoinService.removeAdsWeekCost;
          break;
        case PremiumFeature.removeAdsMonth:
          cost = CoinService.removeAdsMonthCost;
          break;
        case PremiumFeature.showAllSMSWeek:
          cost = CoinService.showAllSMSWeekCost;
          break;
        case PremiumFeature.removeFavoritesWeek:
          cost = CoinService.removeFavoritesWeekCost;
          break;
        case PremiumFeature.showAllCodesWeek:
          cost = CoinService.showAllCodesWeekCost;
          break;
      }

      if (mounted) {
        // Check if user has enough coins
        if (newBalance >= cost) {
          // Ask user if they want to spend coins to activate feature
          final shouldActivate = await _showActivationDialog(cost, newBalance);
          
          if (shouldActivate == true) {
            // Spend coins and activate feature
            final success = await CoinService.spendCoins(cost, widget.feature.name);
            
            if (success) {
              final featureInfo = PremiumFeaturesService.getFeatureInfo()[widget.feature]!;
              final duration = featureInfo['duration'] as Duration;
              
              await PremiumFeaturesService.activateFeature(widget.feature, duration);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${featureInfo['name']} activated!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
              
              await _checkFeatureStatus();
              widget.onFeatureActivated?.call();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to activate feature. Please try again.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Not enough coins! You need $cost coins. Current: $newBalance coins. Watch more ads to earn coins!'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool?> _showActivationDialog(int cost, int currentBalance) async {
    final featureInfo = PremiumFeaturesService.getFeatureInfo()[widget.feature]!;
    
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Activate ${featureInfo['name']}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This will cost $cost coins.'),
            const SizedBox(height: 8.0),
            Text('Your current balance: $currentBalance coins'),
            const SizedBox(height: 8.0),
            Text('Remaining after purchase: ${currentBalance - cost} coins'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final featureInfo = PremiumFeaturesService.getFeatureInfo()[widget.feature]!;
    
    // Get feature cost
    int cost = 0;
    switch (widget.feature) {
      case PremiumFeature.removeAdsWeek:
        cost = CoinService.removeAdsWeekCost;
        break;
      case PremiumFeature.removeAdsMonth:
        cost = CoinService.removeAdsMonthCost;
        break;
      case PremiumFeature.showAllSMSWeek:
        cost = CoinService.showAllSMSWeekCost;
        break;
      case PremiumFeature.removeFavoritesWeek:
        cost = CoinService.removeFavoritesWeekCost;
        break;
      case PremiumFeature.showAllCodesWeek:
        cost = CoinService.showAllCodesWeekCost;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: _isActive 
            ? LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.2),
                  Colors.green.withOpacity(0.1),
                ],
              )
            : LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.2),
                  theme.colorScheme.primary.withOpacity(0.1),
                ],
              ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: _isActive 
              ? Colors.green.withOpacity(0.5)
              : theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: _isActive || _isLoading ? null : _activateFeature,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: _isActive 
                            ? Colors.green.withOpacity(0.2)
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        featureInfo['icon'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            featureInfo['name'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: _isActive ? Colors.green : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            featureInfo['description'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: (_isActive ? Colors.green : Colors.white).withOpacity(0.8),
                            ),
                          ),
                          if (_isActive) ...[
                            const SizedBox(height: 4.0),
                            Text(
                              'Active: $_remainingTime',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else if (_isActive)
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      )
                    else
                      Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: _isActive 
                        ? Colors.green.withOpacity(0.2)
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isActive ? Icons.check : Icons.monetization_on,
                        color: _isActive ? Colors.green : Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        _isActive ? 'Active' : '$cost coins',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _isActive ? Colors.green : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
