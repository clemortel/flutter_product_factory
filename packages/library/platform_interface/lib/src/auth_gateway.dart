import 'package:core/core.dart';

/// Authentication gateway contract.
///
/// Implement this to integrate with your auth provider
/// (Firebase Auth, Supabase Auth, custom backend, etc.).
abstract interface class AuthGateway {
  /// Returns the current user's ID, or null if not authenticated.
  FutureResult<String?> currentUserId();

  /// Signs in with email and password.
  FutureResult<String> signInWithEmail({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  FutureResultVoid signOut();

  /// Stream of authentication state changes.
  Stream<String?> authStateChanges();
}
