import 'package:flutter/material.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/screens/enter_screen.dart';
import 'package:provider/provider.dart';

class EnterScreenPageSettings {
  final bool isFromBalanceData;
  final dynamic balanceData;
  final String? category;
  final String? secondaryCategory;

  EnterScreenPageSettings._(
      {this.balanceData, this.category, this.secondaryCategory, this.isFromBalanceData = false,});

  factory EnterScreenPageSettings.withBalanceData(dynamic balanceData) {
    return EnterScreenPageSettings._(balanceData: balanceData, isFromBalanceData: true);
  }
  factory EnterScreenPageSettings.withCategories(
      {String? category, String? secondaryCategory,}) {
    return EnterScreenPageSettings._(category: category, secondaryCategory: secondaryCategory);
  }
}

class EnterScreenPage extends Page {
  final EnterScreenPageSettings settings;
  const EnterScreenPage(this.settings) : super();

  @override
  Route createRoute(BuildContext context) {
    final enterScreenProvider = ChangeNotifierProvider<EnterScreenProvider>(
      create: (_) {
        if (settings.isFromBalanceData) {
          return EnterScreenProvider.fromBalanceData(settings.balanceData);
        } else {
          return EnterScreenProvider(
            category: settings.category ??
                "None",
            secondaryCategory: settings.secondaryCategory ??
                "None",
          );
        }
      },
      child: const EnterScreen(),
    );
    // TODO: implement createRoute
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
        final curveTween = CurveTween(curve: Curves.easeInOut);
        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: enterScreenProvider,
        );
      },
    );
  }
  
}
