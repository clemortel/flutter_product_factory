/// Abstract interfaces for platform services.
///
/// Depend on this package to write backend-agnostic code.
/// Concrete implementations live in `http_client`, `storage`, etc.
library platform_interface;

export 'src/analytics_gateway.dart';
export 'src/api_client.dart';
export 'src/auth_gateway.dart';
export 'src/key_value_store.dart';
