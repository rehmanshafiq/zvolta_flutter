import 'package:zvolta_flutter/core/utils/exception_mapper.dart';
import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/data/datasources/charge_sessions_datasource.dart';
import 'package:zvolta_flutter/domain/entities/recent_charge_entity.dart';
import 'package:zvolta_flutter/domain/repositories/charge_sessions_repository.dart';

class ChargeSessionsRepositoryImpl implements ChargeSessionsRepository {
  ChargeSessionsRepositoryImpl({
    required ChargeSessionsLocalDataSource localDataSource,
    ExceptionMapper exceptionMapper = const ExceptionMapper(),
  })  : _localDataSource = localDataSource,
        _exceptionMapper = exceptionMapper;

  final ChargeSessionsLocalDataSource _localDataSource;
  final ExceptionMapper _exceptionMapper;

  @override
  Future<Result<List<RecentChargeEntity>>> getChargeSessions() async {
    try {
      final sessions = await _localDataSource.getChargeSessions();
      return Success(sessions.map((session) => session.toEntity()).toList());
    } catch (error) {
      return Error(_exceptionMapper.map(error));
    }
  }
}
