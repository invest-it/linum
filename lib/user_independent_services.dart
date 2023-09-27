import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:provider/provider.dart';

/// All services that do not depend on a signed in user are defined here.
class UserIndependentServices extends StatelessWidget {
  final Widget child;
  const UserIndependentServices({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventService(),
        ),
        ChangeNotifierProvider<AuthenticationService>(
          create: (context) => AuthenticationService(
            FirebaseAuth.instance,
            languageCode: languageCode,
            eventService: context.read(),
          ),
        ),
        ChangeNotifierProvider<AlgorithmService>(
          create: (context) => AlgorithmService(),
        ),
        ChangeNotifierProvider<ActionLipViewModel>(
          create: (_) => ActionLipViewModel(),
        ),

      ],
      child: child,
    );
  }
}
