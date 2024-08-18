
import 'package:flutter/material.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository_dummy.dart';
import 'package:linum/core/budget/presentation/budget_service_impl.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/budget_screen/budget_screen_viewmodel.dart';
import 'package:provider/provider.dart';



class BudgetScreen extends StatelessWidget {
  const BudgetScreen();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BudgetScreenViewModel>(
      create: (context) {
        return BudgetScreenViewModel(
          service: BudgetServiceImpl(
            repository: BudgetRepositoryDummy(),
          ),
        );
      },
      builder: (context, child) {
        return ScreenSkeleton(
          head: 'Budget',
          body: Navigator(
            key: context.read<BudgetScreenViewModel>().navigatorKey,
          ),
        );
      },
    );
  }

}


/*enum BudgetSubScreens { plan, remaining }

///  Budget Screen
///  Screen listing all Balances ever made without any filtering (future entries not recognized).
///  Page Index: 1
class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AlgorithmService algorithmService = context.watch<AlgorithmService>();

    if (algorithmService.state.filter == Filters.noFilter) {
      algorithmService.resetCurrentShownMonth();
      algorithmService.setCurrentFilterAlgorithm(
        Filters.inBetween(timestampsFromNow()),
      );
    }

    return ScreenSkeleton(
      head: 'Budget',
      leadingAction: AppBarAction.fromPreset(DefaultAction.academy),
      actions: [
        AppBarAction.fromPreset(
          DefaultAction.bugreport,
        ),
      ],
      isInverted: true,
      body: Column(
        children: [
          TabBar(
            padding: const EdgeInsets.symmetric(vertical: 12),
            dividerHeight: 0,
            controller: _tabController,
            tabs: const [
              Tab(
                text: "Plan",
              ),
              Tab(
                text: "Remaining",
              ),
            ],
          ),
          const SizedBox(height: 10),
          BalanceDataStreamConsumer3<IExchangeRateService, AlgorithmService, StatisticalCalculations>(
            transformer: (snapshot, exchangeRateService, algorithmService) async {
              return generateStatistics(
                snapshot: snapshot,
                algorithms: algorithmService.state,
                exchangeRateService: exchangeRateService,
              );
            },
            builder: (context, snapshot, child) {
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState ==
                      ConnectionState.waiting) {
                return const Expanded(child: LoadingSpinner());
              }
              return ChangeNotifierProvider<BudgetScreenViewModel>(
                create: (context) { return BudgetScreenViewModel(snapshot.requireData); },
                child: child,
              );
            },
            child: Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  PlanTab(),
                  RemainingTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
