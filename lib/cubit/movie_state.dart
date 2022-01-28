part of 'movie_cubit.dart';

const SUCCESS = "Success";
const LOADING = "Loading";
const ERROR = "Error";
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
  final int? _requestCode;

  LoadingState(this._requestCode);

  @override
  Map<String, dynamic> get props => {REQUEST_CODE: _requestCode};
}

class ReceivedState extends MovieState {
  final dynamic _response;
  final int? _requestCode;

  ReceivedState(this._response, this._requestCode);

  @override
  Map<String, dynamic> get props =>
      {RESPONSE: _response, REQUEST_CODE: _requestCode};
}

class ErrorState extends MovieState {
  final String _errorMessage;
  final int? _requestCode;

  ErrorState(this._errorMessage, this._requestCode);

  @override
  Map<String, dynamic> get props =>
      {ERROR: _errorMessage, REQUEST_CODE: _requestCode};
}
