import 'package:movies_db/model/movie_detail_response.dart';

abstract class MovieDataEvent {}

class MovieListingEvent extends MovieDataEvent {

  MovieListingEvent();
}
