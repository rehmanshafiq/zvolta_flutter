import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/domain/entities/app_init_status.dart';
import 'package:zvolta_flutter/domain/entities/user_entity.dart';

/// Contract for app-level data operations.
/// Presentation layer depends on this abstraction, not the implementation.
abstract class AppRepository {
  Future<Result<AppInitStatus>> checkAppInitialized();

  Future<Result<List<UserEntity>>> getUsers();
}
