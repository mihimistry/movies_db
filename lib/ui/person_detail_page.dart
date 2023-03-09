import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../components/api_status_widgets_handler.dart';
import '../controllers/person_details_controller.dart';
import '../utils/AppWidgets.dart';
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

  var personDetailsController = Get.put(PersonDetailsController());

  _PersonDetailPageState(this.personId);

  @override
  void initState() {
    personDetailsController.personId(personId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => ApiStatusWidgetsHandler(
            apiCallStatus: personDetailsController.personDetailsStatus.value,
            loadingWidget: () => AppWidgets.progressIndicator(),
            errorWidget: () => Center(child: Text("Something went wrong!")),
            successWidget: () => Text(
                personDetailsController.personDetails.value.name.toString()))));
  }
}
