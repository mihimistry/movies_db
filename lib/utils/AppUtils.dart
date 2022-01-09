import 'package:flutter/material.dart';

class AppUtils {
  static String getCertificateRating(bool _isAdult) {
    return _isAdult ? "R" : "12A";
  }

  static String getRuntimeInHrMin(int _runtime) {
    var _hours = _runtime ~/ 60;
    var _mins = _runtime - (_hours * 60);
    return _runtime > 0 ? "•   ${_hours}h${_mins}m" : "";
  }

  static Color setVotingProgressColor(num? voteAverage) {
    if (voteAverage! < 7.0 && voteAverage > 3.0)
      return Colors.orange;
    else if (voteAverage < 3.0)
      return Colors.redAccent;
    else
      return Colors.green;
  }
}
