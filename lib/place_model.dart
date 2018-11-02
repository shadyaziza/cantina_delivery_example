class Place {
  final String uid, name;

  Place._(this.uid, this.name);
  factory Place.fromBloc(Map<String, dynamic> placeMap, String placeId) {
    return placeMap == null ? null : Place._(placeId, placeMap['name']);
  }
}
