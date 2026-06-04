abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState{}
class ForgotPasswordLoading extends ForgotPasswordState{}
class ForgotPasswordCode extends ForgotPasswordState{}
class ForgotPasswordSuccess extends ForgotPasswordState{}
class ForgotPasswordFailure extends ForgotPasswordState{
  final String error;
  ForgotPasswordFailure(this.error);
}
class ResetPasswordLoading extends ForgotPasswordState{}
class ResetPasswordSuccess extends ForgotPasswordState{}
class ResetPasswordFailure extends ForgotPasswordState{
  final String error;
  ResetPasswordFailure(this.error);
}
