import 'package:bloc/bloc.dart';
import 'package:movies_db/http/MovieRepository.dart';
import 'package:movies_db/model/MovieListResponse.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit(this._movieRepository) : super(InitialState());

  final MovieRepository _movieRepository;

  Future<void> getNowPlayingMovies() =>
      stateManager(_movieRepository.getNowPlayingMovies());

  Future<void> getMostPopularMovies() =>
      stateManager(_movieRepository.getMostPopularMovies());

  Future<void> getUpcomingMovies() =>
      stateManager(_movieRepository.getUpcomingMovies());

  Future<void> getMovieDetails(movieId) =>
      stateManager(_movieRepository.getMovieDetails(movieId));

  Future<void> getMovieVideos(movieId) =>
      stateManager(_movieRepository.getMovieVideos(movieId));


  Future<void> stateManager(dynamic movieResponse, {errMsg = ""}) async {
    try {
      emit(LoadingState());
      emit(ReceivedState(movieResponse));
    } on Exception {
      emit(ErrorState(errMsg));
    }
  }


}
