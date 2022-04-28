import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/utils/Constants.dart';

import 'ApiExceptions.dart';

class ApiManager {
  final dioClientProvider = Provider<Dio>(
    (ref) => Dio(
      BaseOptions(
        baseUrl: Constants.urlPrefix,
      ),
    ),
  );

  FutureProvider getDioResponse(String apiUrl) {
    final endpoint = apiUrl + "?api_key=${Constants.apiKey}";

    return FutureProvider((ref) async {
      final response = await ref.read(dioClientProvider).get(
            endpoint,
          );

      return response.data;
    });
  }

  Future<dynamic> getResponse(String apiUrl) async {
    var responseJson;

    final finalUrl =
        Constants.urlPrefix + apiUrl + "?api_key=${Constants.apiKey}";

    print('Api url : $finalUrl');

    try {
      final uri = Uri.parse(finalUrl);

      final response = await Dio(BaseOptions(
        contentType: 'application/json',
        responseType: ResponseType.plain,
      )).get(finalUrl);

      print('Status code: ${response.statusCode}');
      print('Body: ${response.data}');

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
        return json.decode(response.data.toString());
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException('Internal server error');
    }
  }
}
