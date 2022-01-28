import 'package:bloc/bloc.dart';
import 'package:movies_db/http/MovieRepository.dart';

part 'movie_state.dart';

const NOW_PLAYING_RC = 1;
const MOST_POPULAR_MOVIES_RC = 2;
const UPCOMING_MOVIES_RC = 3;
const MOVIE_DETAILS_RC = 4;
const MOVIE_CREDITS_RC = 5;
const MOVIE_VIDEOS_RC = 6;
const MOVIE_IMAGES_RC = 7;

class MovieCubit extends Cubit<MovieState> {
  MovieCubit(this._movieRepository) : super(InitialState());

  final MovieRepository _movieRepository;

  Future<void> getNowPlayingMovies() async => await stateManager(
      await _movieRepository.getNowPlayingMovies(), NOW_PLAYING_RC);

  Future<void> getMostPopularMovies() async => await stateManager(
      await _movieRepository.getMostPopularMovies(), MOST_POPULAR_MOVIES_RC);

  Future<void> getUpcomingMovies() async => await stateManager(
      await _movieRepository.getUpcomingMovies(), UPCOMING_MOVIES_RC);

  Future<void> getMovieDetails(movieId) async => await stateManager(
      await _movieRepository.getMovieDetails(movieId), MOVIE_DETAILS_RC);

  Future<void> getMovieCredits(movieId) async => await stateManager(
      await _movieRepository.getMovieCredits(movieId), MOVIE_CREDITS_RC);

  Future<void> getMovieVideos(movieId) async => await stateManager(
      await _movieRepository.getMovieVideos(movieId), MOVIE_VIDEOS_RC);

  Future<void> getMovieImages(movieId) async => await stateManager(
      await _movieRepository.getMovieImages(movieId), MOVIE_IMAGES_RC);

  Future<void> stateManager(dynamic movieResponse, int? requestCode,
      {errMsg = "Something went wrong!"}) async {
    try {
      emit(LoadingState(requestCode));
      emit(ReceivedState(await movieResponse, requestCode));
    } on Exception {
      emit(ErrorState(errMsg, requestCode));
    }
  }
}
