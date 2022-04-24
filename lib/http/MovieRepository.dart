import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/http/ApiManager.dart';
import 'package:movies_db/model/movie_credits_response.dart';
import 'package:movies_db/model/movie_detail_response.dart';
import 'package:movies_db/model/movie_images_response.dart';
import 'package:movies_db/model/movie_videos_response.dart';
import 'package:movies_db/model/person_details_response.dart';
import 'package:movies_db/utils/Constants.dart';

import '../model/MovieListResponse.dart';

class MovieRepository {
  ApiManager _helper = ApiManager();

  FutureProvider getNowPlayingMovies() =>
      getMovieListRP(Constants.GET_NOW_PLAYING);

  FutureProvider getMostPopularMovies() =>
      getMovieListRP(Constants.GET_MOST_POPULAR);

  FutureProvider getUpcomingMovies() =>
      getMovieListRP(Constants.GET_UPCOMING_MOVIES);

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

  FutureProvider getMovieListRP(requestedUrl) {
    return _helper.getDioResponse(requestedUrl);
  }

  FutureProvider getPersonDetail(personId) {
    return _helper.getDioResponse("${Constants.GET_PERSON_DETAILS}/$personId");
  }
}
