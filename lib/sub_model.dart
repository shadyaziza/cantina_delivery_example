class Sub {
  final String phoneNumber, subType;
  final List<String> productsKeys;

  Sub._(this.phoneNumber, this.subType, this.productsKeys);
  factory Sub.fromBloc(Map<String, dynamic> subMap) {
    ///not dealing wiht [Product]s for now, you should easily fetch the full data,
    ///I am just showing you the concept.
    return subMap == null
        ? null
        : Sub._(subMap['phoneNumber'], subMap['subType'], []);
  }
}
