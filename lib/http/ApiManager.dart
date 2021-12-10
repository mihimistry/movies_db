import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:movies_db/utils/Constants.dart';

import '../model/MovieListResponse.dart';
import 'ApiExceptions.dart';

class ApiManager {
  Future<dynamic> getResponse(String apiUrl) async {
    var responseJson;

    final finalUrl =
        Constants.urlPrefix + apiUrl + "?api_key=${Constants.apiKey}";

    print('Api url : $finalUrl');

    try {
      final uri = Uri.parse(finalUrl);

      final response = await get(uri);

      print('Status code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');

      responseJson = _returnResponse(response);
    } on SocketException {
      print('No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body.toString());
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Internal server error');
    }
  }
}
