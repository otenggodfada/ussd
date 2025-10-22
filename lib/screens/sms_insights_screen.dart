import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_plus/models/sms_model.dart';
import 'package:ussd_plus/models/activity_model.dart';
import 'package:ussd_plus/utils/sms_analyzer.dart';
import 'package:ussd_plus/utils/activity_service.dart';
import 'package:ussd_plus/utils/country_config_service.dart';
import 'package:ussd_plus/utils/ussd_data_service.dart';
import 'package:ussd_plus/widgets/sms_category_card.dart';
import 'package:ussd_plus/widgets/sms_message_card.dart';
import 'package:ussd_plus/utils/admob_service.dart';
import 'package:ussd_plus/utils/premium_features_service.dart';
import 'package:ussd_plus/screens/settings_screen.dart';

class SMSInsightsScreen extends StatefulWidget {
  const SMSInsightsScreen({super.key});

  @override
  State<SMSInsightsScreen> createState() => _SMSInsightsScreenState();
}

class _SMSInsightsScreenState extends State<SMSInsightsScreen> {
  List<SMSMessage> _messages = [];
  SMSCostSummary? _costSummary;
  bool _isLoading = true;
  bool _isPremiumActive = false;
  String _selectedCountry = 'Ghana';
  CountryConfig? _countryConfig;

  @override
  void initState() {
    super.initState();
    _loadCountryConfig();
    _loadSMSData();
    _checkPremiumStatus();
    _showInterstitialAdIfReady();
  }

  Future<void> _loadCountryConfig() async {
    final country = await USSDDataService.getSelectedCountry();
    final config = CountryConfigService.getCountryConfig(country);
    setState(() {
      _selectedCountry = country;
      _countryConfig = config;
    });
  }

  Future<void> _checkPremiumStatus() async {
    final isActive = await PremiumFeaturesService.isFeatureActive(PremiumFeature.showAllSMSWeek);
    setState(() {
      _isPremiumActive = isActive;
    });
  }

  void _showInterstitialAdIfReady() {
    // Show interstitial ad when entering SMS insights
    Future.delayed(const Duration(seconds: 1), () {
      AdMobService.showInterstitialAdIfReady();
    });
  }

  void _loadSMSData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<SMSMessage> messages = [];
      
      if (Platform.isAndroid) {
        messages = await _readSMSFromDevice();
        // Convert all SMS to use selected country's context
        messages = _convertSMSToCountryContext(messages);
      } else {
        // For iOS or other platforms, show sample data
        messages = _generateSampleMessages();
      }
      
      setState(() {
        _messages = messages;
        _costSummary = _calculateCostSummary(_messages);
        _isLoading = false;
      });
      
