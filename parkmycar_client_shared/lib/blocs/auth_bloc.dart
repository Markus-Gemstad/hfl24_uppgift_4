import 'package:bloc/bloc.dart';
import 'package:parkmycar_client_shared/repositories/person_http_repository.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    on<AuthLoginRequested>(
        (event, emit) async => await _handleLogin(event, emit));
    on<AuthLogoutRequested>(
        (event, emit) async => await _handleLogout(event, emit));
  }

  Future<void> _handleLogin(event, emit) async {
    emit(AuthState.authenticating());
    // TODO Ta bort fördröjning
    await Future.delayed(Duration(seconds: 1));
    try {
      List<Person> all = await PersonHttpRepository.instance.getAll();
      var filtered = all.where((e) => e.email == event.email);
      if (filtered.isNotEmpty) {
        Person user = filtered.first;
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _handleLogout(event, emit) async {
    emit(AuthState.initial());
  }
}
