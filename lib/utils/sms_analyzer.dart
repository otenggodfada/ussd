import '../models/sms_model.dart';
import 'country_config_service.dart';

class SMSAnalyzer {
  // Country-specific SMS keywords and patterns
  static Map<String, Map<String, SMSCategory>> _getCountryKeywords(String country) {
    switch (country) {
      case 'Nigeria':
        return {
          'telecom': {
            'airtime': SMSCategory.telecom,
            'data': SMSCategory.telecom,
            'bundle': SMSCategory.telecom,
            'balance': SMSCategory.telecom,
            'credit': SMSCategory.telecom,
            'mtn': SMSCategory.telecom,
            'airtel': SMSCategory.telecom,
            'glo': SMSCategory.telecom,
            '9mobile': SMSCategory.telecom,
            'recharge': SMSCategory.telecom,
            'subscription': SMSCategory.telecom,
          },
          'banking': {
            'gtbank': SMSCategory.banking,
            'access bank': SMSCategory.banking,
            'zenith bank': SMSCategory.banking,
            'first bank': SMSCategory.banking,
            'uba': SMSCategory.banking,
            'stanbic': SMSCategory.banking,
            'fidelity bank': SMSCategory.banking,
            'account': SMSCategory.banking,
            'transaction': SMSCategory.banking,
            'transfer': SMSCategory.banking,
            'payment': SMSCategory.banking,
            'debit': SMSCategory.banking,
            'credit': SMSCategory.banking,
            'atm': SMSCategory.banking,
            'card': SMSCategory.banking,
          },
          'mobile_money': {
            'opay': SMSCategory.mobileMoney,
            'palm pay': SMSCategory.mobileMoney,
            'kuda': SMSCategory.mobileMoney,
            'carbon': SMSCategory.mobileMoney,
            'fairmoney': SMSCategory.mobileMoney,
            'send money': SMSCategory.mobileMoney,
            'receive money': SMSCategory.mobileMoney,
            'cash out': SMSCategory.mobileMoney,
            'cash in': SMSCategory.mobileMoney,
          },
          'utilities': {
            'ekedc': SMSCategory.utilities,
            'ikedc': SMSCategory.utilities,
            'aedc': SMSCategory.utilities,
            'phed': SMSCategory.utilities,
            'kedco': SMSCategory.utilities,
            'electricity': SMSCategory.utilities,
            'bill': SMSCategory.utilities,
            'meter': SMSCategory.utilities,
            'units': SMSCategory.utilities,
          },
        };
        
      case 'Kenya':
        return {
          'telecom': {
            'airtime': SMSCategory.telecom,
            'data': SMSCategory.telecom,
            'bundle': SMSCategory.telecom,
            'balance': SMSCategory.telecom,
            'credit': SMSCategory.telecom,
            'safaricom': SMSCategory.telecom,
            'airtel': SMSCategory.telecom,
            'telkom': SMSCategory.telecom,
            'recharge': SMSCategory.telecom,
            'subscription': SMSCategory.telecom,
          },
          'banking': {
            'equity bank': SMSCategory.banking,
            'kcb bank': SMSCategory.banking,
            'co-operative bank': SMSCategory.banking,
            'standard chartered': SMSCategory.banking,
            'barclays bank': SMSCategory.banking,
            'absa bank': SMSCategory.banking,
            'account': SMSCategory.banking,
            'transaction': SMSCategory.banking,
            'transfer': SMSCategory.banking,
            'payment': SMSCategory.banking,
            'debit': SMSCategory.banking,
            'credit': SMSCategory.banking,
            'atm': SMSCategory.banking,
            'card': SMSCategory.banking,
          },
          'mobile_money': {
            'm-pesa': SMSCategory.mobileMoney,
            'airtel money': SMSCategory.mobileMoney,
            't-kash': SMSCategory.mobileMoney,
            'send money': SMSCategory.mobileMoney,
            'receive money': SMSCategory.mobileMoney,
            'cash out': SMSCategory.mobileMoney,
            'cash in': SMSCategory.mobileMoney,
            'lipa na m-pesa': SMSCategory.mobileMoney,
            'buy goods': SMSCategory.mobileMoney,
          },
          'utilities': {
            'kenya power': SMSCategory.utilities,
            'kenya water': SMSCategory.utilities,
            'nairobi water': SMSCategory.utilities,
            'electricity': SMSCategory.utilities,
            'bill': SMSCategory.utilities,
            'meter': SMSCategory.utilities,
            'units': SMSCategory.utilities,
          },
        };
        
      case 'USA':
        return {
          'telecom': {
            'att': SMSCategory.telecom,
            't-mobile': SMSCategory.telecom,
            'verizon': SMSCategory.telecom,
            'sprint': SMSCategory.telecom,
            'boost mobile': SMSCategory.telecom,
            'cricket wireless': SMSCategory.telecom,
            'metro': SMSCategory.telecom,
            'data': SMSCategory.telecom,
            'balance': SMSCategory.telecom,
            'account': SMSCategory.telecom,
            'usage': SMSCategory.telecom,
            'plan': SMSCategory.telecom,
          },
          'banking': {
            'chase': SMSCategory.banking,
            'bank of america': SMSCategory.banking,
            'wells fargo': SMSCategory.banking,
            'citibank': SMSCategory.banking,
            'us bank': SMSCategory.banking,
            'pnc bank': SMSCategory.banking,
            'capital one': SMSCategory.banking,
            'account': SMSCategory.banking,
            'transaction': SMSCategory.banking,
            'transfer': SMSCategory.banking,
            'payment': SMSCategory.banking,
            'debit': SMSCategory.banking,
            'credit': SMSCategory.banking,
            'atm': SMSCategory.banking,
            'card': SMSCategory.banking,
          },
          'mobile_money': {
            'venmo': SMSCategory.mobileMoney,
            'paypal': SMSCategory.mobileMoney,
            'zelle': SMSCategory.mobileMoney,
            'cash app': SMSCategory.mobileMoney,
            'apple pay': SMSCategory.mobileMoney,
            'google pay': SMSCategory.mobileMoney,
            'send money': SMSCategory.mobileMoney,
            'receive money': SMSCategory.mobileMoney,
            'payment': SMSCategory.mobileMoney,
          },
          'utilities': {
            'coned': SMSCategory.utilities,
            'pg&e': SMSCategory.utilities,
            'southern california edison': SMSCategory.utilities,
            'florida power': SMSCategory.utilities,
            'electricity': SMSCategory.utilities,
            'bill': SMSCategory.utilities,
            'meter': SMSCategory.utilities,
            'usage': SMSCategory.utilities,
          },
        };
        
      case 'India':
        return {
          'telecom': {
            'airtel': SMSCategory.telecom,
            'jio': SMSCategory.telecom,
            'vodafone idea': SMSCategory.telecom,
            'bsnl': SMSCategory.telecom,
            'airtime': SMSCategory.telecom,
            'data': SMSCategory.telecom,
            'bundle': SMSCategory.telecom,
            'balance': SMSCategory.telecom,
            'credit': SMSCategory.telecom,
            'recharge': SMSCategory.telecom,
            'subscription': SMSCategory.telecom,
          },
          'banking': {
            'sbi': SMSCategory.banking,
            'hdfc bank': SMSCategory.banking,
            'icici bank': SMSCategory.banking,
            'axis bank': SMSCategory.banking,
            'kotak bank': SMSCategory.banking,
            'pnb': SMSCategory.banking,
            'account': SMSCategory.banking,
            'transaction': SMSCategory.banking,
            'transfer': SMSCategory.banking,
            'payment': SMSCategory.banking,
            'debit': SMSCategory.banking,
            'credit': SMSCategory.banking,
            'atm': SMSCategory.banking,
            'card': SMSCategory.banking,
          },
          'mobile_money': {
            'paytm': SMSCategory.mobileMoney,
            'phonepe': SMSCategory.mobileMoney,
            'google pay': SMSCategory.mobileMoney,
            'bhim upi': SMSCategory.mobileMoney,
            'upi': SMSCategory.mobileMoney,
            'send money': SMSCategory.mobileMoney,
            'receive money': SMSCategory.mobileMoney,
            'payment': SMSCategory.mobileMoney,
            'wallet': SMSCategory.mobileMoney,
          },
          'utilities': {
            'bses': SMSCategory.utilities,
            'tata power': SMSCategory.utilities,
            'adani electricity': SMSCategory.utilities,
            'mseb': SMSCategory.utilities,
            'electricity': SMSCategory.utilities,
            'bill': SMSCategory.utilities,
            'meter': SMSCategory.utilities,
            'units': SMSCategory.utilities,
          },
        };
        
      default: // Ghana and others
        return {
          'telecom': {
            'airtime': SMSCategory.telecom,
            'data': SMSCategory.telecom,
            'bundle': SMSCategory.telecom,
            'balance': SMSCategory.telecom,
            'credit': SMSCategory.telecom,
            'mtn': SMSCategory.telecom,
            'vodafone': SMSCategory.telecom,
            'airtel': SMSCategory.telecom,
            'glo': SMSCategory.telecom,
            'network': SMSCategory.telecom,
            'sim': SMSCategory.telecom,
            'recharge': SMSCategory.telecom,
            'subscription': SMSCategory.telecom,
          },
          'banking': {
            'gcb bank': SMSCategory.banking,
            'absa bank': SMSCategory.banking,
            'fidelity bank': SMSCategory.banking,
            'zenith bank': SMSCategory.banking,
            'access bank': SMSCategory.banking,
            'stanbic bank': SMSCategory.banking,
            'gtbank': SMSCategory.banking,
            'first bank': SMSCategory.banking,
            'ecobank': SMSCategory.banking,
            'account': SMSCategory.banking,
            'transaction': SMSCategory.banking,
            'transfer': SMSCategory.banking,
            'payment': SMSCategory.banking,
            'debit': SMSCategory.banking,
            'credit': SMSCategory.banking,
            'atm': SMSCategory.banking,
            'card': SMSCategory.banking,
          },
          'mobile_money': {
            'mtn mobile money': SMSCategory.mobileMoney,
            'vodafone cash': SMSCategory.mobileMoney,
            'airtel money': SMSCategory.mobileMoney,
            'tigo cash': SMSCategory.mobileMoney,
            'send money': SMSCategory.mobileMoney,
            'receive money': SMSCategory.mobileMoney,
            'cash out': SMSCategory.mobileMoney,
            'cash in': SMSCategory.mobileMoney,
          },
          'utilities': {
            'ecg': SMSCategory.utilities,
            'gwc': SMSCategory.utilities,
            'grdc': SMSCategory.utilities,
            'electricity': SMSCategory.utilities,
            'water': SMSCategory.utilities,
            'gas': SMSCategory.utilities,
            'bill': SMSCategory.utilities,
            'meter': SMSCategory.utilities,
            'units': SMSCategory.utilities,
          },
        };
    }
  }

