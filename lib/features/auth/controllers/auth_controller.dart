import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/snackbar.dart';
import '../../../models/user_models.dart';
import '../repository/auth_repository.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = Provider((ref) => AuthController(
      authRepository: ref.read(authRepositoryProvider),
      ref: ref,
    ));

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  void signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();
    user.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).update((state) => r));
  }
}
