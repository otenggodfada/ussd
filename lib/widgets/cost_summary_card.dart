import 'package:flutter/material.dart';
import 'package:ussd_plus/theme/theme_generator.dart';
import 'package:ussd_plus/models/sms_model.dart';

class CostSummaryCard extends StatelessWidget {
  final SMSCostSummary costSummary;

  const CostSummaryCard({
    super.key,
    required this.costSummary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = ThemeGenerator.generateGradient(ThemeGenerator.themeNumber);
    
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial Overview',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Last 30 days',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    Icons.sms_rounded,
                    'SMS Cost',
                    'GHS ${costSummary.totalCost.toStringAsFixed(2)}',
                    Colors.white,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildSummaryItem(
                    Icons.message_rounded,
                    'Messages',
                    '${costSummary.totalMessages}',
                    Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildFinancialItem(
                          Icons.arrow_downward_rounded,
                          'Expenses',
                          'GHS ${costSummary.totalExpenses.toStringAsFixed(2)}',
                          Colors.red[300]!,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      Expanded(
                        child: _buildFinancialItem(
                          Icons.arrow_upward_rounded,
                          'Revenue',
                          'GHS ${costSummary.totalRevenue.toStringAsFixed(2)}',
                          Colors.green[300]!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Divider(color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        costSummary.totalRevenue >= costSummary.totalExpenses
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: costSummary.totalRevenue >= costSummary.totalExpenses 
                            ? Colors.green[300]
                            : Colors.red[300],
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Net Balance',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'GHS ${(costSummary.totalRevenue - costSummary.totalExpenses).abs().toStringAsFixed(2)}',
                            style: TextStyle(
                              color: costSummary.totalRevenue >= costSummary.totalExpenses 
                                  ? Colors.green[300]
                                  : Colors.red[300],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
