import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_db/components/api_status_widgets_handler.dart';
import 'package:movies_db/controllers/movie_details_controller.dart';
import 'package:movies_db/model/movie_credits_response.dart';
import 'package:movies_db/model/movie_detail_response.dart';
import 'package:movies_db/model/movie_images_response.dart';
import 'package:movies_db/model/movie_videos_response.dart';
import 'package:movies_db/ui/person_detail_page.dart';
import 'package:movies_db/utils/AppUtils.dart';
import 'package:movies_db/utils/AppWidgets.dart';
import 'package:intl/intl.dart';
import 'package:movies_db/utils/Constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({Key? key}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var movieDetailsController = Get.put(MovieDetailsController());

  @override
  void initState() {
    super.initState();
    movieDetailsController.movieId(Get.arguments);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppWidgets.appBar(context, "Movie Detail"),
        body: Obx(() => ApiStatusWidgetsHandler(
            apiCallStatus: movieDetailsController.movieDetailsStatus.value,
            loadingWidget: () => AppWidgets.progressIndicator(),
            errorWidget: () => Center(child: Text("Something went wrong!")),
            successWidget: () => _movieDetailLayout(
                context, movieDetailsController.movieDetails.value))));
  }

  Widget _movieDetailLayout(
    BuildContext context,
    MovieDetailResponse movie,
  ) {
    var _movieTitle = movie.title ?? "";
    var _releaseYear = "";
    if (movie.releaseDate != null)
      _releaseYear = DateFormat.y().format(DateTime.parse(movie.releaseDate!));
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
              "$_movieRating    $_runtime",
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
        Container(
          margin: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 30),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(
              25.0,
            ),
          ),
          child: DefaultTabController(
              length: 2,
              child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: Colors.green,
                  ),
                  unselectedLabelColor: Colors.black87,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.video_library),
                    ),
                    Tab(
                      icon: Icon(Icons.photo_library),
                    ),
                  ])),
        ),
        SizedBox(
          height: 250,
          child: TabBarView(
            controller: _tabController,
            children: [
              Obx(() => ApiStatusWidgetsHandler(
                  apiCallStatus: movieDetailsController.movieVideosStatus.value,
                  loadingWidget: () => AppWidgets.progressIndicator(),
                  errorWidget: () =>
                      Center(child: Text("Something went wrong!")),
                  successWidget: () => _movieVideoListHorizontal("Media",
                      movieDetailsController.movieVideos.value.results ?? []))),
              Obx(() => ApiStatusWidgetsHandler(
                  apiCallStatus: movieDetailsController.movieImagesStatus.value,
                  loadingWidget: () => AppWidgets.progressIndicator(),
                  errorWidget: () =>
                      Center(child: Text("Something went wrong!")),
                  successWidget: () => _movieImagesListHorizontal(
                      "Media",
                      movieDetailsController.movieImages.value.backdrops ?? [],
                      movieDetailsController.movieImages.value.posters ?? []))),
            ],
          ),
        ),
        Obx(() => ApiStatusWidgetsHandler(
            apiCallStatus: movieDetailsController.movieCreditsStatus.value,
            loadingWidget: () => AppWidgets.progressIndicator(),
            errorWidget: () => Center(child: Text("Something went wrong!")),
            successWidget: () => _movieCastListHorizontal(
                  "Cast",
                  movieDetailsController.movieCredits.value.cast ?? [],
                ))),
      ],
    );
  }

  _posterAndVotes(MovieDetailResponse movie) => Row(
        children: [
          Flexible(
            child: Container(
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
            flex: 1,
          ),
          //Movie Poster
          Flexible(
            child: Container(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 5.0,
                            animation: true,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.transparent,
                            percent: (movie.voteAverage ?? 0) / 10,
                            center: Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Text(
                                  "${((movie.voteAverage ?? 0) * 10).toInt()}%",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppWidgets.textColor(context)),
                                ),
                              ],
                            ),
                            progressColor: AppUtils.setVotingProgressColor(
                                movie.voteAverage ?? 0),
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
            flex: 1,
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

  _movieVideoListHorizontal(String heading, List<Results> movieVideosList) {
    return Column(
      children: [
        Container(
            height: 250.0,
            child: ListView.builder(
                itemCount: movieVideosList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 300.0,
                      height: 200.0,
                      child: InkWell(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: YoutubePlayer(
                              controller: _youtubePlayerController(
                                  movieVideosList[index].key),
                              showVideoProgressIndicator: true,
                            ),
                          ),
                          //PopularPoster
                          SizedBox(height: 10),
                          Text(
                            "${movieVideosList[index].name}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppWidgets.textColor(context)),
                          ),
                        ],
                      )));
                }))
        // Horizontal List
      ],
    );
  }

  _movieCastListHorizontal(String heading, List<Cast> movieCastList) {
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
                          onTap: () {
                            Get.to(PersonDetailPage(
                                id: movieCastList[index].id as int));
                            /*Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                      value:
                                          BlocProvider.of<MovieCubit>(context),
                                      child: PersonDetailPage(
                                          id: movieCastList[index].id as int),
                                    )));*/
                          },
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
                                    errorWidget: (context, url, error) =>
                                        Container(
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

  _youtubePlayerController(String? key) => YoutubePlayerController(
        initialVideoId: key ?? "",
        flags: YoutubePlayerFlags(
            disableDragSeek: true,
            autoPlay: false,
            mute: true,
            useHybridComposition: true),
      );

  _movieImagesListHorizontal(String heading, List<Backdrops> backdropImageList,
      List<Posters> posterImageList) {
    List<Backdrops> _imageList = [];

    _imageList.addAll(backdropImageList);

    return Column(
      children: [
        // Container(
        //     margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        //     alignment: Alignment.centerLeft,
        //     child: AppWidgets.listHeadingBox(context, heading)),
        // List Heading
        Container(
            height: 250.0,
            child: ListView.builder(
                itemCount: _imageList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 300.0,
                      height: 200.0,
                      child: InkWell(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                imageUrl:
                                    "${Constants.imageUrlPrefix}/${_imageList[index].filePath}",
                                placeholder: (context, url) =>
                                    AppWidgets.progressIndicator(),
                                errorWidget: (context, url, error) => Container(
                                      width: 100.0,
                                      height: 150.0,
                                      child: Icon(Icons.error),
                                    )),
                          ),
                        ],
                      )));
                }))
        // Horizontal List
      ],
    );
  }
}
