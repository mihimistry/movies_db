class PersonDetailsResponse {
  PersonDetailsResponse({
      this.birthday, 
      this.knownForDepartment, 
      this.deathday, 
      this.id, 
      this.name, 
      this.alsoKnownAs, 
      this.gender, 
      this.biography, 
      this.popularity, 
      this.placeOfBirth, 
      this.profilePath, 
      this.adult, 
      this.imdbId, 
      this.homepage,});

  PersonDetailsResponse.fromJson(dynamic json) {
    birthday = json['birthday'];
    knownForDepartment = json['known_for_department'];
    deathday = json['deathday'];
    id = json['id'];
    name = json['name'];
    alsoKnownAs = json['also_known_as'] != null ? json['also_known_as'].cast<String>() : [];
    gender = json['gender'];
    biography = json['biography'];
    popularity = json['popularity'];
    placeOfBirth = json['place_of_birth'];
    profilePath = json['profile_path'];
    adult = json['adult'];
    imdbId = json['imdb_id'];
    homepage = json['homepage'];
  }
  String? birthday;
  String? knownForDepartment;
  dynamic deathday;
  int? id;
  String? name;
  List<String>? alsoKnownAs;
  int? gender;
  String? biography;
  double? popularity;
  String? placeOfBirth;
  String? profilePath;
  bool? adult;
  String? imdbId;
  dynamic homepage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['birthday'] = birthday;
    map['known_for_department'] = knownForDepartment;
    map['deathday'] = deathday;
    map['id'] = id;
    map['name'] = name;
    map['also_known_as'] = alsoKnownAs;
    map['gender'] = gender;
    map['biography'] = biography;
    map['popularity'] = popularity;
    map['place_of_birth'] = placeOfBirth;
    map['profile_path'] = profilePath;
    map['adult'] = adult;
    map['imdb_id'] = imdbId;
    map['homepage'] = homepage;
    return map;
  }

}