  static const Map<String, SMSCategory> _categoryKeywords = {
    // Telecom keywords
    'airtime': SMSCategory.telecom,
    'data': SMSCategory.telecom,
    'bundle': SMSCategory.telecom,
    'balance': SMSCategory.telecom,
    'credit': SMSCategory.telecom,
    'mtn': SMSCategory.telecom,
    'vodafone': SMSCategory.telecom,
    'airtel': SMSCategory.telecom,
    'glo': SMSCategory.telecom,
    'network': SMSCategory.telecom,
    'sim': SMSCategory.telecom,
    'recharge': SMSCategory.telecom,
    'subscription': SMSCategory.telecom,
    
    // Banking keywords
    'account': SMSCategory.banking,
    'bank': SMSCategory.banking,
    'transaction': SMSCategory.banking,
    'deposit': SMSCategory.banking,
    'withdrawal': SMSCategory.banking,
    'transfer': SMSCategory.banking,
    'payment': SMSCategory.banking,
    'debit': SMSCategory.banking,
    'bank_credit': SMSCategory.banking,
    'bank_balance': SMSCategory.banking,
    'atm': SMSCategory.banking,
    'card': SMSCategory.banking,
    'loan': SMSCategory.banking,
    'interest': SMSCategory.banking,
    
    // Utilities keywords
    'electricity': SMSCategory.utilities,
    'water': SMSCategory.utilities,
    'gas': SMSCategory.utilities,
    'bill': SMSCategory.utilities,
    'utility_payment': SMSCategory.utilities,
    'meter': SMSCategory.utilities,
    'units': SMSCategory.utilities,
    'consumption': SMSCategory.utilities,
    'ecg': SMSCategory.utilities,
    'gwc': SMSCategory.utilities,
    'grdc': SMSCategory.utilities,
    
    // Mobile Money keywords
    'mobile money': SMSCategory.mobileMoney,
    'momo': SMSCategory.mobileMoney,
    'mtn momo': SMSCategory.mobileMoney,
    'vodafone cash': SMSCategory.mobileMoney,
    'airtel money': SMSCategory.mobileMoney,
    'tigo cash': SMSCategory.mobileMoney,
    'send money': SMSCategory.mobileMoney,
    'receive money': SMSCategory.mobileMoney,
    'cash out': SMSCategory.mobileMoney,
    'cash in': SMSCategory.mobileMoney,
    
    // Promotional keywords
    'offer': SMSCategory.promotional,
    'promo': SMSCategory.promotional,
    'discount': SMSCategory.promotional,
    'sale': SMSCategory.promotional,
    'win': SMSCategory.promotional,
    'prize': SMSCategory.promotional,
    'competition': SMSCategory.promotional,
    'contest': SMSCategory.promotional,
    'free': SMSCategory.promotional,
    'bonus': SMSCategory.promotional,
  };

