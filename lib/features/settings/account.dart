import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Signed-in user profile.
///
/// v1 has no auth backend, so [accountControllerProvider] stays `null`
/// (signed out). When the backend lands, `signIn` sets this from the API
/// response and every account-aware widget updates automatically.
class AccountUser {
  const AccountUser({
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  final String name;
  final String email;
  final String? avatarUrl;

  /// First letter for the avatar fallback (uppercased).
  String get initial => name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
}

/// Current account, or `null` when signed out.
///
/// Future wiring: replace the body of [signIn] with an API call that returns
/// an [AccountUser]; the rest of the app already reads this provider.
class AccountController extends Notifier<AccountUser?> {
  @override
  AccountUser? build() => null; // signed out until the auth backend ships

  void signIn(AccountUser user) => state = user;

  void signOut() => state = null;
}

final accountControllerProvider =
    NotifierProvider<AccountController, AccountUser?>(AccountController.new);
