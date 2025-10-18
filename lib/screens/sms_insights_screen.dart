import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_plus/models/sms_model.dart';
import 'package:ussd_plus/utils/sms_analyzer.dart';
import 'package:ussd_plus/widgets/sms_category_card.dart';
import 'package:ussd_plus/widgets/cost_summary_card.dart';
import 'package:ussd_plus/widgets/sms_message_card.dart';

class SMSInsightsScreen extends StatefulWidget {
  const SMSInsightsScreen({super.key});

  @override
  State<SMSInsightsScreen> createState() => _SMSInsightsScreenState();
}

class _SMSInsightsScreenState extends State<SMSInsightsScreen> {
  List<SMSMessage> _messages = [];
  SMSCostSummary? _costSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSMSData();
  }

  void _loadSMSData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<SMSMessage> messages = [];
      
      if (Platform.isAndroid) {
        messages = await _readSMSFromDevice();
      } else {
        // For iOS or other platforms, show sample data
        messages = _generateSampleMessages();
      }
      
      setState(() {
        _messages = messages;
        _costSummary = _calculateCostSummary(_messages);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages = _generateSampleMessages();
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
        
        final category = SMSAnalyzer.categorizeMessage(content);
        final provider = SMSAnalyzer.detectProvider(content, sender);
        final cost = SMSAnalyzer.calculateCost(content, provider);
        
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

  List<SMSMessage> _generateSampleMessages() {
    final now = DateTime.now();
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
    // Look for GHS amounts in the message
    final ghsPattern = RegExp(r'GHS\s*(\d+(?:\.\d{2})?)', caseSensitive: false);
    final match = ghsPattern.firstMatch(content);
    
    if (match != null) {
      return double.tryParse(match.group(1) ?? '0') ?? 0.0;
    }
    
    // Look for other currency patterns
    final currencyPattern = RegExp(r'(\d+(?:\.\d{2})?)\s*(?:cedis?|ghs)', caseSensitive: false);
    final currencyMatch = currencyPattern.firstMatch(content);
    
    if (currencyMatch != null) {
      return double.tryParse(currencyMatch.group(1) ?? '0') ?? 0.0;
    }
    
    return 0.0;
  }

  bool _isExpenseMessage(SMSMessage message) {
    final content = message.content.toLowerCase();
    
    // Keywords that indicate money going out
    final expenseKeywords = [
      'debited', 'withdrawn', 'spent', 'paid', 'charged', 'deducted',
      'purchase', 'payment', 'bill', 'fee', 'cost', 'expense',
      'sent', 'transfer', 'withdrawal', 'purchase', 'buy'
    ];
    
    return expenseKeywords.any((keyword) => content.contains(keyword));
  }

  bool _isRevenueMessage(SMSMessage message) {
    final content = message.content.toLowerCase();
    
    // Keywords that indicate money coming in
    final revenueKeywords = [
      'credited', 'received', 'deposited', 'refund', 'cashback',
      'bonus', 'reward', 'earned', 'income', 'salary', 'wage',
      'received', 'deposit', 'credit', 'refund', 'return'
    ];
    
    return revenueKeywords.any((keyword) => content.contains(keyword));
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
                  // Cost Summary
                  if (_costSummary != null)
                    CostSummaryCard(costSummary: _costSummary!),
                  
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
                  
                  ...SMSCategory.values.map((category) {
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
      message.category
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
              'Cost: GHS ${message.cost.toStringAsFixed(2)}',
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
