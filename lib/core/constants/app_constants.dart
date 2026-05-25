/// App-wide string constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Zvolta';
  static const int paginationLimit = 20;
  static const Duration cacheValidity = Duration(hours: 1);
  static const Duration splashDuration = Duration(seconds: 2);
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String authTokenKey = 'auth_token';
}
