import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_db/http/MovieRepository.dart';
import 'package:movies_db/model/movie_detail_response.dart';
import 'package:movies_db/utils/AppTheme.dart';
import 'package:movies_db/utils/AppUtils.dart';
import 'package:movies_db/utils/AppWidgets.dart';
import 'package:intl/intl.dart';
import 'package:movies_db/utils/Constants.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
    var _movieTitle = movie?.title;
    var _releaseYear =
        DateFormat.y().format(DateTime.parse(movie!.releaseDate!));
    var _movieRating = AppUtils.getCertificateRating(movie.adult ?? false);
    var _runtime = AppUtils.getRuntimeInHrMin(movie.runtime ?? 0);

    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Text(
          "$_movieTitle ($_releaseYear)",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: AppWidgets.textColor(context)),
        ),
        //Movie Title
        SizedBox(
          height: 10,
        ),
        Text(
          "$_movieRating    •   $_runtime",
          style: TextStyle(fontSize: 15, color: AppWidgets.textColor(context)),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200.0,
              height: 250.0,
              alignment: Alignment.topLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: "${Constants.imageUrlPrefix}${movie.posterPath}",
                  placeholder: (context, url) => AppWidgets.progressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            //Movie Poster
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 5.0,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.transparent,
                      percent: movie.voteAverage! / 10,
                      center: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Text(
                            "${(movie.voteAverage! * 10).toInt()}%",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppWidgets.textColor(context)),
                          ),
                        ],
                      ),
                      progressColor:
                          AppUtils.setVotingProgressColor(movie.voteAverage!),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text("${movie.voteCount} votes",
                    style: TextStyle(
                        fontSize: 15, color: AppWidgets.textColor(context))),
              ],
            )
            //User Voting
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "Overview",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppWidgets.textColor(context)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          movie.overview ?? "",
          style: TextStyle(fontSize: 15, color: AppWidgets.textColor(context)),
        )
      ],
    );
  }
}
