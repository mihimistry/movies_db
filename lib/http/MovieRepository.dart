import 'dart:convert';

import 'package:movies_db/http/ApiManager.dart';
import 'package:movies_db/model/movie_credits_response.dart';
import 'package:movies_db/model/movie_detail_response.dart';
import 'package:movies_db/model/movie_images_response.dart';
import 'package:movies_db/model/movie_videos_response.dart';
import 'package:movies_db/utils/Constants.dart';

import '../model/MovieListResponse.dart';

class MovieRepository {
  ApiManager _helper = ApiManager();

  Future<MovieListResponse> getNowPlayingMovies() async =>
      getMovieList(Constants.GET_NOW_PLAYING);

  Future<MovieListResponse> getMostPopularMovies() async {
    return getMovieList(Constants.GET_MOST_POPULAR);
  }

  Future<MovieListResponse> getUpcomingMovies() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    return getMovieList(Constants.GET_UPCOMING_MOVIES);
  }

  Future<MovieDetailResponse> getMovieDetails(movieId) async {
    final response =
        await _helper.getResponse("${Constants.GET_MOVIE_DETAILS}/$movieId");
    return MovieDetailResponse.fromJson(response);
  }

  Future<MovieVideosResponse> getMovieVideos(movieId) async {
    final response = await _helper.getResponse(
        "${Constants.GET_MOVIE_DETAILS}/$movieId/${Constants.GET_MOVIE_VIDEOS}");
    return MovieVideosResponse.fromJson(response);
  }

  Future<MovieImagesResponse> getMovieImages(movieId) async {
    final response = await _helper.getResponse(
        "${Constants.GET_MOVIE_DETAILS}/$movieId/${Constants.GET_MOVIE_IMAGES}");
    return MovieImagesResponse.fromJson(response);
  }

  Future<MovieCreditsResponse> getMovieCredits(movieId) async {
    final response = await _helper.getResponse(
        "${Constants.GET_MOVIE_DETAILS}/$movieId/${Constants.GET_MOVIE_CREDITS}");
    return MovieCreditsResponse.fromJson(response);
  }

  Future<MovieListResponse> getMovieList(requestedUrl) async {
    final response = await _helper.getResponse(requestedUrl);
    return MovieListResponse.fromJson(response);
  }
}