  // Base provider patterns that work across countries
  static const Map<String, String> _baseProviderPatterns = {
    'mtn': 'MTN',
    'vodafone': 'Vodafone',
    'airtel': 'Airtel',
    'glo': 'Globacom',
    'tigo': 'Tigo',
    'safaricom': 'Safaricom',
    'jio': 'Jio',
    'verizon': 'Verizon',
    'att': 'AT&T',
    'tmobile': 'T-Mobile',
    'sprint': 'Sprint',
    'boost': 'Boost Mobile',
    'cricket': 'Cricket Wireless',
    'metro': 'Metro by T-Mobile',
    'telkom': 'Telkom',
    'cellc': 'Cell C',
    'halotel': 'Halotel',
    '9mobile': '9mobile',
    'bsnl': 'BSNL',
    'vodafone idea': 'Vodafone Idea',
  };

  static Map<String, String> _getProviderPatternsForCountry(String country) {
    final config = CountryConfigService.getCountryConfig(country);
    final patterns = Map<String, String>.from(_baseProviderPatterns);
    
    // Add country-specific banking providers
    for (final provider in config.bankingProviders) {
      final key = provider.toLowerCase().replaceAll(' ', '').replaceAll('bank', '');
      patterns[key] = provider;
    }
    
    // Add country-specific mobile money providers
    for (final provider in config.mobileMoneyProviders) {
      final key = provider.toLowerCase().replaceAll(' ', '').replaceAll('mobile', '').replaceAll('money', '');
      patterns[key] = provider;
    }
    
    // Add country-specific utility providers
    for (final provider in config.utilityProviders) {
      final key = provider.toLowerCase().replaceAll(' ', '');
      patterns[key] = provider;
    }
    
    return patterns;
  }

