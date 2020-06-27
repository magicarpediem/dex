class FilterKeys {
  FilterKeys({this.regions, this.types, this.searchQuery});
  List regions;
  List types;
  String searchQuery;

  @override
  String toString() {
    return 'FilterKeys{regions: $regions, types: $types, searchQuery: $searchQuery}';
  }
}
