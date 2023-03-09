import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String url;
  final String message;
  final int? statusCode;
  final Response? response;

  ApiException({
    required this.url,
    required this.message,
    this.response,
    this.statusCode,
  });

  /// IMPORTANT NOTE
  /// here you can take advantage of toString() method to display the error for user
  /// lets make an example
  /// so in onError method when you make api you can just user apiExceptionInstance.toString() to get the error message from api
  @override
  toString() {
    String result = '';
    // if server sent error message take it
    if(response != null){
      try{
        // TODO add error message field which is coming from api for you
        result += response!.data['message'];
      }catch(_){}
    }else {
      result += ' ' + message; // message is the (dio error message) so usualy its not user friendly
    }

    return result;
  }
}