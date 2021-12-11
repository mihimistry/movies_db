import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_db/http/MovieRepository.dart';
import 'package:movies_db/model/movie_credits_response.dart';
import 'package:movies_db/model/movie_detail_response.dart';
import 'package:movies_db/utils/AppTheme.dart';
import 'package:movies_db/utils/AppUtils.dart';
import 'package:movies_db/utils/AppWidgets.dart';
import 'package:intl/intl.dart';
import 'package:movies_db/utils/Constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:readmore/readmore.dart';

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
  late Future<MovieCreditsResponse> _movieCredits;

  @override
  void initState() {
    super.initState();
    _movieDetail = MovieRepository().getMovieDetails(movieId);
    _movieCredits = MovieRepository().getMovieCredits(movieId);
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
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "$_movieTitle ($_releaseYear)",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: AppWidgets.textColor(context)),
            ),
            //Header #1
            SizedBox(
              height: 10,
            ),
            Text(
              "$_movieRating    •   $_runtime",
              style:
                  TextStyle(fontSize: 15, color: AppWidgets.textColor(context)),
            ),
            //Header #2
            SizedBox(height: 20),
            _posterAndVotes(movie),
            // Poster & Votes
            SizedBox(height: 30),
            _overview(movie.overview),
          ]),
        ),
        FutureBuilder<MovieCreditsResponse>(
          future: _movieCredits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _movieListViewHorizontal(
                  "Cast", snapshot.data?.cast ?? []);
            }

            return AppWidgets.progressIndicator();
          },
        )
      ],
    );
  }

  _posterAndVotes(MovieDetailResponse movie) => Row(
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
          Container(
            height: 250.0,
            margin: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          progressColor: AppUtils.setVotingProgressColor(
                              movie.voteAverage!),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("${movie.voteCount} votes",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppWidgets.textColor(context),
                        )),
                  ],
                ),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.play_circle_fill_outlined),
                    label: Text(
                      "Play trailer",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green))),
              ],
            ),
          ),
          //User Voting
        ],
      );

  _overview(String? overview) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.listHeadingBox(context, "Overview"),
          SizedBox(
            height: 10,
          ),
          ReadMoreText(
            overview ?? "",
            trimLines: 3,
            colorClickableText: Colors.green,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'more',
            trimExpandedText: 'less',
            style:
                TextStyle(fontSize: 15, color: AppWidgets.textColor(context)),
          )
        ],
      );

  _movieListViewHorizontal(String heading, List<Cast> movieCastList) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            alignment: Alignment.centerLeft,
            child: AppWidgets.listHeadingBox(context, heading)),
        // List Heading
        Container(
            height: 250.0,
            child: ListView.builder(
                itemCount: movieCastList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 100.0,
                      height: 125.0,
                      child: InkWell(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                imageUrl:
                                    "${Constants.imageUrlPrefix}/${movieCastList[index].profilePath}",
                                placeholder: (context, url) =>
                                    AppWidgets.progressIndicator(),
                                errorWidget: (context, url, error) => Container(
                                      width: 100.0,
                                      height: 150.0,
                                      child: Icon(Icons.error),
                                    )),
                          ),
                          //PopularPoster
                          SizedBox(height: 10),
                          Text(
                            "${movieCastList[index].name}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppWidgets.textColor(context)),
                          ),
                          //Original Name
                          SizedBox(height: 5),
                          Text(
                            "${movieCastList[index].character}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                color: AppWidgets.textColor(context)),
                          )
                          //Character Name
                        ],
                      )));
                }))
        // Horizontal List
      ],
    );
  }
}
