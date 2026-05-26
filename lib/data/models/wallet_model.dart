import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';

class WalletSummaryModel {
  const WalletSummaryModel({
    required this.availableBalancePkr,
    required this.thisMonthPkr,
    required this.holdBalancePkr,
  });

  final double availableBalancePkr;
  final double thisMonthPkr;
  final double holdBalancePkr;

  WalletSummaryEntity toEntity() {
    return WalletSummaryEntity(
      availableBalancePkr: availableBalancePkr,
      thisMonthPkr: thisMonthPkr,
      holdBalancePkr: holdBalancePkr,
    );
  }
}

class WalletTransactionModel {
  const WalletTransactionModel({
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

  WalletTransactionEntity toEntity() {
    return WalletTransactionEntity(
      id: id,
      type: type,
      title: title,
      dateTime: dateTime,
      amountPkr: amountPkr,
      chargeSessionId: chargeSessionId,
      driverLabel: driverLabel,
      stationName: stationName,
    );
  }
}

class WalletDashboardModel {
  const WalletDashboardModel({
    required this.summary,
    required this.transactions,
  });

  final WalletSummaryModel summary;
  final List<WalletTransactionModel> transactions;

  WalletDashboardEntity toEntity() {
    return WalletDashboardEntity(
      summary: summary.toEntity(),
      transactions: transactions.map((item) => item.toEntity()).toList(),
    );
  }
}
