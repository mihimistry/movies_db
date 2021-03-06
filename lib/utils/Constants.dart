class Constants {
  static const urlPrefix = "https://api.themoviedb.org/3/";
  static const imageUrlPrefix = "https://image.tmdb.org/t/p/original";
  static const apiKey = "23df7360ea113e0163319b9e034fb550";

  //Home
  static const GET_NOW_PLAYING = "movie/now_playing";
  static const GET_MOST_POPULAR = "movie/popular";
  static const GET_UPCOMING_MOVIES = "movie/upcoming";

  //Movie Details
  static const GET_MOVIE_DETAILS = "movie"; //"/movie/{movie_id}
  static const GET_MOVIE_CREDITS = "credits"; //"/movie/{movie_id}/credits"
  static const GET_MOVIE_VIDEOS = "videos"; //"/movie/{movie_id}/videos"
  static const GET_MOVIE_IMAGES = "images"; //"/movie/{movie_id}/images"

  //Person Details
  static const GET_PERSON_DETAILS = "person"; //"/person/{person_id}"

}
