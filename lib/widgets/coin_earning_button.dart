import 'package:flutter/material.dart';
import 'package:ussd_plus/utils/admob_service.dart';
import 'package:ussd_plus/utils/coin_service.dart';
import 'package:ussd_plus/widgets/rewarded_ad_consent_dialog.dart';

class CoinEarningButton extends StatefulWidget {
  final VoidCallback? onCoinsEarned;

  const CoinEarningButton({
    super.key,
    this.onCoinsEarned,
  });

  @override
  State<CoinEarningButton> createState() => _CoinEarningButtonState();
}

class _CoinEarningButtonState extends State<CoinEarningButton> {
  bool _isLoading = false;

  Future<void> _earnCoins() async {
    setState(() => _isLoading = true);

    try {
      // Show consent dialog for watching ads to earn coins
      final consent = await RewardedAdConsentDialog.show(
        context: context,
        title: 'Earn Coins',
        description: 'Watch a short advertisement to earn 10 coins!',
      );

      if (consent == true) {
        // Show rewarded ad
        if (AdMobService.isRewardedAdReady) {
          AdMobService.showRewardedAd(
            onRewarded: (reward) async {
              // Reward coins for watching ad
              final newBalance = await CoinService.rewardForRewardedAd();
              
              if (mounted) {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Earned 10 coins! New balance: $newBalance coins'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
              
              widget.onCoinsEarned?.call();
            },
          );
        } else {
          // No ad ready, show loading animation and wait for ads to load
          if (mounted) {
            // Keep loading state while waiting for ads
            // Wait for up to 10 seconds for ads to load
            bool adLoaded = false;
            for (int i = 0; i < 10; i++) {
              await Future.delayed(const Duration(seconds: 1));
              if (AdMobService.isRewardedAdReady) {
                adLoaded = true;
                break;
              }
            }
            
            if (adLoaded && mounted) {
              // Ad loaded, show it
              AdMobService.showRewardedAd(
                onRewarded: (reward) async {
                  // Reward coins for watching ad
                  final newBalance = await CoinService.rewardForRewardedAd();
                  
                  if (mounted) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Earned 10 coins! New balance: $newBalance coins'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                  
                  widget.onCoinsEarned?.call();
                },
              );
            } else {
              // No ad loaded within 10 seconds
              if (mounted) {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ad not ready. Please try again later.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            }
          }
        }
      } else {
        // User declined, stop loading
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.3),
            Colors.orange.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.amber.withOpacity(0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: _isLoading ? null : _earnCoins,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  )
                else
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.amber,
                    size: 24,
                  ),
                const SizedBox(width: 12.0),
                Text(
                  _isLoading ? 'Loading Ad...' : 'Watch Ad to Earn 10 Coins',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
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
