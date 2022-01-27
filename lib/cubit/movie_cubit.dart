import 'package:bloc/bloc.dart';
import 'package:movies_db/http/MovieRepository.dart';

part 'movie_state.dart';

const NOW_PLAYING_RC = 1;
const MOST_POPULAR_MOVIES_RC = 2;
const UPCOMING_MOVIES_RC = 3;

class MovieCubit extends Cubit<MovieState> {
  MovieCubit(this._movieRepository) : super(InitialState());

  final MovieRepository _movieRepository;

  Future<void> getNowPlayingMovies() async =>
      stateManager(await _movieRepository.getNowPlayingMovies(),
          requestCode: NOW_PLAYING_RC);

  Future<void> getMostPopularMovies() async =>
      stateManager(await _movieRepository.getMostPopularMovies(),
          requestCode: MOST_POPULAR_MOVIES_RC);

  Future<void> getUpcomingMovies() async =>
      stateManager(await _movieRepository.getUpcomingMovies(),
          requestCode: UPCOMING_MOVIES_RC);

  Future<void> getMovieDetails(movieId) async =>
      stateManager(await _movieRepository.getMovieDetails(movieId));

  Future<void> getMovieVideos(movieId) async =>
      stateManager(await _movieRepository.getMovieVideos(movieId));

  Future<void> stateManager(dynamic movieResponse,
      {errMsg = "", int? requestCode}) async {
    try {
      emit(LoadingState());
      emit(ReceivedState(movieResponse, requestCode));
    } on Exception {
      emit(ErrorState(errMsg));
    }
  }
}
