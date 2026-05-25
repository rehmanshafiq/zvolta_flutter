/// Represents the result of the splash initialization check.
class AppInitStatus {
  const AppInitStatus({
    required this.isInitialized,
    this.isFirstLaunch = false,
  });

  final bool isInitialized;
  final bool isFirstLaunch;
}
