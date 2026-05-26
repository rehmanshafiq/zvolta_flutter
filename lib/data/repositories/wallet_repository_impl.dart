import 'package:zvolta_flutter/core/utils/exception_mapper.dart';
import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/data/datasources/wallet_datasource.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';
import 'package:zvolta_flutter/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl({
    required WalletLocalDataSource localDataSource,
    ExceptionMapper exceptionMapper = const ExceptionMapper(),
  })  : _localDataSource = localDataSource,
        _exceptionMapper = exceptionMapper;

  final WalletLocalDataSource _localDataSource;
  final ExceptionMapper _exceptionMapper;

  @override
  Future<Result<WalletDashboardEntity>> getWalletDashboard() async {
    try {
      final dashboard = await _localDataSource.getWalletDashboard();
      return Success(dashboard.toEntity());
    } catch (error) {
      return Error(_exceptionMapper.map(error));
    }
  }
}
