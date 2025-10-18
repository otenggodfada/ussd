import 'package:flutter/material.dart';
import 'package:ussd_plus/models/sms_model.dart';

class SMSCategoryCard extends StatelessWidget {
  final SMSCategory category;
  final int messageCount;
  final double totalCost;
  final double totalExpenses;
  final double totalRevenue;
  final VoidCallback onTap;

  const SMSCategoryCard({
    super.key,
    required this.category,
    required this.messageCount,
    required this.totalCost,
    this.totalExpenses = 0.0,
    this.totalRevenue = 0.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: _getCategoryColor(category).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _getCategoryColor(category),
                        _getCategoryColor(category).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: _getCategoryColor(category).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      category.icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        children: [
                          Icon(
                            Icons.message_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '$messageCount messages',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (totalExpenses > 0 || totalRevenue > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (totalRevenue - totalExpenses) >= 0 
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'GHS ${(totalRevenue - totalExpenses).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: (totalRevenue - totalExpenses) >= 0 
                                ? Colors.green[400] 
                                : Colors.red[400],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        'Net Balance',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'GHS ${totalCost.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(category),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        'SMS cost',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(SMSCategory category) {
    switch (category) {
      case SMSCategory.telecom:
        return Colors.blue;
      case SMSCategory.banking:
        return Colors.green;
      case SMSCategory.utilities:
        return Colors.orange;
      case SMSCategory.mobileMoney:
        return Colors.purple;
      case SMSCategory.promotional:
        return Colors.pink;
      case SMSCategory.other:
        return Colors.grey;
    }
  }
}
