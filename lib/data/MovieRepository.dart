import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/data/ApiManager.dart';
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
      getMovieList(Constants.GET_NOW_PLAYING);

  FutureProvider getMostPopularMovies() =>
      getMovieList(Constants.GET_MOST_POPULAR);

  FutureProvider getUpcomingMovies() =>
      getMovieList(Constants.GET_UPCOMING_MOVIES);

  FutureProvider getMovieDetails(movieId) =>
      _helper.getDioResponse("${Constants.GET_MOVIE_DETAILS}/$movieId");

  FutureProvider getMovieVideos(movieId) => _helper.getDioResponse(
      "${Constants.GET_MOVIE_DETAILS}/$movieId/${Constants.GET_MOVIE_VIDEOS}");

  FutureProvider getMovieImages(movieId) => _helper.getDioResponse(
      "${Constants.GET_MOVIE_DETAILS}/$movieId/${Constants.GET_MOVIE_IMAGES}");

  FutureProvider getMovieCredits(movieId) => _helper.getDioResponse(
      "${Constants.GET_MOVIE_DETAILS}/$movieId/${Constants.GET_MOVIE_CREDITS}");

  FutureProvider getMovieList(requestedUrl) {
    return _helper.getDioResponse(requestedUrl);
  }

  FutureProvider getPersonDetail(personId) {
    return _helper.getDioResponse("${Constants.GET_PERSON_DETAILS}/$personId");
  }
}
