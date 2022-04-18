import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/http/MovieRepository.dart';
import 'package:movies_db/model/person_details_response.dart';

import '../utils/Constants.dart';

final dioClientProvider = Provider<Dio>(
  (ref) => Dio(
    BaseOptions(baseUrl: Constants.urlPrefix),
  ),
);

class PersonDetailPage extends ConsumerStatefulWidget {
  final int id;

  const PersonDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _PersonDetailPageState createState() => _PersonDetailPageState(id);
}

class _PersonDetailPageState extends ConsumerState<PersonDetailPage> {
  final int personId;
  late FutureProvider personDetailProvider;

  _PersonDetailPageState(this.personId);

  @override
  void initState() {
    personDetailProvider = MovieRepository().getPersonDetail(personId);
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(personDetailProvider);

    return Scaffold(
        body: response.map(
      data: (data) {
        final person=PersonDetailsResponse.fromJson(jsonDecode(jsonEncode(data.value)));
        return Text(person.name.toString());
      },
      error: (data) => Text(data.error.toString()),
      loading: (data) => Text("Loading"),
    ));
  }
}
