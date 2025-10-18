import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ussd_model.dart';
import 'location_service.dart';

class USSDDataService {
  static List<USSDSection>? _cachedSections;
  static String? _cachedCountry;
  static const String _favoritesKey = 'favorite_ussd_codes';
  static const String _countryKey = 'selected_country';
  
  // Get selected country from storage with auto-detection
  static Future<String> getSelectedCountry() async {
    final prefs = await SharedPreferences.getInstance();
    final manualCountry = prefs.getString(_countryKey);
    
    // If user manually selected a country, use that
    if (manualCountry != null) {
      return manualCountry;
    }
    
    // Otherwise, try auto-detection
    final autoDetectedCountry = await LocationService.getCountryWithAutoDetect('Ghana');
    return autoDetectedCountry;
  }
  
  // Set selected country
  static Future<void> setSelectedCountry(String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countryKey, country);
    clearCache(); // Clear cache to force reload with new country
  }
  
  // Get available countries
  static Future<List<String>> getAvailableCountries() async {
    return [
      'Ghana',
      'Nigeria',
      'Kenya',
      'Tanzania',
      'Uganda',
      'South Africa',
      'Rwanda',
      'India',
      'USA'
    ]; // Sorted by region, then alphabetically
  }
  
  static Future<List<USSDSection>> getOfflineUSSDData() async {
    final selectedCountry = await getSelectedCountry();
    
    // Return cached data if available and country hasn't changed
    if (_cachedSections != null && _cachedCountry == selectedCountry) {
      return _cachedSections!;
    }
    
    try {
      // Group USSD codes by category
      final Map<String, List<USSDCode>> categorizedCodes = {};
      
      // Determine which JSON file to load based on selected country
      String jsonFileName;
      switch (selectedCountry) {
        case 'USA':
          jsonFileName = 'assets/dataset/ussd_codes_usa.json';
          break;
        case 'Nigeria':
          jsonFileName = 'assets/dataset/ussd_codes_nigeria.json';
          break;
        case 'Kenya':
          jsonFileName = 'assets/dataset/ussd_codes_kenya.json';
          break;
        case 'Tanzania':
          jsonFileName = 'assets/dataset/ussd_codes_tanzania.json';
          break;
        case 'Uganda':
          jsonFileName = 'assets/dataset/ussd_codes_uganda.json';
          break;
        case 'South Africa':
          jsonFileName = 'assets/dataset/ussd_codes_south_africa.json';
          break;
        case 'Rwanda':
          jsonFileName = 'assets/dataset/ussd_codes_rwanda.json';
          break;
        case 'India':
          jsonFileName = 'assets/dataset/ussd_codes_india.json';
          break;
        case 'Ghana':
        default:
          jsonFileName = 'assets/dataset/ussd_codes_ghana.json';
          break;
      }
      
      // Load JSON data from assets
      try {
        final String jsonString = await rootBundle.loadString(jsonFileName);
        final List<dynamic> jsonData = json.decode(jsonString) as List;
        
        for (final item in jsonData) {
          final category = (item['category'] ?? 'Other').toString();
          // Use 'network' field for cleaner provider names (MTN, Vodafone), fallback to 'provider'
          final providerName = (item['network'] ?? item['provider'] ?? 'Unknown').toString()
              .replaceAll(' Ghana', '')
              .replaceAll('Ghana', '')
              .trim();
          // Use 'name' field directly - it already has proper names like "MTN Mobile Money"
          final codeName = item['name']?.toString() ?? 'Unknown';
          
          final code = USSDCode(
            id: item['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            code: item['code'] ?? '',
            name: codeName,
            description: item['description'] ?? '',
            provider: providerName,
            category: _mapCategoryName(category),
            lastUsed: DateTime.now(),
          );
          
          if (!categorizedCodes.containsKey(category)) {
            categorizedCodes[category] = [];
          }
          categorizedCodes[category]!.add(code);
        }
        print('Loaded ${jsonData.length} USSD codes from JSON');
      } catch (e) {
        print('Error loading JSON data: $e');
      }
      
      // Load Excel data from assets (for any additional custom codes)
      try {
        final ByteData excelData = await rootBundle.load('assets/dataset/data.xlsx');
        final bytes = excelData.buffer.asUint8List();
        final excel = Excel.decodeBytes(bytes);
        
        for (var table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet == null) continue;
          
          // Skip header row (index 0)
          for (var row in sheet.rows.skip(1)) {
            if (row.isEmpty) continue;
            
            // Assuming columns: Category, Name, Code, Description, Network, Provider
            final category = row.length > 0 ? (row[0]?.value?.toString() ?? 'Other') : 'Other';
            final name = row.length > 1 ? (row[1]?.value?.toString() ?? 'Unknown') : 'Unknown';
            final codeValue = row.length > 2 ? (row[2]?.value?.toString() ?? '') : '';
            final description = row.length > 3 ? (row[3]?.value?.toString() ?? '') : '';
            // Skip network column (index 4) if not needed
            final provider = row.length > 5 ? (row[5]?.value?.toString() ?? name) : name;
            
            if (codeValue.isEmpty) continue;
            
            // Create code name with provider prefix
            final prefixedName = name.toLowerCase().startsWith(provider.toLowerCase())
                ? name
                : '$provider $name';
            
            final code = USSDCode(
              id: 'excel_${DateTime.now().millisecondsSinceEpoch}_${categorizedCodes.length}',
              code: codeValue,
              name: prefixedName,
              description: description,
              provider: provider,
              category: _mapCategoryName(category),
              lastUsed: DateTime.now(),
            );
            
            if (!categorizedCodes.containsKey(category)) {
              categorizedCodes[category] = [];
            }
            categorizedCodes[category]!.add(code);
          }
        }
      } catch (e) {
        print('Error loading Excel data: $e');
      }
      
      // Create sections from categorized codes
      // Within each section, codes will be sorted by provider
      final sections = <USSDSection>[];
      categorizedCodes.forEach((categoryName, codes) {
        // Sort codes by provider within category
        codes.sort((a, b) => a.provider.compareTo(b.provider));
        
        sections.add(USSDSection(
          id: categoryName.toLowerCase().replaceAll(' ', '_'),
          name: categoryName,
          description: _getCategoryDescription(categoryName),
          icon: _getCategoryIcon(categoryName),
          color: _getCategoryColor(categoryName),
          codes: codes,
        ));
      });
      
      // Load favorites from storage
      final sectionsWithFavorites = await loadFavoritesFromStorage(sections);
      
      _cachedSections = sectionsWithFavorites;
      _cachedCountry = selectedCountry;
      return sectionsWithFavorites;
    } catch (e) {
      print('Error loading USSD data: $e');
      return _getFallbackData();
    }
  }
  
  static String _mapCategoryName(String category) {
    switch (category.toLowerCase()) {
      case 'banking':
        return 'banking';
      case 'telecom':
      case 'telecommunications':
        return 'telecom';
      case 'utilities':
        return 'utilities';
      case 'mobile money':
      case 'mobilemoney':
        return 'mobile_money';
      case 'device info':
        return 'device_info';
      case 'call management':
        return 'call_management';
      case 'account management':
        return 'account_management';
      case 'customer service':
        return 'customer_service';
      case 'transport':
        return 'transport';
      default:
        return 'other';
    }
  }
  
  static String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'banking':
        return '🏦';
      case 'telecom':
      case 'telecommunications':
        return '📱';
      case 'utilities':
        return '⚡';
      case 'mobile money':
      case 'mobilemoney':
        return '💰';
      case 'device info':
        return '📲';
      case 'call management':
        return '📞';
      case 'account management':
        return '👤';
      case 'customer service':
        return '🎧';
      case 'transport':
        return '🚗';
      default:
        return '📋';
    }
  }
  
  static String _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'banking':
        return '#FFC700';
      case 'telecom':
      case 'telecommunications':
        return '#0A3D91';
      case 'utilities':
        return '#28A745';
      case 'mobile money':
      case 'mobilemoney':
        return '#6F42C1';
      case 'device info':
        return '#17A2B8';
      case 'call management':
        return '#E83E8C';
      case 'account management':
        return '#FD7E14';
      case 'customer service':
        return '#20C997';
      case 'transport':
        return '#F012BE';
      default:
        return '#6C757D';
    }
  }
  
  static String _getCategoryDescription(String category) {
    switch (category.toLowerCase()) {
      case 'banking':
        return 'Bank account and financial services';
      case 'telecom':
      case 'telecommunications':
        return 'Mobile network services and data bundles';
      case 'utilities':
        return 'Electricity, water, and other utility services';
      case 'mobile money':
      case 'mobilemoney':
        return 'Mobile money and digital payment services';
      case 'device info':
        return 'Device information and diagnostic codes';
      case 'call management':
        return 'Call forwarding, waiting, and caller ID';
      case 'account management':
        return 'Check balance, usage, and refill account';
      case 'customer service':
        return 'Customer support and service contacts';
      case 'transport':
        return 'Ride hailing and transport services';
      default:
        return 'Other services';
    }
  }
  
  static List<USSDSection> _getFallbackData() {
    return [
      USSDSection(
        id: 'telecom',
        name: 'Telecom Services',
        description: 'Mobile network services and data bundles',
        icon: '📱',
        color: '#0A3D91',
        codes: [
          USSDCode(
            id: 'mtn_balance',
            code: '*124#',
            name: 'MTN Check Balance',
            description: 'Check MTN airtime balance',
            provider: 'MTN',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'mtn_data',
            code: '*138#',
            name: 'MTN Data Bundle',
            description: 'Subscribe to MTN data bundles',
            provider: 'MTN',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'mtn_borrow',
            code: '*506#',
            name: 'MTN Borrow Airtime',
            description: 'Borrow airtime on credit',
            provider: 'MTN',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'vodafone_balance',
            code: '*110#',
            name: 'Vodafone Check Balance',
            description: 'Check Vodafone airtime balance',
            provider: 'Vodafone',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'vodafone_data',
            code: '*110*2#',
            name: 'Vodafone Data Bundle',
            description: 'Subscribe to Vodafone data bundles',
            provider: 'Vodafone',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
        ],
      ),
      USSDSection(
        id: 'banking',
        name: 'Banking Services',
        description: 'Bank account and financial services',
        icon: '🏦',
        color: '#FFC700',
        codes: [
          USSDCode(
            id: 'gcb_balance',
            code: '*422*0#',
            name: 'GCB Check Balance',
            description: 'Check GCB Bank account balance',
            provider: 'GCB Bank',
            category: 'banking',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'gcb_transfer',
            code: '*422*1#',
            name: 'GCB Transfer',
            description: 'Transfer money from GCB account',
            provider: 'GCB Bank',
            category: 'banking',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'absa_balance',
            code: '*920*0#',
            name: 'Absa Check Balance',
            description: 'Check Absa Bank account balance',
            provider: 'Absa Bank',
            category: 'banking',
            lastUsed: DateTime.now(),
          ),
        ],
      ),
      USSDSection(
        id: 'mobile_money',
        name: 'Mobile Money',
        description: 'Mobile money and digital payment services',
        icon: '💰',
        color: '#6F42C1',
        codes: [
          USSDCode(
            id: 'mtn_momo',
            code: '*170#',
            name: 'MTN Mobile Money',
            description: 'Access MTN Mobile Money services',
            provider: 'MTN',
            category: 'mobile_money',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'vodafone_cash',
            code: '*110#',
            name: 'Vodafone Cash',
            description: 'Access Vodafone Cash services',
            provider: 'Vodafone',
            category: 'mobile_money',
            lastUsed: DateTime.now(),
          ),
        ],
      ),
    ];
  }

  static Future<List<USSDCode>> searchUSSDCodes(String query, List<USSDSection> sections) async {
    if (query.isEmpty) return [];
    
    final results = <USSDCode>[];
    final lowerQuery = query.toLowerCase();
    
    for (final section in sections) {
      for (final code in section.codes) {
        if (code.name.toLowerCase().contains(lowerQuery) ||
            code.description.toLowerCase().contains(lowerQuery) ||
            code.provider.toLowerCase().contains(lowerQuery) ||
            code.code.contains(query)) {
          results.add(code);
        }
      }
    }
    
    return results;
  }

  static Future<List<USSDCode>> getFavoriteCodes(List<USSDSection> sections) async {
    final favorites = <USSDCode>[];
    
    for (final section in sections) {
      for (final code in section.codes) {
        if (code.isFavorite) {
          favorites.add(code);
        }
      }
    }
    
    return favorites;
  }

  static Future<List<USSDCode>> getRecentCodes(List<USSDSection> sections) async {
    final recent = <USSDCode>[];
    
    for (final section in sections) {
      for (final code in section.codes) {
        recent.add(code);
      }
    }
    
    recent.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    return recent.take(10).toList();
  }

  static Future<List<USSDCode>> getMostUsedCodes(List<USSDSection> sections) async {
    final mostUsed = <USSDCode>[];
    
    for (final section in sections) {
      for (final code in section.codes) {
        mostUsed.add(code);
      }
    }
    
    mostUsed.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return mostUsed.take(10).toList();
  }

  // Save favorite status to persistent storage
  static Future<void> saveFavorite(String codeId, bool isFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteIds();
    
    if (isFavorite) {
      favorites.add(codeId);
    } else {
      favorites.remove(codeId);
    }
    
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }

  // Get list of favorite code IDs from storage
  static Future<Set<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList(_favoritesKey) ?? [];
    return favoritesList.toSet();
  }

  // Load favorites from storage and update sections
  static Future<List<USSDSection>> loadFavoritesFromStorage(List<USSDSection> sections) async {
    final favoriteIds = await getFavoriteIds();
    
    return sections.map((section) {
      final updatedCodes = section.codes.map((code) {
        return code.copyWith(isFavorite: favoriteIds.contains(code.id));
      }).toList();
      
      return USSDSection(
        id: section.id,
        name: section.name,
        description: section.description,
        icon: section.icon,
        color: section.color,
        codes: updatedCodes,
      );
    }).toList();
  }

  // Toggle favorite status for a specific code
  static Future<USSDCode> toggleFavorite(USSDCode code) async {
    final newFavoriteStatus = !code.isFavorite;
    await saveFavorite(code.id, newFavoriteStatus);
    return code.copyWith(isFavorite: newFavoriteStatus);
  }

  // Clear cache to force reload with updated favorites
  static void clearCache() {
    _cachedSections = null;
  }
}