  static SMSCategory categorizeMessage(String content, {String? country}) {
    final lowerContent = content.toLowerCase();
    
    // ALWAYS use country-specific keywords if country is provided
    // This ensures SMS from any country gets categorized using the selected country's patterns
    if (country != null) {
      final countryKeywords = _getCountryKeywords(country);
      final categoryScores = <SMSCategory, int>{};
      
      // Check all category types for the country
      for (final categoryType in countryKeywords.keys) {
        for (final entry in countryKeywords[categoryType]!.entries) {
          if (lowerContent.contains(entry.key)) {
            categoryScores[entry.value] = (categoryScores[entry.value] ?? 0) + 1;
          }
        }
      }
      
      // If we found matches with country-specific keywords, use them
      if (categoryScores.isNotEmpty) {
        return categoryScores.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
      }
      
      // If no country-specific matches, try to map generic patterns to country context
      return _mapGenericToCountryCategory(lowerContent, country);
    }
    
    // Fallback to generic keywords
    final categoryScores = <SMSCategory, int>{};
    
    for (final entry in _categoryKeywords.entries) {
      if (lowerContent.contains(entry.key)) {
        categoryScores[entry.value] = (categoryScores[entry.value] ?? 0) + 1;
      }
    }
    
    // Return category with highest score, or 'other' if no matches
    if (categoryScores.isEmpty) {
      return SMSCategory.other;
    }
    
    return categoryScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // Map generic SMS patterns to country-specific categories
  static SMSCategory _mapGenericToCountryCategory(String content, String country) {
    // Look for generic patterns and map them to appropriate categories for the country
    if (content.contains('balance') || content.contains('airtime') || content.contains('data') || 
        content.contains('credit') || content.contains('recharge') || content.contains('bundle')) {
      return SMSCategory.telecom;
    }
    
    if (content.contains('account') || content.contains('transaction') || content.contains('transfer') || 
        content.contains('payment') || content.contains('debit') || content.contains('credit') ||
        content.contains('atm') || content.contains('card') || content.contains('bank')) {
      return SMSCategory.banking;
    }
    
    if (content.contains('send money') || content.contains('receive money') || content.contains('cash') ||
        content.contains('mobile money') || content.contains('wallet') || content.contains('momo')) {
      return SMSCategory.mobileMoney;
    }
    
    if (content.contains('electricity') || content.contains('water') || content.contains('bill') ||
        content.contains('meter') || content.contains('units') || content.contains('utility')) {
      return SMSCategory.utilities;
    }
    
    if (content.contains('offer') || content.contains('promo') || content.contains('discount') ||
        content.contains('sale') || content.contains('win') || content.contains('prize') ||
        content.contains('free') || content.contains('bonus')) {
      return SMSCategory.promotional;
    }
    
    return SMSCategory.other;
  }

  static String detectProvider(String content, String sender, {String? country}) {
    final lowerContent = content.toLowerCase();
    final lowerSender = sender.toLowerCase();
    
    // ALWAYS use country-specific providers if country is provided
    // This ensures SMS from any country gets mapped to the selected country's providers
    if (country != null) {
      final providerPatterns = _getProviderPatternsForCountry(country);
      
      // First try to match with country-specific patterns
      for (final entry in providerPatterns.entries) {
        if (lowerContent.contains(entry.key) || lowerSender.contains(entry.key)) {
          return entry.value;
        }
      }
      
      // If no direct match, try to map generic patterns to country providers
      return _mapGenericToCountryProvider(lowerContent, lowerSender, country);
    }
    
    // Fallback to base patterns
    for (final entry in _baseProviderPatterns.entries) {
      if (lowerContent.contains(entry.key) || lowerSender.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return 'Unknown';
  }

  // Map generic SMS patterns to country-specific providers
  static String _mapGenericToCountryProvider(String content, String sender, String country) {
    final config = CountryConfigService.getCountryConfig(country);
    
    // Map generic patterns to country-specific providers
    if (content.contains('balance') || content.contains('airtime') || content.contains('data') || 
        content.contains('credit') || content.contains('recharge') || content.contains('bundle')) {
      // Return first telecom provider for the country
      return config.telecomProviders.isNotEmpty ? config.telecomProviders.first : 'Telecom Provider';
    }
    
    if (content.contains('account') || content.contains('transaction') || content.contains('transfer') || 
        content.contains('payment') || content.contains('debit') || content.contains('credit') ||
        content.contains('atm') || content.contains('card') || content.contains('bank')) {
      // Return first banking provider for the country
      return config.bankingProviders.isNotEmpty ? config.bankingProviders.first : 'Bank';
    }
    
    if (content.contains('send money') || content.contains('receive money') || content.contains('cash') ||
        content.contains('mobile money') || content.contains('wallet') || content.contains('momo')) {
      // Return first mobile money provider for the country
      return config.mobileMoneyProviders.isNotEmpty ? config.mobileMoneyProviders.first : 'Mobile Money';
    }
    
    if (content.contains('electricity') || content.contains('water') || content.contains('bill') ||
        content.contains('meter') || content.contains('units') || content.contains('utility')) {
      // Return first utility provider for the country
      return config.utilityProviders.isNotEmpty ? config.utilityProviders.first : 'Utility Provider';
    }
    
    // Default to first telecom provider if no specific match
    return config.telecomProviders.isNotEmpty ? config.telecomProviders.first : 'Provider';
  }

  static double calculateCost(String content, String provider, {String? country}) {
    // Base cost varies by country (approximate SMS costs)
    final baseCosts = {
      'Ghana': 0.05,
      'Nigeria': 4.0,
      'Kenya': 1.0,
      'Tanzania': 20.0,
      'Uganda': 100.0,
      'South Africa': 0.50,
      'Rwanda': 5.0,
      'India': 0.15,
      'USA': 0.10,
    };
    
    final baseCost = baseCosts[country ?? 'Ghana'] ?? 0.05;
    final lengthMultiplier = content.length / 160.0; // SMS length factor
    final providerMultiplier = _getProviderMultiplier(provider);
    
    return baseCost * lengthMultiplier * providerMultiplier;
  }

  static double _getProviderMultiplier(String provider) {
    switch (provider.toLowerCase()) {
      case 'mtn':
        return 1.0;
      case 'vodafone':
        return 0.9;
      case 'airtel':
        return 0.8;
      case 'glo':
        return 0.85;
      default:
        return 1.0;
    }
  }

  static List<String> generateSmartSuggestions(String content, SMSCategory category, {String? country}) {
    final suggestions = <String>[];
    
    // Country-specific suggestions
    if (country != null) {
      switch (country) {
        case 'Nigeria':
          switch (category) {
            case SMSCategory.telecom:
              suggestions.addAll([
                'Check your data balance',
                'Recharge with airtime',
                'Subscribe to data bundle',
                'Check network coverage',
              ]);
              break;
            case SMSCategory.banking:
              suggestions.addAll([
                'Check account balance',
                'Transfer money via GTBank',
                'Pay bills online',
                'Set up alerts',
              ]);
              break;
            case SMSCategory.mobileMoney:
              suggestions.addAll([
                'Send money via OPay',
                'Cash out at agent',
                'Pay for services',
                'Check transaction history',
              ]);
              break;
            case SMSCategory.utilities:
              suggestions.addAll([
                'Pay electricity bill',
                'Check meter reading',
                'Report outage',
                'Set up auto-pay',
              ]);
              break;
            default:
              suggestions.addAll([
                'Reply to message',
                'Save to contacts',
                'Mark as important',
                'Delete message',
              ]);
          }
          break;
          
        case 'Kenya':
          switch (category) {
            case SMSCategory.telecom:
              suggestions.addAll([
                'Check your data balance',
                'Recharge with airtime',
                'Subscribe to data bundle',
                'Check Safaricom coverage',
              ]);
              break;
            case SMSCategory.banking:
              suggestions.addAll([
                'Check account balance',
                'Transfer money via Equity Bank',
                'Pay bills online',
                'Set up alerts',
              ]);
              break;
            case SMSCategory.mobileMoney:
              suggestions.addAll([
                'Send money via M-Pesa',
                'Cash out at agent',
                'Pay for services',
                'Check transaction history',
              ]);
              break;
            case SMSCategory.utilities:
              suggestions.addAll([
                'Pay electricity bill',
                'Check meter reading',
                'Report outage',
                'Set up auto-pay',
              ]);
              break;
            default:
              suggestions.addAll([
                'Reply to message',
                'Save to contacts',
                'Mark as important',
                'Delete message',
              ]);
          }
          break;
          
        case 'USA':
          switch (category) {
            case SMSCategory.telecom:
              suggestions.addAll([
                'Check your data usage',
                'Upgrade your plan',
                'Check coverage',
                'Contact customer service',
              ]);
              break;
            case SMSCategory.banking:
              suggestions.addAll([
                'Check account balance',
                'Transfer money',
                'Pay bills online',
                'Set up alerts',
              ]);
              break;
            case SMSCategory.mobileMoney:
              suggestions.addAll([
                'Send money via Venmo',
                'Pay with Apple Pay',
                'Use Zelle for transfers',
                'Check transaction history',
              ]);
              break;
            case SMSCategory.utilities:
              suggestions.addAll([
                'Pay electricity bill',
                'Check usage',
                'Report outage',
                'Set up auto-pay',
              ]);
              break;
            default:
              suggestions.addAll([
                'Reply to message',
                'Save to contacts',
                'Mark as important',
                'Delete message',
              ]);
          }
          break;
          
        case 'India':
          switch (category) {
            case SMSCategory.telecom:
              suggestions.addAll([
                'Check your data balance',
                'Recharge with airtime',
                'Subscribe to data bundle',
                'Check Jio coverage',
              ]);
              break;
            case SMSCategory.banking:
              suggestions.addAll([
                'Check account balance',
                'Transfer money via UPI',
                'Pay bills online',
                'Set up alerts',
              ]);
              break;
            case SMSCategory.mobileMoney:
              suggestions.addAll([
                'Send money via Paytm',
                'Use PhonePe',
                'Pay with Google Pay',
                'Check transaction history',
              ]);
              break;
            case SMSCategory.utilities:
              suggestions.addAll([
                'Pay electricity bill',
                'Check meter reading',
                'Report outage',
                'Set up auto-pay',
              ]);
              break;
            default:
              suggestions.addAll([
                'Reply to message',
                'Save to contacts',
                'Mark as important',
                'Delete message',
              ]);
          }
          break;
          
        default: // Ghana and others
          switch (category) {
            case SMSCategory.telecom:
              suggestions.addAll([
                'Check your data balance',
                'Recharge with airtime',
                'Subscribe to data bundle',
                'Check network coverage',
              ]);
              break;
            case SMSCategory.banking:
              suggestions.addAll([
                'Check account balance',
                'Transfer money',
                'Pay bills online',
                'Set up alerts',
              ]);
              break;
            case SMSCategory.mobileMoney:
              suggestions.addAll([
                'Send money to contact',
                'Cash out at agent',
                'Pay for services',
                'Check transaction history',
              ]);
              break;
            case SMSCategory.utilities:
              suggestions.addAll([
                'Pay electricity bill',
                'Check meter reading',
                'Report outage',
                'Set up auto-pay',
              ]);
              break;
            default:
              suggestions.addAll([
                'Reply to message',
                'Save to contacts',
                'Mark as important',
                'Delete message',
              ]);
          }
      }
    } else {
      // Generic suggestions
      switch (category) {
        case SMSCategory.telecom:
          suggestions.addAll([
            'Check your data balance',
            'Recharge with airtime',
            'Subscribe to data bundle',
            'Check network coverage',
          ]);
          break;
        case SMSCategory.banking:
          suggestions.addAll([
            'Check account balance',
            'Transfer money',
            'Pay bills online',
            'Set up alerts',
          ]);
          break;
        case SMSCategory.utilities:
          suggestions.addAll([
            'Pay electricity bill',
            'Check meter reading',
            'Report outage',
            'Set up auto-pay',
          ]);
          break;
        case SMSCategory.mobileMoney:
          suggestions.addAll([
            'Send money to contact',
            'Cash out at agent',
            'Pay for services',
            'Check transaction history',
          ]);
          break;
        default:
          suggestions.addAll([
            'Reply to message',
            'Save to contacts',
            'Mark as important',
            'Delete message',
          ]);
      }
    }
    
    return suggestions;
  }

  static String generateSummary(List<SMSMessage> messages, {String? country}) {
    if (messages.isEmpty) return 'No messages to summarize';
    
    final config = country != null 
        ? CountryConfigService.getCountryConfig(country)
        : CountryConfigService.getCountryConfig('Ghana');
    
    final categoryCounts = <SMSCategory, int>{};
    final totalCost = messages.fold<double>(0.0, (sum, msg) => sum + msg.cost);
    
    for (final message in messages) {
      categoryCounts[message.category] = (categoryCounts[message.category] ?? 0) + 1;
    }
    
    final topCategory = categoryCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    
    return 'You have ${messages.length} messages with a total cost of ${config.currencySymbol} ${totalCost.toStringAsFixed(2)}. '
           'Most messages are from ${topCategory.key.displayName} (${topCategory.value} messages).';
  }

  static List<SMSMessage> groupRelatedMessages(List<SMSMessage> messages) {
    final grouped = <String, List<SMSMessage>>{};
    
    for (final message in messages) {
      final key = '${message.category.name}_${message.provider}';
      grouped[key] = grouped[key] ?? [];
      grouped[key]!.add(message);
    }
    
    return grouped.values.expand((group) => group).toList();
  }
}
