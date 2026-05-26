import 'package:zvolta_flutter/data/models/wallet_model.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';

abstract class WalletLocalDataSource {
  Future<WalletDashboardModel> getWalletDashboard();
}

class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  @override
  Future<WalletDashboardModel> getWalletDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return WalletDashboardModel(
      summary: const WalletSummaryModel(
        availableBalancePkr: 60889,
        thisMonthPkr: 334,
        holdBalancePkr: 0,
      ),
      transactions: [
        WalletTransactionModel(
          id: 'tx-1',
          type: WalletTransactionType.driverDebit,
          title: 'Driver 2',
          dateTime: DateTime(2026, 5, 25, 16, 33, 52),
          amountPkr: 1,
        ),
        WalletTransactionModel(
          id: 'tx-2',
          type: WalletTransactionType.chargingSession,
          title: 'Charging Session',
          chargeSessionId: '940',
          driverLabel: 'Driver 2',
          stationName: 'Vlektra Station 1',
          dateTime: DateTime(2026, 5, 23, 12, 41, 13),
          amountPkr: 1,
        ),
        WalletTransactionModel(
          id: 'tx-3',
          type: WalletTransactionType.chargingSession,
          title: 'Charging Session',
          chargeSessionId: '947',
          driverLabel: 'Driver 2',
          stationName: 'Vlektra Station 1',
          dateTime: DateTime(2026, 5, 22, 21, 26, 33),
          amountPkr: 1,
        ),
        WalletTransactionModel(
          id: 'tx-4',
          type: WalletTransactionType.chargingSession,
          title: 'Charging Session',
          chargeSessionId: '946',
          driverLabel: 'Driver 2',
          stationName: 'Vlektra Station 1',
          dateTime: DateTime(2026, 5, 22, 21, 26, 16),
          amountPkr: 1,
        ),
        WalletTransactionModel(
          id: 'tx-5',
          type: WalletTransactionType.chargingSession,
          title: 'Charging Session',
          chargeSessionId: '944',
          driverLabel: 'Driver 2',
          stationName: 'Vlektra Station 1',
          dateTime: DateTime(2026, 5, 22, 21, 25, 19),
          amountPkr: 1,
        ),
        WalletTransactionModel(
          id: 'tx-6',
          type: WalletTransactionType.chargingSession,
          title: 'Charging Session',
          chargeSessionId: '943',
          driverLabel: 'Driver 2',
          stationName: 'Vlektra Station 1',
          dateTime: DateTime(2026, 5, 22, 14, 8, 9),
          amountPkr: 1,
        ),
        WalletTransactionModel(
          id: 'tx-7',
          type: WalletTransactionType.chargingSession,
          title: 'Charging Session',
          chargeSessionId: '917',
          driverLabel: 'Driver 2',
          stationName: 'Vlektra Station 1',
          dateTime: DateTime(2026, 5, 13, 12, 0, 0),
          amountPkr: 1,
        ),
      ],
    );
  }
}
