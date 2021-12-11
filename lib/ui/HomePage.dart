import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_db/http/ApiManager.dart';
import 'package:movies_db/http/MovieRepository.dart';
import 'package:movies_db/utils/AppUtils.dart';
import 'package:movies_db/utils/AppWidgets.dart';
import 'package:movies_db/utils/Constants.dart';
import '../model/MovieListResponse.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  late Future<MovieListResponse> _nowPlayingMovies;
  late Future<MovieListResponse> _mostPopularMovies;
  late Future<MovieListResponse> _upcomingMovies;

  @override
  void initState() {
    super.initState();
    _nowPlayingMovies = MovieRepository().getNowPlayingMovies();
    _mostPopularMovies = MovieRepository().getMostPopularMovies();
    _upcomingMovies = MovieRepository().getUpcomingMovies();
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
        _nowPlayingSlider(),
        _movieListViewHorizontal("Popular", _mostPopularMovies),
        _movieListViewHorizontal("Upcoming", _upcomingMovies)
      ],
    );
  }

  _nowPlayingSlider() {
    return FutureBuilder<MovieListResponse>(
        future: _nowPlayingMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Stack(children: [
              SizedBox(
                height: 10,
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _setupNowPlayingSlider(snapshot.data!.results),
                  //_pagerIndicator(snapshot.data!.results), //Pager Indicator
                ],
              ),
              //SliderSetup
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.green),
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
        });
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
                                          AppUtils.setVotingProgressColor(movie.voteAverage!),
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

  _pagerIndicator(List<Results>? results) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: results!.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.white)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      );

  _movieListViewHorizontal(
      String heading, Future<MovieListResponse> movieList) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
            alignment: Alignment.centerLeft,
            child: AppWidgets.listHeadingBox(context,heading)),
        // List Heading
        Container(
            height: 250.0,
            child: FutureBuilder<MovieListResponse>(
                future: movieList,
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data?.results?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: EdgeInsets.only(left: 20),
                            width: 120.0,
                            height: 150.0,
                            child: InkWell(
                                onTap: () {
                                  _openMovieDetailScreen(
                                      snapshot.data?.results?[index].id);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${Constants.imageUrlPrefix}/${snapshot.data?.results?[index].posterPath}",
                                        placeholder: (context, url) =>
                                            AppWidgets.progressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    //PopularPoster
                                    SizedBox(height: 10),
                                    Text(
                                      "${snapshot.data?.results![index].title}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: AppWidgets.textColor(context)),
                                    )
                                  ],
                                )));
                      });
                }))
        // Horizontal List
      ],
    );
  }

  void _openMovieDetailScreen(int? id) {
    Navigator.of(context).pushNamed("/movieDetail", arguments: id);
  }
}
