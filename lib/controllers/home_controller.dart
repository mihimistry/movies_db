import 'dart:convert';
import 'package:get/get.dart';
import 'package:movies_db/data/MovieRepository.dart';
import 'package:movies_db/model/MovieListResponse.dart';

import '../services/api_call_status.dart';

class HomeController extends GetxController {
  var homeRepo = MovieRepository();

  var nowPlayingStatus = (ApiCallStatus.holding).obs;
  var popularStatus = (ApiCallStatus.holding).obs;
  var upcomingStatus = (ApiCallStatus.holding).obs;
  var nowPlayingMovies = MovieListResponse().obs;
  var popularMovies = MovieListResponse().obs;
  var upcomingMovies = MovieListResponse().obs;

  @override
  void onInit() {
    fetchNowPlayings();
    fetchPopularMovies();
    fetchUpcomingMovies();
    super.onInit();
  }

  void fetchNowPlayings() async {
    try {
      nowPlayingStatus(ApiCallStatus.loading);
      var response = await homeRepo.fetchNowPlaying();
      nowPlayingMovies(
          MovieListResponse.fromJson(jsonDecode(jsonEncode(response))));
      nowPlayingStatus(ApiCallStatus.success);
    } catch (e) {
      nowPlayingStatus(ApiCallStatus.error);
    }
  }

  void fetchPopularMovies() async {
    try {
      popularStatus(ApiCallStatus.loading);
      var response = await homeRepo.fetchPopularMovies();
      popularMovies(
          MovieListResponse.fromJson(jsonDecode(jsonEncode(response))));
      popularStatus(ApiCallStatus.success);
    } catch (e) {
      popularStatus(ApiCallStatus.error);
    }
  }

  void fetchUpcomingMovies() async {
    try {
      upcomingStatus(ApiCallStatus.loading);
      var response = await homeRepo.fetchUpcomingMovies();
      upcomingMovies(
          MovieListResponse.fromJson(jsonDecode(jsonEncode(response))));
      upcomingStatus(ApiCallStatus.success);
    } catch (e) {
      upcomingStatus(ApiCallStatus.error);
    }
  }
}
