import 'package:movies_db/utils/Constants.dart';
import 'ApiService.dart';

class MovieRepository {
  var _apiService = APIService();

  Future<dynamic> fetchNowPlaying() =>
      getApiResponse(Constants.GET_NOW_PLAYING);

  Future<dynamic> fetchPopularMovies() =>
      getApiResponse(Constants.GET_MOST_POPULAR);

  Future<dynamic> fetchUpcomingMovies() =>
      getApiResponse(Constants.GET_UPCOMING_MOVIES);

  Future<dynamic> fetchMovieDetails(movieId) =>
      getApiResponse("${Constants.GET_MOVIE_DETAILS}/$movieId");

  Future<dynamic> fetchMovieVideos(movieId) => getApiResponse(
      "${Constants.GET_MOVIE_DETAILS}/$movieId/${Constants.GET_MOVIE_VIDEOS}");

  Future<dynamic> fetchMovieImages(movieId) => getApiResponse(
      "${Constants.GET_MOVIE_DETAILS}/$movieId/${Constants.GET_MOVIE_IMAGES}");

  Future<dynamic> fetchMovieCredits(movieId) => getApiResponse(
      "${Constants.GET_MOVIE_DETAILS}/$movieId/${Constants.GET_MOVIE_CREDITS}");

  Future<dynamic> fetchPersonDetails(personId) => getApiResponse(
      "${Constants.GET_PERSON_DETAILS}/$personId}");

  Future<dynamic> getApiResponse(requestedUrl) {
    return _apiService.getResponse(requestedUrl);
  }
}
