import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/entities/user_entity.dart';
import 'package:zvolta_flutter/domain/repositories/app_repository.dart';

/// Fetches the list of users from the remote API.
class GetUsersUseCase implements UseCase<List<UserEntity>, NoParams> {
  GetUsersUseCase(this._repository);

  final AppRepository _repository;

  @override
  Future<Result<List<UserEntity>>> call(NoParams params) {
    return _repository.getUsers();
  }
}
