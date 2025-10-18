import 'package:flutter/material.dart';
import 'package:ussd_plus/utils/ussd_data_service.dart';
import 'package:ussd_plus/utils/activity_service.dart';
import 'package:ussd_plus/models/ussd_model.dart';
import 'package:ussd_plus/models/activity_model.dart';
import 'package:ussd_plus/widgets/ussd_section_card.dart';
import 'package:ussd_plus/widgets/ussd_code_card.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUSSDData();
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
              // Navigate to favorites
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
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search USSD codes...',
                      hintStyle: TextStyle(
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dialing ${code.code}...')),
              );
              // Log copy/dial activity
              ActivityService.logActivity(
                type: ActivityType.ussdCodeCopied,
                title: 'Dialed ${code.name}',
                description: code.code,
              );
            },
            child: const Text('Dial'),
          ),
        ],
      ),
    );
  }

  void _toggleSearchFavorite(USSDCode code) {
    // Log favorite activity
    ActivityService.logActivity(
      type: ActivityType.ussdCodeFavorited,
      title: code.isFavorite ? 'Removed from favorites' : 'Added to favorites',
      description: '${code.name} - ${code.provider}',
      metadata: {'code': code.code, 'provider': code.provider},
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${code.name} ${code.isFavorite ? 'removed from' : 'added to'} favorites'),
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
    
    // Group codes by provider
    final Map<String, List<USSDCode>> codesByProvider = {};
    for (final code in section.codes) {
      if (!codesByProvider.containsKey(code.provider)) {
        codesByProvider[code.provider] = [];
      }
      codesByProvider[code.provider]!.add(code);
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SectionDetailsScreen(
          section: section,
          codesByProvider: codesByProvider,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Section Details Screen with Tabs
class _SectionDetailsScreen extends StatelessWidget {
  final USSDSection section;
  final Map<String, List<USSDCode>> codesByProvider;

  const _SectionDetailsScreen({
    required this.section,
    required this.codesByProvider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final providers = codesByProvider.keys.toList();

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
                  Text(section.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(section.name),
                ],
              ),
              Text(
                '${providers.length} providers • ${section.codes.length} codes',
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
              final codes = codesByProvider[provider]!;
              return Tab(
                child: Row(
                  children: [
                    Text(provider),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
            final codes = codesByProvider[provider]!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: codes.length,
              itemBuilder: (context, index) {
                final code = codes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: USSDCodeCard(
                    code: code,
                    onTap: () => _showCodeDetails(context, code),
                    onFavorite: () => _toggleFavorite(context, code),
                  ),
                );
              },
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dialing ${code.code}...')),
              );
              // Log copy/dial activity
              ActivityService.logActivity(
                type: ActivityType.ussdCodeCopied,
                title: 'Dialed ${code.name}',
                description: code.code,
              );
            },
            child: const Text('Dial'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(BuildContext context, USSDCode code) {
    // Log favorite activity
    ActivityService.logActivity(
      type: ActivityType.ussdCodeFavorited,
      title: code.isFavorite ? 'Removed from favorites' : 'Added to favorites',
      description: '${code.name} - ${code.provider}',
      metadata: {'code': code.code, 'provider': code.provider},
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${code.name} ${code.isFavorite ? 'removed from' : 'added to'} favorites'),
      ),
    );
  }
}
