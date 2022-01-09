part of 'movie_cubit.dart';

abstract class MovieState {
  const MovieState();
}

class InitialState extends MovieState {
  @override
  List<Object> get props => [];
}

class LoadingState extends MovieState {
  @override
  List<Object> get props => [];
}

class ReceivedState extends MovieState {
  final dynamic _response;

  ReceivedState(this._response);

  @override
  Object get props => _response;
}

class ErrorState extends MovieState {
  final String _errorMessage;

  ErrorState(this._errorMessage);

  @override
  List<Object> get props => [_errorMessage];
}
