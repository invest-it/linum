
import 'package:flutter/material.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository_dummy.dart';
import 'package:linum/core/budget/presentation/budget_service_impl.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/budget_screen/budget_routes.dart';
import 'package:linum/screens/budget_screen/budget_screen_viewmodel.dart';
import 'package:provider/provider.dart';

import 'pages/budget_edit_screen/budget_edit_screen.dart';
import 'pages/budget_splash_screen/budget_splash_screen.dart';
import 'pages/budget_view_screen/budget_view_screen.dart';
import 'pages/budget_wizard_screen/budget_wizard_screen.dart';



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
        final vm = context.read<BudgetScreenViewModel>();
        return ScreenSkeleton(
          head: 'Budget',
          body: Navigator(
            key: vm.navigatorKey,
            initialRoute: vm.getInitialRoute(),
            onGenerateRoute: (settings) {
              final page = switch(settings.name) {
                BudgetRoutes.splash => const BudgetSplashScreen(),
                BudgetRoutes.view => const BudgetViewScreen(),
                BudgetRoutes.edit => const BudgetEditScreen(),
                BudgetRoutes.wizard => const BudgetWizardScreen(),
                _ => throw StateError('Unexpected route name: ${settings.name}!'),
              };

              return MaterialPageRoute(
                  builder: (context) {
                    return page;
                  },
                  settings: settings
              );
            },
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
