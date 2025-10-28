import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ussd_plus/utils/ussd_data_service.dart';
import 'package:ussd_plus/utils/activity_service.dart';
import 'package:ussd_plus/models/ussd_model.dart';
import 'package:ussd_plus/models/activity_model.dart';
import 'package:ussd_plus/widgets/ussd_section_card.dart';
import 'package:ussd_plus/widgets/ussd_code_card.dart';
import 'package:ussd_plus/utils/admob_service.dart';
import 'package:ussd_plus/utils/enhanced_ad_loading_service.dart';
import 'package:ussd_plus/screens/favorites_screen.dart';
import 'package:ussd_plus/widgets/rewarded_ad_consent_dialog.dart';
import 'package:ussd_plus/utils/coin_service.dart';
import 'package:ussd_plus/utils/premium_features_service.dart';
import 'package:ussd_plus/screens/settings_screen.dart';
import 'package:ussd_plus/utils/app_review_service.dart';
import 'package:ussd_plus/widgets/rate_us_dialog.dart';

class USSDCodesScreen extends StatefulWidget {
  const USSDCodesScreen({super.key});

  @override
  State<USSDCodesScreen> createState() => _USSDCodesScreenState();
}

class _USSDCodesScreenState extends State<USSDCodesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<USSDSection> _sections = [];
  List<USSDCode> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = true;
  bool _isPremiumActive = false;

  @override
  void initState() {
    super.initState();
    _loadUSSDData();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final isActive = await PremiumFeaturesService.isFeatureActive(
        PremiumFeature.showAllCodesWeek);
    setState(() {
      _isPremiumActive = isActive;
    });
  }

  Future<void> _loadUSSDData() async {
    setState(() {
      _isLoading = true;
    });

    final sections = await USSDDataService.getOfflineUSSDData();

    setState(() {
      _sections = sections;
      _isLoading = false;
    });
  }

  Future<void> _searchUSSDCodes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final results = await USSDDataService.searchUSSDCodes(query, _sections);

    setState(() {
      _searchResults = results;
    });

    // Log search activity
    if (results.isNotEmpty) {
      await ActivityService.logActivity(
        type: ActivityType.searchPerformed,
        title: 'Searched USSD codes',
        description: 'Found ${results.length} codes for "$query"',
        metadata: {'query': query, 'resultCount': results.length},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        elevation: 0,
        title: const Text('USSD Codes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search USSD codes',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _searchController,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          labelText: 'Enter search term...',
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        onChanged: _searchUSSDCodes,
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: _isSearching
                      ? _buildSearchResults()
                      : _buildSectionsList(),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      itemCount: _sections.length,
      itemBuilder: (context, index) {
        final section = _sections[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: USSDSectionCard(
            section: section,
            onTap: () {
              // Navigate to section details
              _showSectionDetails(section);
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16.0),
            Text(
              'No USSD codes found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final code = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: USSDCodeCard(
            code: code,
            onTap: () => _showSearchCodeDetails(code),
            onFavorite: () => _toggleSearchFavorite(code),
          ),
        );
      },
    );
  }

  void _showSearchCodeDetails(USSDCode code) {
    // Log activity
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
                description:
                    'Watch a short advertisement to dial this USSD code and support the app.',
              );

              if (consent == true) {
                // User chose "Watch Ad" - use enhanced ad loading service
                final adShown = await EnhancedAdLoadingService.showRewardedAdWithFeedback(
                  context: context,
                  onRewarded: (reward) async {
                    // Reward coins for watching ad
                    final newBalance = await CoinService.rewardForRewardedAd();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Earned 10 coins! New balance: $newBalance coins'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }

                    _performDial(code);
                  },
                  timeoutSeconds: 15,
                  customLoadingMessage: 'Loading Advertisement',
                  customSubtitle: 'Please wait while we prepare your reward...',
                );

                // If ad wasn't shown, dial anyway
                if (!adShown) {
                  _performDial(code);
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

      // Track user action for rating prompts
      await AppReviewService.recordAction('ussd_code_dialed', metadata: code.code);

      if (!context.mounted) return;

      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dialing ${code.code}...'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        
        // Show rating dialog after successful actions
        _maybeShowRatingDialog();
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

  Future<void> _toggleSearchFavorite(USSDCode code) async {
    // Toggle the favorite status
    final updatedCode = await USSDDataService.toggleFavorite(code);

    if (!mounted) return;

    // Update the search results list
    setState(() {
      final index = _searchResults.indexWhere((c) => c.id == code.id);
      if (index != -1) {
        _searchResults[index] = updatedCode;
      }

      // Also update in sections if it exists
      for (var i = 0; i < _sections.length; i++) {
        final section = _sections[i];
        final codeIndex = section.codes.indexWhere((c) => c.id == code.id);
        if (codeIndex != -1) {
          section.codes[codeIndex] = updatedCode;
          break;
        }
      }
    });

    // Clear cache so next load gets updated data
    USSDDataService.clearCache();

    // Log favorite activity
    ActivityService.logActivity(
      type: ActivityType.ussdCodeFavorited,
      title: updatedCode.isFavorite
          ? 'Added to favorites'
          : 'Removed from favorites',
      description: '${updatedCode.name} - ${updatedCode.provider}',
      metadata: {'code': updatedCode.code, 'provider': updatedCode.provider},
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${updatedCode.name} ${updatedCode.isFavorite ? 'added to' : 'removed from'} favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSectionDetails(USSDSection section) {
    // Log category view activity
    ActivityService.logActivity(
      type: ActivityType.categoryViewed,
      title: 'Viewed ${section.name}',
      description: '${section.codes.length} USSD codes',
      metadata: {'category': section.name, 'codeCount': section.codes.length},
    );

    // Group codes by provider first, then limit codes per provider if premium not active
    final Map<String, List<USSDCode>> allCodesByProvider = {};
    for (final code in section.codes) {
      if (!allCodesByProvider.containsKey(code.provider)) {
        allCodesByProvider[code.provider] = [];
      }
      allCodesByProvider[code.provider]!.add(code);
    }

    // Limit codes per provider if premium not active
    final Map<String, List<USSDCode>> codesByProvider = {};
    if (_isPremiumActive) {
      codesByProvider.addAll(allCodesByProvider);
    } else {
      // Show all providers but limit codes per provider
      for (final provider in allCodesByProvider.keys) {
        final providerCodes = allCodesByProvider[provider]!;
        codesByProvider[provider] = providerCodes.take(4).toList();
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SectionDetailsScreen(
          section: section,
          codesByProvider: codesByProvider,
          isPremiumActive: _isPremiumActive,
          onPremiumActivated: _checkPremiumStatus,
          totalCodesCount: section.codes.length,
        ),
      ),
    );
  }

  // Helper method to maybe show rating dialog
  Future<void> _maybeShowRatingDialog() async {
    try {
      // Only show on certain actions (e.g., every 10th action)
      final stats = await AppReviewService.getStats();
      final actionCount = stats['actionCount'] as int;
      
      // Show rating dialog every 10 successful dials
      if (actionCount > 0 && actionCount % 10 == 0) {
        await Future.delayed(const Duration(seconds: 2)); // Delay for better UX
        if (mounted) {
          await RateUsDialog.show(context);
        }
      }
    } catch (e) {
      print('Error showing rating dialog: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Section Details Screen with Provider Tabs
class _SectionDetailsScreen extends StatefulWidget {
  final USSDSection section;
  final Map<String, List<USSDCode>> codesByProvider;
  final bool isPremiumActive;
  final VoidCallback? onPremiumActivated;
  final int totalCodesCount;

  const _SectionDetailsScreen({
    required this.section,
    required this.codesByProvider,
    required this.isPremiumActive,
    this.onPremiumActivated,
    required this.totalCodesCount,
  });

  @override
  State<_SectionDetailsScreen> createState() => _SectionDetailsScreenState();
}

class _SectionDetailsScreenState extends State<_SectionDetailsScreen> {
  late Map<String, List<USSDCode>> _codesByProvider;

  @override
  void initState() {
    super.initState();
    _codesByProvider = Map.from(widget.codesByProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final providers = _codesByProvider.keys.toList();

    return DefaultTabController(
      length: providers.length,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2A2A2A),
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.section.icon,
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(widget.section.name),
                ],
              ),
              Text(
                '${providers.length} provider${providers.length == 1 ? '' : 's'} • ${widget.section.codes.length} codes',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            tabs: providers.map((provider) {
              final codes = _codesByProvider[provider]!;
              return Tab(
                child: Row(
                  children: [
                    Text(provider),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${codes.length}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: providers.map((provider) {
            final codes = _codesByProvider[provider]!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // USSD Codes List
                  ...codes.map((code) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: USSDCodeCard(
                          code: code,
                          onTap: () => _showCodeDetails(context, code),
                          onFavorite: () => _toggleFavorite(context, code),
                        ),
                      )),

                  // Premium Banner (if not active and showing limited codes)
                  if (!widget.isPremiumActive &&
                      widget.section.codes.length > 4)
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.withOpacity(0.2),
                            Colors.orange.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  'Premium Feature',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Showing first 4 codes per provider. Unlock all ${widget.section.codes.length} codes with premium!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigate to settings page using MaterialPageRoute
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(
                                    scrollToCoins: true,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.settings, size: 18),
                            label: const Text('Go to Settings'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Hidden Codes Indicator (if not premium and there are more codes)
                  if (!widget.isPremiumActive &&
                      widget.totalCodesCount > codes.length)
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.more_horiz,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'More codes below',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  '${widget.totalCodesCount - codes.length} additional codes are hidden',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCodeDetails(BuildContext context, USSDCode code) {
    // Log activity
    ActivityService.logActivity(
      type: ActivityType.ussdCodeViewed,
      title: 'Viewed ${code.name}',
      description: '${code.provider} - ${code.code}',
      metadata: {'code': code.code, 'provider': code.provider},
    );

    // Show interstitial ad occasionally
    AdMobService.showInterstitialAdIfReady();

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
                description:
                    'Watch a short advertisement to dial this USSD code and support the app.',
              );

              if (consent == true) {
                // User chose "Watch Ad" - use enhanced ad loading service
                final adShown = await EnhancedAdLoadingService.showRewardedAdWithFeedback(
                  context: context,
                  onRewarded: (reward) async {
                    // Reward coins for watching ad
                    final newBalance = await CoinService.rewardForRewardedAd();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Earned 10 coins! New balance: $newBalance coins'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }

                    _performDial(code);
                  },
                  timeoutSeconds: 15,
                  customLoadingMessage: 'Loading Advertisement',
                  customSubtitle: 'Please wait while we prepare your reward...',
                );

                // If ad wasn't shown, dial anyway
                if (!adShown) {
                  _performDial(code);
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

  Future<void> _toggleFavorite(BuildContext context, USSDCode code) async {
    // Toggle the favorite status
    final updatedCode = await USSDDataService.toggleFavorite(code);

    if (!mounted) return;

    // Update the local state
    setState(() {
      // Find and update the code in the provider map
      _codesByProvider.forEach((provider, codes) {
        final index = codes.indexWhere((c) => c.id == code.id);
        if (index != -1) {
          codes[index] = updatedCode;
        }
      });
    });

    // Clear cache so next load gets updated data
    USSDDataService.clearCache();

    // Log favorite activity
    ActivityService.logActivity(
      type: ActivityType.ussdCodeFavorited,
      title: updatedCode.isFavorite
          ? 'Added to favorites'
          : 'Removed from favorites',
      description: '${updatedCode.name} - ${updatedCode.provider}',
      metadata: {'code': updatedCode.code, 'provider': updatedCode.provider},
    );

    if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${updatedCode.name} ${updatedCode.isFavorite ? 'added to' : 'removed from'} favorites'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

  // Helper method to maybe show rating dialog
  Future<void> _maybeShowRatingDialog() async {
    try {
      // Only show on certain actions (e.g., every 10th action)
      final stats = await AppReviewService.getStats();
      final actionCount = stats['actionCount'] as int;
      
      // Show rating dialog every 10 successful dials
      if (actionCount > 0 && actionCount % 10 == 0) {
        await Future.delayed(const Duration(seconds: 2)); // Delay for better UX
        if (mounted) {
          await RateUsDialog.show(context);
        }
      }
    } catch (e) {
      print('Error showing rating dialog: $e');
    }
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

      // Track user action for rating prompts
      await AppReviewService.recordAction('ussd_code_dialed', metadata: code.code);

      if (!context.mounted) return;

      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dialing ${code.code}...'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        
        // Show rating dialog after successful actions
        _maybeShowRatingDialog();
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
