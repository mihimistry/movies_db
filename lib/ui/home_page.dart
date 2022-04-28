import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/cubit/movie_cubit.dart';
import 'package:movies_db/utils/AppUtils.dart';
import 'package:movies_db/utils/AppWidgets.dart';
import 'package:movies_db/utils/Constants.dart';
import '../data/MovieRepository.dart';
import '../model/MovieListResponse.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'movie_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final CarouselController _controller = CarouselController();

  MovieListResponse? _nowPlayingMovies;
  MovieListResponse? _mostPopularMovies;
  MovieListResponse? _upcomingMovies;
  late MovieRepository _movieRepository;
  late FutureProvider nowPlayingMoviesProvider;
  late FutureProvider mostPopularMoviesProvider;
  late FutureProvider upcomingMoviesProvider;

  @override
  void initState() {
    super.initState();
    _movieRepository = MovieRepository();
    nowPlayingMoviesProvider = _movieRepository.getNowPlayingMovies();
    mostPopularMoviesProvider=_movieRepository.getMostPopularMovies();
    upcomingMoviesProvider=_movieRepository.getUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppWidgets.appBar(context, "MoviesDb"),
      body: Builder(builder: (context) => homePageLayout()),
    );
  }

  Widget homePageLayout() {
    return ListView(
      children: [
        SizedBox(height: 20),
        ref.watch(nowPlayingMoviesProvider).map(
              data: (data) {
                _nowPlayingMovies = MovieListResponse.fromJson(
                    jsonDecode(jsonEncode(data.value)));
                return _nowPlayingSlider(_nowPlayingMovies);
              },
              error: (e) => Center(child: Text(e.error.toString())),
              loading: (_) => Center(child: AppWidgets.progressIndicator()),
            ),
        ref.watch(mostPopularMoviesProvider).map(
              data: (data) {
                _mostPopularMovies = MovieListResponse.fromJson(
                    jsonDecode(jsonEncode(data.value)));
                return _movieListViewHorizontal("Popular", _mostPopularMovies);
              },
              error: (e) => Text(e.error.toString()),
              loading: (_) => Center(child: AppWidgets.progressIndicator()),
            ),
        ref.watch(upcomingMoviesProvider).map(
              data: (data) {
                _upcomingMovies = MovieListResponse.fromJson(
                    jsonDecode(jsonEncode(data.value)));
                return _movieListViewHorizontal("Upcoming", _upcomingMovies);
              },
              error: (e) => Text(e.error.toString()),
              loading: (_) => Center(child: AppWidgets.progressIndicator()),
            ),
      ],
    );
  }

  _nowPlayingSlider(MovieListResponse? response) {
    if (response != null)
      return Stack(children: [
        SizedBox(
          height: 10,
        ),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            _setupNowPlayingSlider(response.results),
            //_pagerIndicator(snapshot.data!.results), //Pager Indicator
          ],
        ),
        //SliderSetup
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration:
                  BoxDecoration(shape: BoxShape.rectangle, color: Colors.green),
              child: Text(
                "Now playing",
                style: TextStyle(color: Colors.white),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
            )
          ],
        ),
        //Now playing
      ]);
    else
      return Center(child: AppWidgets.progressIndicator());
  }

  _setupNowPlayingSlider(List<Results>? results) => CarouselSlider(
        items: _getItemList(results),
        carouselController: _controller,
        options: CarouselOptions(
          aspectRatio: 5 / 6,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 2500),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          /*onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },*/
        ),
      );

  List<Widget> _getItemList(List<Results>? results) {
    return results!
        .map((movie) => Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: InkWell(
                        onTap: () => _openMovieDetailScreen(movie.id),
                        child: Stack(
                          children: [
                            Image(
                              image: NetworkImage(
                                  "${Constants.imageUrlPrefix}/${movie.posterPath}"),
                              fit: BoxFit.contain,
                            ),
                            //Movie Poster
                            Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black
                                ]))),
                            //SliderGradient
                            Container(
                                alignment: Alignment.bottomLeft,
                                margin: EdgeInsets.only(bottom: 40, left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 35.0,
                                      lineWidth: 3.0,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      backgroundColor: Colors.transparent,
                                      percent: movie.voteAverage! / 10,
                                      center: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Text(
                                            "${(movie.voteAverage! * 10).toInt()}%",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      progressColor:
                                          AppUtils.setVotingProgressColor(
                                              movie.voteAverage!),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      movie.title!,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    //MovieTitle
                                  ],
                                 )),
                          ],
                        ),
                      )),
                );
              },
            ))
        .toList();
  }

  _movieListViewHorizontal(String heading, MovieListResponse? response) {
    if (response != null)
      return Column(
        children: [
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
              alignment: Alignment.centerLeft,
              child: AppWidgets.listHeadingBox(context, heading)),
          // List Heading
          Container(
              height: 250.0,
              child: ListView.builder(
                  itemCount: response.results?.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.only(left: 20),
                        width: 120.0,
                        height: 150.0,
                        child: InkWell(
                            onTap: () {
                              _openMovieDetailScreen(
                                  response.results?[index].id);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${Constants.imageUrlPrefix}/${response.results?[index].posterPath}",
                                    placeholder: (context, url) =>
                                        AppWidgets.progressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                //PopularPoster
                                SizedBox(height: 10),
                                Text(
                                  "${response.results![index].title}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppWidgets.textColor(context)),
                                )
                              ],
                            )));
                  }))
          // Horizontal List
        ],
      );
    else
      return Center(child: AppWidgets.progressIndicator());
  }

  void _openMovieDetailScreen(int? id) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
              value: BlocProvider.of<MovieCubit>(context),
              child: MovieDetailPage(id: id as int),
            )));
  }
}
