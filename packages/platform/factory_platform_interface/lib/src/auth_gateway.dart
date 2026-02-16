import 'package:factory_core/factory_core.dart';

/// Authentication gateway contract.
///
/// Implement this to integrate with your auth provider
/// (Firebase Auth, Supabase Auth, custom backend, etc.).
abstract interface class AuthGateway {
  /// Returns the current user's ID, or null if not authenticated.
  FutureEither<String?> currentUserId();

  /// Signs in with email and password.
  FutureEither<String> signInWithEmail({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  FutureEitherVoid signOut();

  /// Stream of authentication state changes.
  Stream<String?> authStateChanges();
}
