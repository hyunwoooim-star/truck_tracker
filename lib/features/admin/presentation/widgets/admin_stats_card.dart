import 'package:flutter/material.dart';

import '../../../../core/themes/app_theme.dart';

/// Reusable stats card for admin dashboard
class AdminStatsCard extends StatelessWidget {
  const AdminStatsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color = AppTheme.mustardYellow,
    this.suffix,
    this.onTap,
    this.trend,
    this.trendUp,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? suffix;
  final VoidCallback? onTap;
  final String? trend;
  final bool? trendUp;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.charcoalMedium,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      color: AppTheme.textTertiary,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  if (suffix != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      suffix!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              if (trend != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      trendUp == true
                          ? Icons.trending_up
                          : trendUp == false
                              ? Icons.trending_down
                              : Icons.trending_flat,
                      size: 16,
                      color: trendUp == true
                          ? Colors.green
                          : trendUp == false
                              ? Colors.red
                              : AppTheme.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend!,
                      style: TextStyle(
                        fontSize: 12,
                        color: trendUp == true
                            ? Colors.green
                            : trendUp == false
                                ? Colors.red
                                : AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact version of stats card for grid layout
class AdminStatsCardCompact extends StatelessWidget {
  const AdminStatsCardCompact({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color = AppTheme.mustardYellow,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.charcoalMedium,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.charcoalLight,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textTertiary,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
