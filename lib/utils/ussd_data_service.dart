import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import '../models/ussd_model.dart';

class USSDDataService {
  static List<USSDSection>? _cachedSections;
  
  static Future<List<USSDSection>> getOfflineUSSDData() async {
    if (_cachedSections != null) {
      return _cachedSections!;
    }
    
    try {
      // Group USSD codes by category
      final Map<String, List<USSDCode>> categorizedCodes = {};
      
      // Load JSON data from assets (comprehensive Ghana USSD codes)
      try {
        final String jsonString = await rootBundle.loadString('assets/dataset/ussd_codes_ghana.json');
        final List<dynamic> jsonData = json.decode(jsonString) as List;
        
        for (final item in jsonData) {
          final category = (item['category'] ?? 'Other').toString();
          final code = USSDCode(
            id: item['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            code: item['code'] ?? '',
            name: item['name'] ?? 'Unknown',
            description: item['description'] ?? '',
            provider: item['name'] ?? 'Unknown',
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
            
            final code = USSDCode(
              id: 'excel_${DateTime.now().millisecondsSinceEpoch}_${categorizedCodes.length}',
              code: codeValue,
              name: name,
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
      
      _cachedSections = sections;
      return sections;
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
            name: 'Check Balance',
            description: 'Check MTN airtime balance',
            provider: 'MTN',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'mtn_data',
            code: '*138#',
            name: 'Data Bundle',
            description: 'Subscribe to MTN data bundles',
            provider: 'MTN',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'vodafone_balance',
            code: '*110#',
            name: 'Check Balance',
            description: 'Check Vodafone airtime balance',
            provider: 'Vodafone',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'vodafone_data',
            code: '*110*2#',
            name: 'Data Bundle',
            description: 'Subscribe to Vodafone data bundles',
            provider: 'Vodafone',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'airtel_balance',
            code: '*123#',
            name: 'Check Balance',
            description: 'Check Airtel airtime balance',
            provider: 'Airtel',
            category: 'telecom',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'glo_balance',
            code: '*124*4#',
            name: 'Check Balance',
            description: 'Check Glo airtime balance',
            provider: 'Globacom',
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
            name: 'Check Balance',
            description: 'Check GCB Bank account balance',
            provider: 'GCB Bank',
            category: 'banking',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'absa_balance',
            code: '*920*0#',
            name: 'Check Balance',
            description: 'Check Absa Bank account balance',
            provider: 'Absa Bank',
            category: 'banking',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'fidelity_balance',
            code: '*770*0#',
            name: 'Check Balance',
            description: 'Check Fidelity Bank account balance',
            provider: 'Fidelity Bank',
            category: 'banking',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'zenith_balance',
            code: '*966*0#',
            name: 'Check Balance',
            description: 'Check Zenith Bank account balance',
            provider: 'Zenith Bank',
            category: 'banking',
            lastUsed: DateTime.now(),
          ),
        ],
      ),
      USSDSection(
        id: 'utilities',
        name: 'Utilities',
        description: 'Electricity, water, and other utility services',
        icon: '⚡',
        color: '#28A745',
        codes: [
          USSDCode(
            id: 'ecg_pay',
            code: '*713*33#',
            name: 'Pay Electricity Bill',
            description: 'Pay ECG electricity bill',
            provider: 'ECG',
            category: 'utilities',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'gwc_pay',
            code: '*713*33#',
            name: 'Pay Water Bill',
            description: 'Pay GWC water bill',
            provider: 'GWC',
            category: 'utilities',
            lastUsed: DateTime.now(),
          ),
          USSDCode(
            id: 'grdc_pay',
            code: '*713*33#',
            name: 'Pay Gas Bill',
            description: 'Pay GRDC gas bill',
            provider: 'GRDC',
            category: 'utilities',
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
          USSDCode(
            id: 'airtel_money',
            code: '*126#',
            name: 'Airtel Money',
            description: 'Access Airtel Money services',
            provider: 'Airtel',
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
}
