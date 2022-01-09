class MovieImagesResponse {
  MovieImagesResponse({
      this.id, 
      this.backdrops, 
      this.posters,});

  MovieImagesResponse.fromJson(dynamic json) {
    id = json['id'];
    if (json['backdrops'] != null) {
      backdrops = [];
      json['backdrops'].forEach((v) {
        backdrops?.add(Backdrops.fromJson(v));
      });
    }
    if (json['posters'] != null) {
      posters = [];
      json['posters'].forEach((v) {
        posters?.add(Posters.fromJson(v));
      });
    }
  }
  int? id;
  List<Backdrops>? backdrops;
  List<Posters>? posters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (backdrops != null) {
      map['backdrops'] = backdrops?.map((v) => v.toJson()).toList();
    }
    if (posters != null) {
      map['posters'] = posters?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Posters {
  Posters({
      this.aspectRatio, 
      this.filePath, 
      this.height, 
      this.iso6391, 
      this.voteAverage, 
      this.voteCount, 
      this.width,});

  Posters.fromJson(dynamic json) {
    aspectRatio = json['aspect_ratio'];
    filePath = json['file_path'];
    height = json['height'];
    iso6391 = json['iso_639_1'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    width = json['width'];
  }
  num? aspectRatio;
  String? filePath;
  int? height;
  String? iso6391;
  double? voteAverage;
  int? voteCount;
  int? width;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['aspect_ratio'] = aspectRatio;
    map['file_path'] = filePath;
    map['height'] = height;
    map['iso_639_1'] = iso6391;
    map['vote_average'] = voteAverage;
    map['vote_count'] = voteCount;
    map['width'] = width;
    return map;
  }

}

class Backdrops {
  Backdrops({
      this.aspectRatio, 
      this.filePath, 
      this.height, 
      this.iso6391, 
      this.voteAverage, 
      this.voteCount, 
      this.width,});

  Backdrops.fromJson(dynamic json) {
    aspectRatio = json['aspect_ratio'];
    filePath = json['file_path'];
    height = json['height'];
    iso6391 = json['iso_639_1'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    width = json['width'];
  }
  num? aspectRatio;
  String? filePath;
  int? height;
  dynamic iso6391;
  double? voteAverage;
  int? voteCount;
  int? width;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['aspect_ratio'] = aspectRatio;
    map['file_path'] = filePath;
    map['height'] = height;
    map['iso_639_1'] = iso6391;
    map['vote_average'] = voteAverage;
    map['vote_count'] = voteCount;
    map['width'] = width;
    return map;
  }

}