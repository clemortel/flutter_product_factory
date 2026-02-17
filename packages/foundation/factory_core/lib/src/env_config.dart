/// Holds environment-specific configuration values.
///
/// Create an instance at app startup and provide it via Riverpod:
/// ```dart
/// @Riverpod(keepAlive: true)
/// EnvConfig envConfig(Ref ref) => EnvConfig(
///   apiBaseUrl: 'https://api.example.com',
///   environment: 'production',
/// );
/// ```
class EnvConfig {
  const EnvConfig({
    required this.apiBaseUrl,
    this.environment = 'development',
  });

  final String apiBaseUrl;
  final String environment;

  bool get isProduction => environment == 'production';
  bool get isDevelopment => environment == 'development';
  bool get isStaging => environment == 'staging';
}
