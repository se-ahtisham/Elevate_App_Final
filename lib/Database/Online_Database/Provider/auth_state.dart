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

  /// Update some fields, keep the res
  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    UserModel? user,
  }) => AuthState(
    isLoading: isLoading ?? this.isLoading, // if new value given → use it
    errorMessage: errorMessage ?? this.errorMessage, // else → keep old value
    successMessage: successMessage ?? this.successMessage,
    user: user ?? this.user,
  );
  // To remove error/success messages from the screen after showing them to the user
  // Whenever you want to hide/remove error or success messages from UI → call
  /* Login failed → error message shows
state = AuthState(errorMessage: "Wrong password");

 User starts typing again → clear the error
state = state.clearMessages();
 errorMessage = null → error disappears from screen
Login success → success message shows
state = AuthState(successMessage: "Login Successful!");

Now move to next screen → clear the message
state = state.clearMessages(); */
  AuthState clearMessages() => AuthState(isLoading: isLoading, user: user);
}
