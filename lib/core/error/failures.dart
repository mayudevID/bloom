import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String errorMessage;

  ServerFailure({required this.errorMessage});
}

class NetworkFailure extends Failure {
  final String errorMessage;

  NetworkFailure({required this.errorMessage});
}

class OtherFailure extends Failure {
  final String errorMessage;

  OtherFailure({required this.errorMessage});
}
