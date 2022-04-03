extension MapDynamicToString on Map<dynamic, dynamic> {
  Map<String, String> dynamicToString() {
    return map((key, value) => MapEntry(key, value.toString()));
  }
}
