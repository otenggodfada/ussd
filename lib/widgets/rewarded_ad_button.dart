import 'package:flutter/material.dart';
import 'package:ussd_plus/utils/admob_service.dart';

class RewardedAdButton extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onRewardEarned;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const RewardedAdButton({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onRewardEarned,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  State<RewardedAdButton> createState() => _RewardedAdButtonState();
}

class _RewardedAdButtonState extends State<RewardedAdButton> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Preload rewarded ad if not already loaded
    if (!AdMobService.isRewardedAdReady) {
      AdMobService.loadRewardedAd();
    }
  }

  Future<void> _showRewardedAd() async {
    // Check if we're on simulator or if ad is ready
    if (!AdMobService.isRewardedAdReady && !AdMobService.isSimulator) {
      _showErrorSnackBar('Ad not ready. Please try again in a moment.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      AdMobService.showRewardedAd(
        onRewarded: (reward) {
          setState(() => _isLoading = false);
          widget.onRewardEarned();
          _showSuccessSnackBar(
            'Reward earned! ${reward.amount} ${reward.type}',
          );
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to show ad: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAdReady = AdMobService.isRewardedAdReady;
    final isLoading = _isLoading || widget.isLoading;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.backgroundColor ?? theme.colorScheme.primary,
            (widget.backgroundColor ?? theme.colorScheme.primary).withOpacity(
              0.8,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: (widget.backgroundColor ?? theme.colorScheme.primary)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: isLoading ? null : _showRewardedAd,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.textColor ?? Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: widget.textColor ?? Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            widget.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: (widget.textColor ?? Colors.white)
                                  .withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    else
                      Icon(
                        AdMobService.isSimulator
                            ? Icons.developer_mode_rounded
                            : (isAdReady
                                  ? Icons.play_arrow_rounded
                                  : Icons.hourglass_empty_rounded),
                        color: widget.textColor ?? Colors.white,
                        size: 24,
                      ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.video_library_rounded,
                        color: widget.textColor ?? Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        AdMobService.isSimulator
                            ? 'Simulator Mode'
                            : (isAdReady
                                  ? 'Watch Ad to Unlock'
                                  : 'Ad Loading...'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: widget.textColor ?? Colors.white,
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
