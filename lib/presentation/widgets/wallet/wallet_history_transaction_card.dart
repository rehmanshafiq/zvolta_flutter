import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';

class WalletHistoryTransactionCard extends StatelessWidget {
  const WalletHistoryTransactionCard({
    super.key,
    required this.transaction,
    required this.onReceiptTap,
  });

  final WalletTransactionEntity transaction;
  final VoidCallback onReceiptTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('M/d/yyyy, h:mm:ss a');
    final isCharging =
        transaction.type == WalletTransactionType.chargingSession;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.homeCardBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isCharging) ...[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.homeRangeImpactOrange
                          .withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.homeRangeImpactOrange,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blackColor,
                        ),
                      ),
                      if (transaction.chargeSessionId != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Charge Session ID: ${transaction.chargeSessionId}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.homeSubtitleGrey,
                          ),
                        ),
                      ],
                      if (transaction.driverLabel != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          transaction.driverLabel!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.homeSubtitleGrey,
                          ),
                        ),
                      ],
                      const SizedBox(height: 2),
                      Text(
                        'Debit at ${dateFormat.format(transaction.dateTime)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.homeSubtitleGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '- PKR ${transaction.amountPkr.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.removeColor,
                  ),
                ),
              ],
            ),
          ),
          if (transaction.hasReceipt) ...[
            Divider(
              height: 1,
              color: AppColors.homeCardBorder.withValues(alpha: 0.8),
            ),
            InkWell(
              onTap: onReceiptTap,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Receipt',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
