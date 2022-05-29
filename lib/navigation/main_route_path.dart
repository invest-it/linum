abstract class MainRoutePath {}

class HomeScreenPath extends MainRoutePath {}
class BudgetScreenPath extends MainRoutePath {}
class StatisticsScreenPath extends MainRoutePath {}
class SettingsScreenPath extends MainRoutePath {}


abstract class MainRoutePaths {
  static const String budget = "budget";
  static const String statistics = "statistics";
  static const String settings = "settings";
}
