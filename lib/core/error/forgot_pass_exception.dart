class SendEmailFailure implements Exception {
  const SendEmailFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SendEmailFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SendEmailFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SendEmailFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const SendEmailFailure(
          'Incorrect email or password, please try again.',
        );
      case 'wrong-password':
        return const SendEmailFailure(
          'Incorrect email or password, please try again.',
        );
      default:
        return const SendEmailFailure();
    }
  }

  final String message;
}
