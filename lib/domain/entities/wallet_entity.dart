import 'package:equatable/equatable.dart';

enum WalletSectionTab { wallet, history, plans }

enum WalletTransactionType { driverDebit, chargingSession }

class WalletSummaryEntity extends Equatable {
  const WalletSummaryEntity({
    required this.availableBalancePkr,
    required this.thisMonthPkr,
    required this.holdBalancePkr,
  });

  final double availableBalancePkr;
  final double thisMonthPkr;
  final double holdBalancePkr;

  @override
  List<Object?> get props => [
        availableBalancePkr,
        thisMonthPkr,
        holdBalancePkr,
      ];
}

class WalletTransactionEntity extends Equatable {
  const WalletTransactionEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.dateTime,
    required this.amountPkr,
    this.chargeSessionId,
    this.driverLabel,
    this.stationName,
  });

  final String id;
  final WalletTransactionType type;
  final String title;
  final DateTime dateTime;
  final double amountPkr;
  final String? chargeSessionId;
  final String? driverLabel;
  final String? stationName;

  bool get hasReceipt => type == WalletTransactionType.chargingSession;

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        dateTime,
        amountPkr,
        chargeSessionId,
        driverLabel,
        stationName,
      ];
}

class WalletDashboardEntity extends Equatable {
  const WalletDashboardEntity({
    required this.summary,
    required this.transactions,
  });

  final WalletSummaryEntity summary;
  final List<WalletTransactionEntity> transactions;

  @override
  List<Object?> get props => [summary, transactions];
}
