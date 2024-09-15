import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/balance/presentation/algorithm_service.dart';
import 'package:linum/core/balance/presentation/balance_data_service.dart';
import 'package:linum/core/stats/statistical_calculations.dart';
import 'package:linum/features/currencies/core/presentation/exchange_rate_service.dart';

class StatisticService extends IProvidableService {
  final IBalanceDataService _balanceDataService;
  final IExchangeRateService _exchangeRateService;
  final AlgorithmService _algorithmService;

  StatisticService({
    required IBalanceDataService balanceDataService,
    required IExchangeRateService exchangeRateService,
    required AlgorithmService algorithmService,
  }) : _balanceDataService = balanceDataService,
        _exchangeRateService = exchangeRateService,
        _algorithmService = algorithmService {
    _balanceDataService.addListener(notifyListeners);
    _algorithmService.addListener(notifyListeners);
    // TODO: Test if this works
  }

  Future<StatisticalCalculations> generateStatistics() async {
    final data = await _balanceDataService.getAllTransactions();
    final serialData = await _balanceDataService.getAllSerialTransactions();

    return StatisticalCalculations(
      data: data,
      serialData: serialData,
      standardCurrencyName: _exchangeRateService.standardCurrency.name,
      algorithms: _algorithmService.state,
    );
  }

  @override
  void dispose() {
    _balanceDataService.removeListener(notifyListeners);
    _algorithmService.removeListener(notifyListeners);
    super.dispose();
  }
}
