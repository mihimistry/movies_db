import 'dart:convert';
import 'package:get/get.dart';
import 'package:movies_db/data/MovieRepository.dart';
import 'package:movies_db/model/movie_credits_response.dart';
import 'package:movies_db/model/movie_images_response.dart';
import 'package:movies_db/model/movie_videos_response.dart';
import '../model/movie_detail_response.dart';
import '../services/api_call_status.dart';

class MovieDetailsController extends GetxController {
  var movieDetailsRepo = MovieRepository();

  var movieId = 0.obs;
  var movieDetailsStatus = (ApiCallStatus.holding).obs;
  var movieVideosStatus = (ApiCallStatus.holding).obs;
  var movieImagesStatus = (ApiCallStatus.holding).obs;
  var movieCreditsStatus = (ApiCallStatus.holding).obs;
  var movieDetails = MovieDetailResponse().obs;
  var movieVideos = MovieVideosResponse().obs;
  var movieImages = MovieImagesResponse().obs;
  var movieCredits = MovieCreditsResponse().obs;

  @override
  void onReady() {
    fetchMovieData();
    super.onReady();
  }

  void fetchMovieDetails() async {
    try {
      movieDetailsStatus(ApiCallStatus.loading);
      var response = await movieDetailsRepo.fetchMovieDetails(movieId);
      movieDetails(
          MovieDetailResponse.fromJson(jsonDecode(jsonEncode(response))));
      movieDetailsStatus(ApiCallStatus.success);
    } catch (e) {
      movieDetailsStatus(ApiCallStatus.error);
    }
  }

  void fetchMovieVideos() async {
    try {
      movieVideosStatus(ApiCallStatus.loading);
      var response = await movieDetailsRepo.fetchMovieVideos(movieId);
      movieVideos(
          MovieVideosResponse.fromJson(jsonDecode(jsonEncode(response))));
      movieVideosStatus(ApiCallStatus.success);
    } catch (e) {
      movieVideosStatus(ApiCallStatus.error);
    }
  }

  void fetchMovieImages() async {
    try {
      movieImagesStatus(ApiCallStatus.loading);
      var response = await movieDetailsRepo.fetchMovieImages(movieId);
      movieImages(
          MovieImagesResponse.fromJson(jsonDecode(jsonEncode(response))));
      movieImagesStatus(ApiCallStatus.success);
    } catch (e) {
      movieImagesStatus(ApiCallStatus.error);
    }
  }

  void fetchMovieCredits() async {
    try {
      movieCreditsStatus(ApiCallStatus.loading);
      var response = await movieDetailsRepo.fetchMovieCredits(movieId);
      movieCredits(
          MovieCreditsResponse.fromJson(jsonDecode(jsonEncode(response))));
      movieCreditsStatus(ApiCallStatus.success);
    } catch (e) {
      movieCreditsStatus(ApiCallStatus.error);
    }
  }

  fetchMovieData() {
    fetchMovieDetails();
    fetchMovieVideos();
    fetchMovieImages();
    fetchMovieCredits();
  }
}
