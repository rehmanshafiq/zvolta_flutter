import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';

class WalletTopUpBottomSheet extends StatefulWidget {
  const WalletTopUpBottomSheet({super.key});

  static const _quickAmounts = [500, 1000, 2000, 5000];

  static Future<int?> show(BuildContext context) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const WalletTopUpBottomSheet(),
    );
  }

  @override
  State<WalletTopUpBottomSheet> createState() => _WalletTopUpBottomSheetState();
}

class _WalletTopUpBottomSheetState extends State<WalletTopUpBottomSheet> {
  static const _quickAmounts = WalletTopUpBottomSheet._quickAmounts;

  final _amountController = TextEditingController(text: '1000');
  int _selectedAmount = 1000;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectAmount(int amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toString();
    });
  }

  void _onCustomAmountChanged(String value) {
    final amount = int.tryParse(value) ?? 0;
    setState(() {
      _selectedAmount = amount;
      if (_quickAmounts.contains(amount)) {
        return;
      }
    });
  }

  int get _effectiveAmount {
    final parsed = int.tryParse(_amountController.text.trim()) ?? 0;
    return parsed > 0 ? parsed : _selectedAmount;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
    final amountFormat = NumberFormat('#,##0');

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 10, 24, bottomPadding + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.greyBottomSheetThumbColor,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Top Up Wallet',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.homeSubtitleGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Quick Select',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.homeSubtitleGrey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: _quickAmounts.map((amount) {
                final isSelected = _selectedAmount == amount &&
                    _amountController.text.trim() == amount.toString();

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: amount == _quickAmounts.last ? 0 : 8,
                    ),
                    child: _QuickAmountChip(
                      amount: amount,
                      isSelected: isSelected,
                      onTap: () => _selectAmount(amount),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Custom Amount',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.homeSubtitleGrey,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _onCustomAmountChanged,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
              decoration: InputDecoration(
                prefixText: 'PKR ',
                prefixStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.homeSubtitleGrey,
                ),
                filled: true,
                fillColor: AppColors.whiteColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.homeCardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.homeCardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.mapPinBlueColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _effectiveAmount > 0
                    ? () => Navigator.of(context).pop(_effectiveAmount)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.mapPinBlueColor,
                  foregroundColor: AppColors.whiteColor,
                  disabledBackgroundColor:
                      AppColors.mapPinBlueColor.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Top Up PKR ${amountFormat.format(_effectiveAmount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  const _QuickAmountChip({
    required this.amount,
    required this.isSelected,
    required this.onTap,
  });

  final int amount;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.mapPinBlueColor
                  : AppColors.homeCardBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            amount.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? AppColors.mapPinBlueColor
                  : AppColors.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
