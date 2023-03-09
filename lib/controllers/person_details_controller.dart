import 'dart:convert';
import 'package:get/get.dart';
import 'package:movies_db/data/MovieRepository.dart';
import '../model/person_details_response.dart';
import '../services/api_call_status.dart';

class PersonDetailsController extends GetxController {
  var personDetailsRepo = MovieRepository();

  var personId = 0.obs;
  var personDetailsStatus = (ApiCallStatus.holding).obs;
  var personDetails = PersonDetailsResponse().obs;

  @override
  void onReady() {
    fetchPersonDetails();
    super.onReady();
  }

  void fetchPersonDetails() async {
    try {
      personDetailsStatus(ApiCallStatus.loading);
      var response = await personDetailsRepo.fetchPersonDetails(personId);
      personDetails(
          PersonDetailsResponse.fromJson(jsonDecode(jsonEncode(response))));
      personDetailsStatus(ApiCallStatus.success);
    } catch (e) {
      personDetailsStatus(ApiCallStatus.error);
    }
  }
}