        // Log SMS analysis activity
        if (messages.isNotEmpty) {
          await ActivityService.logActivity(
            type: ActivityType.smsAnalyzed,
            title: 'Analyzed ${messages.length} SMS messages',
            description: 'Total cost: ${_countryConfig?.currencySymbol ?? 'GHS'} ${_costSummary?.totalCost.toStringAsFixed(2) ?? '0.00'}',
            metadata: {'messageCount': messages.length, 'totalCost': _costSummary?.totalCost},
          );
        }
    } catch (e) {
      setState(() {
        _messages = _generateSampleMessages(); // This already uses selected country
        _costSummary = _calculateCostSummary(_messages);
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not read SMS: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<List<SMSMessage>> _readSMSFromDevice() async {
    const platform = MethodChannel('ussd_plus/sms');
    
    try {
      final List<dynamic> smsData = await platform.invokeMethod('getSMS');
      
      return smsData.map((sms) {
        final Map<String, dynamic> smsMap = Map<String, dynamic>.from(sms);
        
        // Analyze the SMS content to determine category and provider
        final content = smsMap['body'] ?? '';
        final sender = smsMap['address'] ?? '';
        final timestamp = DateTime.fromMillisecondsSinceEpoch(
          int.parse(smsMap['date'] ?? '0')
        );
        
        final category = SMSAnalyzer.categorizeMessage(content, country: _selectedCountry);
        final provider = SMSAnalyzer.detectProvider(content, sender, country: _selectedCountry);
        final cost = SMSAnalyzer.calculateCost(content, provider, country: _selectedCountry);
        
        return SMSMessage(
          id: smsMap['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          sender: sender,
          content: content,
          timestamp: timestamp,
          category: category,
          cost: cost,
          provider: provider,
        );
      }).toList();
    } catch (e) {
      print('Error reading SMS: $e');
      return _generateSampleMessages();
    }
  }

  List<SMSMessage> _convertSMSToCountryContext(List<SMSMessage> messages) {
    // Convert all SMS messages to use the selected country's context
    return messages.map((message) {
      // Re-analyze the message using the selected country's patterns
      final category = SMSAnalyzer.categorizeMessage(message.content, country: _selectedCountry);
      final provider = SMSAnalyzer.detectProvider(message.content, message.sender, country: _selectedCountry);
      final cost = SMSAnalyzer.calculateCost(message.content, provider, country: _selectedCountry);
      
      // Convert the SMS content to use selected country's currency
      final convertedContent = _convertContentToCountryCurrency(message.content);
      
      return SMSMessage(
        id: message.id,
        sender: provider, // Use the country-specific provider instead of original sender
        content: convertedContent, // Use converted content with selected country's currency
        timestamp: message.timestamp,
        category: category,
        cost: cost,
        provider: provider,
      );
    }).toList();
  }

  String _convertContentToCountryCurrency(String content) {
    final config = _countryConfig ?? CountryConfigService.getCountryConfig(_selectedCountry);
    final targetCurrency = config.currencySymbol;
    
    // Convert common currency patterns to selected country's currency
    String convertedContent = content;
    
    // Convert GHS to target currency
    convertedContent = convertedContent.replaceAll(RegExp(r'GHS\s*(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    
    // Convert NGN to target currency
    convertedContent = convertedContent.replaceAll(RegExp(r'NGN\s*(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    
    // Convert KES to target currency
    convertedContent = convertedContent.replaceAll(RegExp(r'KES\s*(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    
    // Convert USD to target currency
    convertedContent = convertedContent.replaceAll(RegExp(r'USD\s*(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    
    // Convert INR to target currency
    convertedContent = convertedContent.replaceAll(RegExp(r'INR\s*(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    
    // Convert other currencies
    convertedContent = convertedContent.replaceAll(RegExp(r'TZS\s*(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    convertedContent = convertedContent.replaceAll(RegExp(r'UGX\s*(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    convertedContent = convertedContent.replaceAll(RegExp(r'ZAR\s*(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    convertedContent = convertedContent.replaceAll(RegExp(r'RWF\s*(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    
    // Convert currency symbols
    convertedContent = convertedContent.replaceAll(RegExp(r'\$(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    convertedContent = convertedContent.replaceAll(RegExp(r'₹(\d+(?:\.\d{2})?)', caseSensitive: false), '$targetCurrency \$1');
    
    return convertedContent;
  }

  List<SMSMessage> _generateSampleMessages() {
    final now = DateTime.now();
    
    // ALWAYS generate sample data for the selected country, regardless of actual SMS content
    switch (_selectedCountry) {
      case 'Nigeria':
        return [
          SMSMessage(
            id: '1',
            sender: 'MTN',
            content: 'Your airtime balance is NGN 1,500.00. Valid until 2024-01-15',
            timestamp: now.subtract(const Duration(hours: 2)),
            category: SMSCategory.telecom,
            cost: 4.0,
            provider: 'MTN',
          ),
          SMSMessage(
            id: '2',
            sender: 'GTBank',
            content: 'Transaction Alert: NGN 50,000.00 debited from your account. Balance: NGN 245,000.00',
            timestamp: now.subtract(const Duration(hours: 4)),
            category: SMSCategory.banking,
            cost: 4.0,
            provider: 'GTBank',
          ),
          SMSMessage(
            id: '3',
            sender: 'EKEDC',
            content: 'Your electricity bill of NGN 12,050.00 is due on 2024-01-20. Pay via *737#',
            timestamp: now.subtract(const Duration(days: 1)),
            category: SMSCategory.utilities,
            cost: 4.0,
            provider: 'EKEDC',
          ),
          SMSMessage(
            id: '4',
            sender: 'OPay',
            content: 'You received NGN 10,000.00 from John Doe. New balance: NGN 25,000.00',
            timestamp: now.subtract(const Duration(days: 2)),
            category: SMSCategory.mobileMoney,
            cost: 4.0,
            provider: 'OPay',
          ),
          SMSMessage(
            id: '5',
            sender: 'Airtel',
            content: 'Special offer! Get 2GB data for NGN 1,000. Valid for 7 days. Dial *141#',
            timestamp: now.subtract(const Duration(days: 3)),
            category: SMSCategory.promotional,
            cost: 4.0,
            provider: 'Airtel',
          ),
        ];
        
      case 'Kenya':
        return [
          SMSMessage(
            id: '1',
            sender: 'Safaricom',
            content: 'Your airtime balance is KES 150.00. Valid until 2024-01-15',
            timestamp: now.subtract(const Duration(hours: 2)),
            category: SMSCategory.telecom,
            cost: 1.0,
            provider: 'Safaricom',
          ),
          SMSMessage(
            id: '2',
            sender: 'Equity Bank',
            content: 'Transaction Alert: KES 5,000.00 debited from your account. Balance: KES 24,500.00',
            timestamp: now.subtract(const Duration(hours: 4)),
            category: SMSCategory.banking,
            cost: 1.0,
            provider: 'Equity Bank',
          ),
          SMSMessage(
            id: '3',
            sender: 'Kenya Power',
            content: 'Your electricity bill of KES 1,205.00 is due on 2024-01-20. Pay via M-Pesa',
            timestamp: now.subtract(const Duration(days: 1)),
            category: SMSCategory.utilities,
            cost: 1.0,
            provider: 'Kenya Power',
          ),
          SMSMessage(
            id: '4',
            sender: 'M-Pesa',
            content: 'You received KES 1,000.00 from John Doe. New balance: KES 2,500.00',
            timestamp: now.subtract(const Duration(days: 2)),
            category: SMSCategory.mobileMoney,
            cost: 1.0,
            provider: 'M-Pesa',
          ),
          SMSMessage(
            id: '5',
            sender: 'Airtel',
            content: 'Special offer! Get 2GB data for KES 100. Valid for 7 days. Dial *544#',
            timestamp: now.subtract(const Duration(days: 3)),
            category: SMSCategory.promotional,
            cost: 1.0,
            provider: 'Airtel',
          ),
        ];
        
      case 'USA':
        return [
          SMSMessage(
            id: '1',
            sender: 'AT&T',
            content: 'Your account balance is \$45.50. Data remaining: 2.3GB',
            timestamp: now.subtract(const Duration(hours: 2)),
            category: SMSCategory.telecom,
            cost: 0.10,
            provider: 'AT&T',
          ),
          SMSMessage(
            id: '2',
            sender: 'Chase Bank',
            content: 'Transaction Alert: \$500.00 debited from your account. Balance: \$2,450.00',
            timestamp: now.subtract(const Duration(hours: 4)),
            category: SMSCategory.banking,
            cost: 0.10,
            provider: 'Chase Bank',
          ),
          SMSMessage(
            id: '3',
            sender: 'ConEd',
            content: 'Your electricity bill of \$120.50 is due on 2024-01-20. Pay online',
            timestamp: now.subtract(const Duration(days: 1)),
            category: SMSCategory.utilities,
            cost: 0.10,
            provider: 'ConEd',
          ),
          SMSMessage(
            id: '4',
            sender: 'Venmo',
            content: 'You received \$100.00 from John Doe. New balance: \$250.00',
            timestamp: now.subtract(const Duration(days: 2)),
            category: SMSCategory.mobileMoney,
            cost: 0.10,
            provider: 'Venmo',
          ),
          SMSMessage(
            id: '5',
            sender: 'T-Mobile',
            content: 'Special offer! Get unlimited data for \$50/month. Valid for 7 days',
            timestamp: now.subtract(const Duration(days: 3)),
            category: SMSCategory.promotional,
            cost: 0.10,
            provider: 'T-Mobile',
          ),
        ];
        
      case 'India':
        return [
          SMSMessage(
            id: '1',
            sender: 'Airtel',
            content: 'Your airtime balance is ₹150.00. Data remaining: 2.3GB',
            timestamp: now.subtract(const Duration(hours: 2)),
            category: SMSCategory.telecom,
            cost: 0.15,
            provider: 'Airtel',
          ),
          SMSMessage(
            id: '2',
            sender: 'SBI',
            content: 'Transaction Alert: ₹5,000.00 debited from your account. Balance: ₹24,500.00',
            timestamp: now.subtract(const Duration(hours: 4)),
            category: SMSCategory.banking,
            cost: 0.15,
            provider: 'SBI',
          ),
          SMSMessage(
            id: '3',
            sender: 'BSES',
            content: 'Your electricity bill of ₹1,205.00 is due on 2024-01-20. Pay via UPI',
            timestamp: now.subtract(const Duration(days: 1)),
            category: SMSCategory.utilities,
            cost: 0.15,
            provider: 'BSES',
          ),
          SMSMessage(
            id: '4',
            sender: 'Paytm',
            content: 'You received ₹1,000.00 from John Doe. New balance: ₹2,500.00',
            timestamp: now.subtract(const Duration(days: 2)),
            category: SMSCategory.mobileMoney,
            cost: 0.15,
            provider: 'Paytm',
          ),
          SMSMessage(
            id: '5',
            sender: 'Jio',
            content: 'Special offer! Get 2GB data for ₹100. Valid for 7 days',
            timestamp: now.subtract(const Duration(days: 3)),
            category: SMSCategory.promotional,
            cost: 0.15,
            provider: 'Jio',
          ),
        ];
        
      default: // Ghana and others
        return [
          SMSMessage(
            id: '1',
            sender: 'MTN',
            content: 'Your airtime balance is GHS 15.50. Valid until 2024-01-15',
            timestamp: now.subtract(const Duration(hours: 2)),
            category: SMSCategory.telecom,
            cost: 0.05,
            provider: 'MTN',
          ),
          SMSMessage(
            id: '2',
            sender: 'GCB Bank',
            content: 'Transaction Alert: GHS 500.00 debited from your account. Balance: GHS 2,450.00',
            timestamp: now.subtract(const Duration(hours: 4)),
            category: SMSCategory.banking,
            cost: 0.05,
            provider: 'GCB Bank',
          ),
          SMSMessage(
            id: '3',
            sender: 'ECG',
            content: 'Your electricity bill of GHS 120.50 is due on 2024-01-20. Pay via *713*33#',
            timestamp: now.subtract(const Duration(days: 1)),
            category: SMSCategory.utilities,
            cost: 0.05,
            provider: 'ECG',
          ),
          SMSMessage(
            id: '4',
            sender: 'MTN Mobile Money',
            content: 'You received GHS 100.00 from John Doe. New balance: GHS 250.00',
            timestamp: now.subtract(const Duration(days: 2)),
            category: SMSCategory.mobileMoney,
            cost: 0.05,
            provider: 'MTN',
          ),
          SMSMessage(
            id: '5',
            sender: 'Vodafone',
            content: 'Special offer! Get 2GB data for GHS 10. Valid for 7 days. Dial *110*2#',
            timestamp: now.subtract(const Duration(days: 3)),
            category: SMSCategory.promotional,
            cost: 0.05,
            provider: 'Vodafone',
          ),
        ];
    }
  }

  SMSCostSummary _calculateCostSummary(List<SMSMessage> messages) {
    final costByCategory = <SMSCategory, double>{};
    final expenseByCategory = <SMSCategory, double>{};
    final revenueByCategory = <SMSCategory, double>{};
    final messagesByCategory = <SMSCategory, int>{};
    double totalCost = 0.0;
    double totalExpenses = 0.0;
    double totalRevenue = 0.0;

    for (final message in messages) {
      final category = message.category;
      final messageCost = message.cost;
      final messageAmount = _extractAmountFromMessage(message.content);
      
      // Calculate basic SMS cost
      costByCategory[category] = (costByCategory[category] ?? 0.0) + messageCost;
      messagesByCategory[category] = (messagesByCategory[category] ?? 0) + 1;
      totalCost += messageCost;
      
      // Calculate expenses and revenue based on message content
      if (messageAmount > 0) {
        if (_isExpenseMessage(message)) {
          expenseByCategory[category] = (expenseByCategory[category] ?? 0.0) + messageAmount;
          totalExpenses += messageAmount;
        } else if (_isRevenueMessage(message)) {
          revenueByCategory[category] = (revenueByCategory[category] ?? 0.0) + messageAmount;
          totalRevenue += messageAmount;
        }
      }
    }

    return SMSCostSummary(
      totalCost: totalCost,
      costByCategory: costByCategory,
      totalMessages: messages.length,
      messagesByCategory: messagesByCategory,
      periodStart: DateTime.now().subtract(const Duration(days: 30)),
      periodEnd: DateTime.now(),
      expenseByCategory: expenseByCategory,
      revenueByCategory: revenueByCategory,
      totalExpenses: totalExpenses,
      totalRevenue: totalRevenue,
    );
  }

  double _extractAmountFromMessage(String content) {
    // Look for currency symbol amounts in the message (like $, ₹)
    final symbolPattern = RegExp(r'\$(\d+(?:\.\d{2})?)', caseSensitive: false);
    final symbolMatch = symbolPattern.firstMatch(content);
    
    if (symbolMatch != null) {
      return double.tryParse(symbolMatch.group(1) ?? '0') ?? 0.0;
    }
    
    // Look for generic currency patterns and convert to selected country's currency
    // This ensures we extract amounts even from other countries' SMS
    final genericPatterns = [
      RegExp(r'GHS\s*(\d+(?:\.\d{2})?)', caseSensitive: false), // Ghana
      RegExp(r'NGN\s*(\d+(?:\.\d{2})?)', caseSensitive: false), // Nigeria
      RegExp(r'KES\s*(\d+(?:\.\d{2})?)', caseSensitive: false), // Kenya
      RegExp(r'USD\s*(\d+(?:\.\d{2})?)', caseSensitive: false), // USA
      RegExp(r'INR\s*(\d+(?:\.\d{2})?)', caseSensitive: false), // India
      RegExp(r'TZS\s*(\d+(?:\.\d{2})?)', caseSensitive: false), // Tanzania
      RegExp(r'UGX\s*(\d+(?:\.\d{2})?)', caseSensitive: false), // Uganda
      RegExp(r'ZAR\s*(\d+(?:\.\d{2})?)', caseSensitive: false), // South Africa
      RegExp(r'RWF\s*(\d+(?:\.\d{2})?)', caseSensitive: false), // Rwanda
    ];
    
    for (final pattern in genericPatterns) {
      final match = pattern.firstMatch(content);
      if (match != null) {
        return double.tryParse(match.group(1) ?? '0') ?? 0.0;
      }
    }
    
    // Look for other currency patterns based on country
    switch (_selectedCountry) {
      case 'Nigeria':
        final ngnPattern = RegExp(r'(\d+(?:\.\d{2})?)\s*(?:naira|ngn)', caseSensitive: false);
        final ngnMatch = ngnPattern.firstMatch(content);
        if (ngnMatch != null) {
          return double.tryParse(ngnMatch.group(1) ?? '0') ?? 0.0;
        }
        break;
      case 'Kenya':
        final kesPattern = RegExp(r'(\d+(?:\.\d{2})?)\s*(?:shilling|kes)', caseSensitive: false);
        final kesMatch = kesPattern.firstMatch(content);
        if (kesMatch != null) {
          return double.tryParse(kesMatch.group(1) ?? '0') ?? 0.0;
        }
        break;
      case 'India':
        final inrPattern = RegExp(r'₹(\d+(?:\.\d{2})?)', caseSensitive: false);
        final inrMatch = inrPattern.firstMatch(content);
        if (inrMatch != null) {
          return double.tryParse(inrMatch.group(1) ?? '0') ?? 0.0;
        }
        break;
      case 'Ghana':
        final ghsPattern = RegExp(r'(\d+(?:\.\d{2})?)\s*(?:cedis?|ghs)', caseSensitive: false);
        final ghsMatch = ghsPattern.firstMatch(content);
        if (ghsMatch != null) {
          return double.tryParse(ghsMatch.group(1) ?? '0') ?? 0.0;
        }
        break;
    }
    
    return 0.0;
  }

  bool _isExpenseMessage(SMSMessage message) {
    final content = message.content.toLowerCase();
    
    // First check if this is actually revenue (to avoid false positives)
    // "payment received", "transfer received", etc. should be revenue, not expense
    if (_hasReceiveContext(content)) {
      return false;
    }
    
    // Special case: Money withdrawn FROM savings account = expense
    if (_isSavingsWithdrawal(content)) {
      return true;
    }
    
    // Special case: Money sent TO savings account = revenue (not expense)
    if (_isSavingsDeposit(content)) {
      return false;
    }
    
    // Airtime purchase = expense
    if (content.contains('airtime') && (content.contains('purchase') || content.contains('buy') || content.contains('bought') || content.contains('recharge'))) {
      return true;
    }
    
    // Data purchase = expense
    if (content.contains('data') && (content.contains('purchase') || content.contains('buy') || content.contains('bought') || content.contains('bundle'))) {
      return true;
    }
    
    // Mobile Money specific expense patterns
    if (_isMobileMoneyExpense(content)) {
      return true;
    }
    
    // Keywords that indicate money going out (sent)
    final expenseKeywords = [
      'debited', 'withdrawn', 'spent', 'paid', 'charged', 'deducted',
      'purchase', 'payment', 'bill', 'fee', 'cost', 'expense',
      'sent to', 'transfer to', 'withdrawal', 'buy', 'bought', 'cash out'
    ];
    
    return expenseKeywords.any((keyword) => content.contains(keyword));
  }

  bool _isRevenueMessage(SMSMessage message) {
    final content = message.content.toLowerCase();
    
    // Check if this has "received" context (payment received, transfer received, etc.)
    if (_hasReceiveContext(content)) {
      return true;
    }
    
    // Special case: Money sent TO savings account = revenue
    if (_isSavingsDeposit(content)) {
      return true;
    }
    
    // Special case: Money withdrawn FROM savings account = expense (not revenue)
    if (_isSavingsWithdrawal(content)) {
      return false;
    }
    
    // Keywords that indicate money coming in (received)
    final revenueKeywords = [
      'credited', 'received', 'deposited', 'refund', 'cashback',
      'bonus', 'reward', 'earned', 'income', 'salary', 'wage',
      'deposit', 'credit', 'return'
    ];
    
    return revenueKeywords.any((keyword) => content.contains(keyword));
  }
  
  bool _hasReceiveContext(String content) {
    // Check if the message indicates receiving money
    // This helps avoid false positives like "payment received" being counted as expense
    final receivePatterns = [
      'payment received',
      'transfer received',
      'you received',
      'you have received',
      'received from',
      'credited to',
      'credited with',
      'deposited to',
      'deposited into',
      // Mobile Money specific patterns
      'momo received',
      'mobile money received',
      'cash in from',
      'received ghs',
      'received ghc',
      'you got',
      'money from',
      'sent you',
      'transferred to you',
    ];
    
    return receivePatterns.any((pattern) => content.contains(pattern));
  }
  
  bool _isSavingsDeposit(String content) {
    // Check if message is about money sent TO savings
    final savingsDepositPatterns = [
      'sent to savings',
      'transfer to savings',
      'transferred to savings',
      'deposit to savings',
      'deposited to savings',
      'saved to savings',
      'moved to savings',
      'credited to savings',
      'add to savings',
      'added to savings',
    ];
    
    return savingsDepositPatterns.any((pattern) => content.contains(pattern));
  }
  
  bool _isSavingsWithdrawal(String content) {
    // Check if message is about money withdrawn FROM savings
    final savingsWithdrawalPatterns = [
      'withdrawn from savings',
      'withdrawal from savings',
      'debited from savings',
      'removed from savings',
      'transferred from savings',
      'transfer from savings',
      'moved from savings',
    ];
    
    return savingsWithdrawalPatterns.any((pattern) => content.contains(pattern));
  }
  
  bool _isMobileMoneyExpense(String content) {
    // Mobile Money specific expense patterns (money sent/paid)
    final momoExpensePatterns = [
      'sent to',
      'momo sent',
      'mobile money sent',
      'cash out to',
      'transferred to',
      'paid to',
      'payment to',
      'send money to',
      'you sent',
      'you have sent',
      'you paid',
    ];
    
    // Check for "sent" context but not "sent you" or "sent to you" (which is revenue)
    if (content.contains('sent') && !content.contains('sent you') && !content.contains('sent to you')) {
      if (momoExpensePatterns.any((pattern) => content.contains(pattern))) {
        return true;
      }
    }
    
    // Other mobile money expenses
    if (momoExpensePatterns.any((pattern) => content.contains(pattern))) {
      return true;
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        elevation: 0,
        title: const Text('SMS Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadSMSData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text('Reading SMS messages...'),
                ],
              ),
            )
          : _messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sms, size: 64, color: Colors.grey),
                      const SizedBox(height: 16.0),
                      const Text('No SMS messages found'),
                      const SizedBox(height: 8.0),
                      const Text('Make sure you have SMS permission enabled'),
                      const SizedBox(height: 24.0),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (Platform.isAndroid) {
                            final status = await Permission.sms.request();
                            if (status.isGranted) {
                              _loadSMSData();
                            }
                          }
                        },
                        icon: const Icon(Icons.security),
                        label: const Text('Grant SMS Permission'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section - Cost Summary
                  if (_costSummary != null)
                    GestureDetector(
                      onTap: () {
                        // Log cost summary view
                        ActivityService.logActivity(
                          type: ActivityType.costSummaryViewed,
                          title: 'Viewed cost summary',
                          description: 'Total: ${_countryConfig?.currencySymbol ?? 'GHS'} ${_costSummary!.totalCost.toStringAsFixed(2)}',
                          metadata: {
                            'totalCost': _costSummary!.totalCost,
                            'totalMessages': _costSummary!.totalMessages,
                            'totalExpenses': _costSummary!.totalExpenses,
                            'totalRevenue': _costSummary!.totalRevenue,
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.1),
                              theme.colorScheme.secondary.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              theme.colorScheme.primary,
                                              theme.colorScheme.primary.withOpacity(0.8),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(16.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.colorScheme.primary.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.analytics_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'SMS Insights',
                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: theme.colorScheme.onSurface,
                                              ),
                                            ),
                                            Text(
                                              'Financial overview from your messages',
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.sms_rounded,
                                          color: theme.colorScheme.primary,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          '${_costSummary!.totalMessages} messages analyzed',
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24.0),
                              
                              // Stats Grid
                              Column(
                                children: [
                                  // Total Cost - Full Row
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color: Colors.red.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.attach_money_rounded,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8.0),
                                            Text(
                                              'Total Cost',
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          '${_countryConfig?.currencySymbol ?? 'GHS'} ${_costSummary!.totalCost.toStringAsFixed(2)}',
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 12.0),
                                  
                                  // Expenses and Revenue - Row
                                  Row(
                                    children: [
                                      // Total Expenses
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(16.0),
                                            border: Border.all(
                                              color: Colors.orange.withOpacity(0.2),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.trending_down_rounded,
                                                    color: Colors.orange,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    'Expenses',
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      color: Colors.orange,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                '${_countryConfig?.currencySymbol ?? 'GHS'} ${_costSummary!.totalExpenses.toStringAsFixed(2)}',
                                                style: theme.textTheme.titleLarge?.copyWith(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 12.0),
                                      
                                      // Total Revenue
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(16.0),
                                            border: Border.all(
                                              color: Colors.green.withOpacity(0.2),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.trending_up_rounded,
                                                    color: Colors.green,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    'Revenue',
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                '${_countryConfig?.currencySymbol ?? 'GHS'} ${_costSummary!.totalRevenue.toStringAsFixed(2)}',
                                                style: theme.textTheme.titleLarge?.copyWith(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 12.0),
                                  
                                  // Net Balance - Full Row
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color: theme.colorScheme.primary.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.account_balance_wallet_rounded,
                                              color: theme.colorScheme.primary,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8.0),
                                            Text(
                                              'Net Balance',
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          '${_countryConfig?.currencySymbol ?? 'GHS'} ${(_costSummary!.totalRevenue - _costSummary!.totalExpenses).toStringAsFixed(2)}',
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            color: (_costSummary!.totalRevenue - _costSummary!.totalExpenses) >= 0 
                                                ? Colors.green 
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 32.0),
                  
                  // Section Header - Categories
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.category_rounded,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Categories',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  
                  // Show limited categories for non-premium users
                  ...(_isPremiumActive ? SMSCategory.values : SMSCategory.values.take(4)).map((category) {
                    final count = _costSummary?.getMessageCountForCategory(category) ?? 0;
                    final cost = _costSummary?.getCostForCategory(category) ?? 0.0;
                    final expenses = _costSummary?.getExpenseForCategory(category) ?? 0.0;
                    final revenue = _costSummary?.getRevenueForCategory(category) ?? 0.0;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SMSCategoryCard(
                        category: category,
                        messageCount: count,
                        totalCost: cost,
                        totalExpenses: expenses,
                        totalRevenue: revenue,
                        onTap: () => _showCategoryDetails(category),
                      ),
                    );
                  }),
                  
                  // Premium Banner (if not active and there are more categories)
                  if (!_isPremiumActive && SMSCategory.values.length > 4)
                    Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
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
                            'Showing first 4 categories. Unlock all ${SMSCategory.values.length} categories with premium!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Navigate to settings page
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
                  
                  // Hidden Categories Indicator (if not premium and there are more categories)
                  if (!_isPremiumActive && SMSCategory.values.length > 4)
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
                                  'More categories below',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  '${SMSCategory.values.length - 4} additional categories are hidden',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
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
                  
                  const SizedBox(height: 32.0),
                  
                  // Section Header - Recent Messages
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.message_rounded,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Recent Messages',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          '${_messages.length} total',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  
                  ..._messages.take(5).map((message) => SMSMessageCard(
                    message: message,
                    onTap: () => _showMessageDetails(message),
                  )),
                  
                  if (_messages.length > 5) ...[
                    const SizedBox(height: 16.0),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _showAllMessages(),
                        icon: const Icon(Icons.list),
                        label: Text('View All ${_messages.length} Messages'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  void _showCategoryDetails(SMSCategory category) {
    final categoryMessages = _messages
        .where((msg) => msg.category == category)
        .toList();
    
    // Log category view activity
    ActivityService.logActivity(
      type: ActivityType.categoryViewed,
      title: 'Viewed ${category.displayName} SMS',
      description: '${categoryMessages.length} messages in category',
      metadata: {'category': category.name, 'messageCount': categoryMessages.length},
    );
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.displayName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${categoryMessages.length} messages',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: categoryMessages.length,
                itemBuilder: (context, index) {
                  final message = categoryMessages[index];
                  return SMSMessageCard(
                    message: message,
                    onTap: () {
                      Navigator.pop(context);
                      _showMessageDetails(message);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllMessages() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.sms, size: 32),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All SMS Messages',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${_messages.length} messages found',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return SMSMessageCard(
                    message: message,
                    onTap: () {
                      Navigator.pop(context);
                      _showMessageDetails(message);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageDetails(SMSMessage message) {
    final suggestions = SMSAnalyzer.generateSmartSuggestions(
      message.content, 
      message.category,
      country: _selectedCountry,
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.sender),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.content),
            const SizedBox(height: 16.0),
            Text(
              'Category: ${message.category.displayName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Cost: ${_countryConfig?.currencySymbol ?? 'GHS'} ${message.cost.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16.0),
            if (suggestions.isNotEmpty) ...[
              Text(
                'Smart Suggestions:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8.0),
              ...suggestions.take(3).map((suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text('• $suggestion'),
              )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
