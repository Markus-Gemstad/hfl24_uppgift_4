part of 'auth_bloc.dart';

enum AuthStateStatus { initial, authenticating, authenticated, unauthenticated }

class AuthState {
  final AuthStateStatus status;
  final Person? user;

  const AuthState._({
    this.status = AuthStateStatus.initial,
    this.user,
  });

  const AuthState.initial() : this._();

  const AuthState.authenticating()
      : this._(status: AuthStateStatus.authenticating, user: null);

  const AuthState.authenticated(Person user)
      : this._(status: AuthStateStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStateStatus.unauthenticated, user: null);
}

// final class AuthInitial extends AuthState {
//   AuthInitial();
// }

// final class AuthLoading extends AuthState {
//   AuthLoading();
// }

// final class AuthSuccess extends AuthState {
//   final Person user;
//   AuthSuccess(this.user);
// }

// final class AuthFailure extends AuthState {
//   final String error;
//   AuthFailure(this.error);
// }
