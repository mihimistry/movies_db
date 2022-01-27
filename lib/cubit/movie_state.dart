part of 'movie_cubit.dart';

const RESPONSE = "Response";
const REQUEST_CODE = "RequestCode";

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
  final int? _requestCode;

  ReceivedState(this._response, this._requestCode);

  @override
  Map<String, dynamic> get props =>
      {RESPONSE: _response, REQUEST_CODE: _requestCode};
}

class Received1State extends MovieState {
  final dynamic _response;
  final int? _requestCode;

  Received1State(this._response, this._requestCode);

  @override
  Map<String, dynamic> get props =>
      {RESPONSE: _response, REQUEST_CODE: _requestCode};
}

class Received2State extends MovieState {
  final dynamic _response;
  final int? _requestCode;

  Received2State(this._response, this._requestCode);

  @override
  Map<String, dynamic> get props =>
      {RESPONSE: _response, REQUEST_CODE: _requestCode};
}

class ErrorState extends MovieState {
  final String _errorMessage;

  ErrorState(this._errorMessage);

  @override
  List<Object> get props => [_errorMessage];
}
