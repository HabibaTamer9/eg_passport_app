abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpError extends OtpState {
  final String message;
  OtpError(this.message);
}

class OtpTimerRunning extends OtpState {
  final int seconds;
  OtpTimerRunning(this.seconds);
}

class OtpLocked extends OtpState {
  final int lockMinutes;
  OtpLocked(this.lockMinutes);
}
