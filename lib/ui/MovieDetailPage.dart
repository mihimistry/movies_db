import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_db/http/MovieRepository.dart';
import 'package:movies_db/model/movie_detail_response.dart';
import 'package:movies_db/utils/AppWidgets.dart';
import 'package:intl/intl.dart';
import 'package:movies_db/utils/Constants.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;

  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState(id);
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  var movieId;

  _MovieDetailPageState(this.movieId);

  late Future<MovieDetailResponse> _movieDetail;

  @override
  void initState() {
    super.initState();
    _movieDetail = MovieRepository().getMovieDetails(movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(context, "Movie Detail"),
      body: Container(
          child: FutureBuilder<MovieDetailResponse>(
        future: _movieDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _movieDetailLayout(context, snapshot.data);
          }

          return AppWidgets.progressIndicator();
        },
      )),
    );
  }

  Widget _movieDetailLayout(
    BuildContext context,
    MovieDetailResponse? movie,
  ) {
    var movieTitle = movie?.title;
    var releaseYear =
        DateFormat.y().format(DateTime.parse(movie!.releaseDate!));

    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Text(
          "$movieTitle ($releaseYear)",
          style: TextStyle(fontSize: 20, color: AppWidgets.textColor(context)),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: 120.0,
          height: 150.0,
          alignment: Alignment.topLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: "${Constants.imageUrlPrefix}${movie.posterPath}",
              placeholder: (context, url) => AppWidgets.progressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        )
      ],
    );
  }
}
