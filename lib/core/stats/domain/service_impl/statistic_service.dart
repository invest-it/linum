import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:linum/core/balance/presentation/algorithm_service.dart';
import 'package:linum/core/balance/presentation/balance_data_service.dart';
import 'package:linum/core/stats/domain/generators/expense_statistics.dart';
import 'package:linum/core/stats/domain/models/expense_statistic.dart';
import 'package:linum/core/stats/domain/models/income_statistic.dart';
import 'package:linum/core/stats/domain/models/statistical_calculations.dart';
import 'package:linum/core/stats/presentation/statistics_service.dart';
import 'package:linum/features/currencies/core/presentation/exchange_rate_service.dart';

class StatisticServiceImpl with ChangeNotifier implements IStatisticsService {
  final IBalanceDataService _balanceDataService;
  final IExchangeRateService _exchangeRateService;
  final AlgorithmService _algorithmService;

  StatisticServiceImpl({
    required IBalanceDataService balanceDataService,
    required IExchangeRateService exchangeRateService,
    required AlgorithmService algorithmService,
  }) : _balanceDataService = balanceDataService,
        _exchangeRateService = exchangeRateService,
        _algorithmService = algorithmService {
    _balanceDataService.addListener(_onBalanceChange);
    _algorithmService.addListener(_onAlgorithmChange);
    _exchangeRateService.addListener(_onCurrencyChange);
    // TODO: Test if this works
  }

  @override
  Future<StatisticalCalculations> getStatisticalCalculations() async {
    final cachedValue = _cachedStatisticalCalculations;
    if (cachedValue != null) {
      return cachedValue;
    }

    final data = await _balanceDataService.getAllTransactions();
    final serialData = await _balanceDataService.getAllSerialTransactions();

    final stats = StatisticalCalculations(
      data: data,
      serialData: serialData,
      standardCurrencyName: _exchangeRateService.standardCurrency.name,
      algorithms: _algorithmService.state,
    );
    _cachedStatisticalCalculations = stats;
    return stats;
  }

  @override
  Future<IncomeStatistics> getSerialIncomeForMonth(DateTime month) async {
    final key = _getCacheKey(month);
    final cachedValue = _cachedSerialIncome?[key];
    if (cachedValue != null) {
      return cachedValue;
    }
    
    final transactions = await _balanceDataService.getTransactionsForMonth(month);
    final stats = generateSerialIncomeStatistics(transactions);
    _cachedSerialIncome?[key] = stats;
    return stats;
  }


  @override
  Future<ExpenseStatistics> getExpensesForCategory(String category, DateTime month) async {
    final key = _getCacheKey(month);
    final cachedValue = _cachedExpensesForCategory?[key];
    if (cachedValue != null) {
      return cachedValue;
    }

    final transactions = await _balanceDataService.getTransactionsForMonth(month);
    final stats = generateExpenseStatisticsForCategory(transactions, category);
    _cachedExpensesForCategory?[key] = stats;
    return stats;
  }

  @override
  Future<Map<String,ExpenseStatistics>> getExpensesForCategories(Set<String> categories, DateTime month) async {
    final key = _getCacheKey(month);
    final cachedValue = _cachedExpensesForCategories?[key];
    if (cachedValue != null) {
      return cachedValue;
    }

    final transactions = await _balanceDataService.getTransactionsForMonth(month);
    final stats = generateExpenseStatisticsForCategories(transactions, categories);
    _cachedExpensesForCategories?[key] = stats;
    return stats;
  }

  
  Map<String, Map<String, ExpenseStatistics>>? _cachedExpensesForCategories;
  Map<String, ExpenseStatistics>? _cachedExpensesForCategory;
  Map<String, IncomeStatistics>? _cachedSerialIncome;
  
  StatisticalCalculations? _cachedStatisticalCalculations;

  String _getCacheKey(DateTime date) => Jiffy.parseFromDateTime(date).yMMM;
  
  void _clearAlgorithmIndependentCache() {
    _cachedExpensesForCategories = null;
    _cachedExpensesForCategory = null;
    _cachedSerialIncome = null;
  }
  
  void _clearAlgorithmDependentCache() {
    _cachedStatisticalCalculations = null;
  }
  
  void _onAlgorithmChange() {
    _clearAlgorithmDependentCache();
    notifyListeners();
  }
  
  void _onBalanceChange() {
    _clearAlgorithmIndependentCache();
    _clearAlgorithmDependentCache();
    notifyListeners();
  }
  
  void _onCurrencyChange() {
    _onBalanceChange();
  }

  @override
  void dispose() {
    _balanceDataService.removeListener(_onBalanceChange);
    _algorithmService.removeListener(_onAlgorithmChange);
    _exchangeRateService.removeListener(_onCurrencyChange);
    super.dispose();
  }
}
