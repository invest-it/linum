class MainRoutePath {
  final Uri uri;
  final int? id;

  MainRoutePath.home() : uri = Uri(path: "/"), id = null;
  MainRoutePath.budget() : uri = Uri(path: "/budget"), id = null;
  MainRoutePath.statistics() : uri = Uri(path: "/statistics"), id = null;
  MainRoutePath.settings(): uri = Uri(path: "/settings"), id = null;
  MainRoutePath.unknown(): uri = Uri(path: "/unknown"), id = null;

  bool get isHome => uri == MainRoutePath.home().uri;
  bool get isBudget => uri == MainRoutePath.budget().uri;
  bool get isStatistics => uri == MainRoutePath.statistics().uri;
  bool get isSettings => uri == MainRoutePath.settings().uri;
  bool get isUnknown => uri == MainRoutePath.unknown().uri;

  static bool compareFirst(Uri uri, Uri comparedUri) {
    if (uri.pathSegments.isEmpty) {
      return false;
    }
    if (uri.pathSegments[0] == comparedUri.pathSegments[0]) {
      return true;
    }
    return false;
  }
}
