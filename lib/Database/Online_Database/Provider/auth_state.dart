import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/user_model.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final UserModel? user;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    UserModel? user,
  }) => AuthState(
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
    successMessage: successMessage ?? this.successMessage,
    user: user ?? this.user,
  );

  AuthState clearMessages() => AuthState(isLoading: isLoading, user: user);
}
