import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_clean_arch/shop_app/auth/domain/use_case/login_use_case.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/controller/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.signInUseCase) : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix = isPassword ? Icons.visibility : Icons.visibility_off;

    emit(ChangePasswordState());
  }

  LoginUseCase signInUseCase;
  dynamic loginCubit;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    final result = await signInUseCase(LoginParameter({
      'email': email,
      'password': password,
    }));

    result.fold((l) {
      emit(LoginErrorState(l.message));
    }, (r) {
      print('mohamed Thanks god');
      loginCubit = r;
      print(loginCubit);

      emit(LoginSuccessState(r));
    });
  }
}
