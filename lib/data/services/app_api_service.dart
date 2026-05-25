import 'package:zvolta_flutter/core/network/api_client.dart';
import 'package:zvolta_flutter/data/models/user_model.dart';

/// Low-level API calls for app-related endpoints.
class AppApiService {
  AppApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<UserModel>> fetchUsers() async {
    final response = await _apiClient.get<List<dynamic>>('/users');
    final data = response.data;

    if (data == null) {
      return [];
    }

    return data
        .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
