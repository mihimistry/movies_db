import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../utils/Constants.dart';
import 'ApiExceptions.dart';

class APIService {
  Future<dynamic> getResponse(String apiUrl) async {
    var responseJson;

    final finalUrl =
        Constants.urlPrefix + apiUrl + "?api_key=${Constants.apiKey}";

    print('Api url : $finalUrl');

    try {
      final uri = Uri.parse(finalUrl);

      final response =
          await get(uri, headers: {'contentType': 'application/json'});

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
