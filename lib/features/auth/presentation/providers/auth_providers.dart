// lib/features/auth/presentation/providers/auth_providers.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/features/auth/data/repositories/auth_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(firebaseAuthProvider)),
);

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

class AuthFormState {
  final bool isLoading;
  final String? error;
  const AuthFormState({this.isLoading = false, this.error});

  AuthFormState copyWith({bool? isLoading, String? error}) => AuthFormState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class AuthController extends StateNotifier<AuthFormState> {
  final AuthRepository _repo;
  AuthController(this._repo) : super(const AuthFormState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.signIn(email, password);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthFormState(isLoading: false, error: _repo.mapError(e));
      return false;
    } catch (_) {
      state = const AuthFormState(isLoading: false, error: 'Something went wrong.');
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.signUp(name, email, password);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthFormState(isLoading: false, error: _repo.mapError(e));
      return false;
    } catch (_) {
      state = const AuthFormState(isLoading: false, error: 'Something went wrong.');
      return false;
    }
  }

  Future<bool> guest() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.continueAsGuest();
      state = state.copyWith(isLoading: false);
      return true;
    } catch (_) {
      state = const AuthFormState(isLoading: false, error: 'Could not continue as guest.');
      return false;
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthFormState>(
  (ref) => AuthController(ref.watch(authRepositoryProvider)),
);