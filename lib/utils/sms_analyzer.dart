import '../models/sms_model.dart';

class SMSAnalyzer {
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

  static const Map<String, String> _providerPatterns = {
    'mtn': 'MTN',
    'vodafone': 'Vodafone',
    'airtel': 'Airtel',
    'glo': 'Globacom',
    'tigo': 'Tigo',
    'ecg': 'ECG',
    'gwc': 'GWC',
    'grdc': 'GRDC',
    'gcb': 'GCB Bank',
    'absa': 'Absa Bank',
    'fidelity': 'Fidelity Bank',
    'zenith': 'Zenith Bank',
    'access': 'Access Bank',
    'stanbic': 'Stanbic Bank',
    'gtb': 'GTBank',
    'first': 'First Bank',
    'ecobank': 'Ecobank',
    'cal': 'CAL Bank',
    'republic': 'Republic Bank',
    'agric': 'Agricultural Development Bank',
  };

  static SMSCategory categorizeMessage(String content) {
    final lowerContent = content.toLowerCase();
    
    // Count keyword matches for each category
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

  static String detectProvider(String content, String sender) {
    final lowerContent = content.toLowerCase();
    final lowerSender = sender.toLowerCase();
    
    for (final entry in _providerPatterns.entries) {
      if (lowerContent.contains(entry.key) || lowerSender.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return 'Unknown';
  }

  static double calculateCost(String content, String provider) {
    // Simulate cost calculation based on content length and provider
    final baseCost = 0.05; // Base cost in GHS
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

  static List<String> generateSmartSuggestions(String content, SMSCategory category) {
    final suggestions = <String>[];
    
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
    
    return suggestions;
  }

  static String generateSummary(List<SMSMessage> messages) {
    if (messages.isEmpty) return 'No messages to summarize';
    
    final categoryCounts = <SMSCategory, int>{};
    final totalCost = messages.fold<double>(0.0, (sum, msg) => sum + msg.cost);
    
    for (final message in messages) {
      categoryCounts[message.category] = (categoryCounts[message.category] ?? 0) + 1;
    }
    
    final topCategory = categoryCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    
    return 'You have ${messages.length} messages with a total cost of GHS ${totalCost.toStringAsFixed(2)}. '
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
