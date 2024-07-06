//  Sandbox Screen - Allows for easier feature building and testing while in debug mode
//
//  Author: damattl
//  Co-Author: n/a

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/enter_screen/enter_screen.dart';

class SandboxScreen extends StatelessWidget {
  const SandboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
      head: 'Sandbox',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EnterScreen(
              transaction: Transaction(
                name: 'Test',
                amount: 30,
                currency: 'EUR',
                category: 'none-income',
                date: Timestamp.fromDate(DateTime.now()),
              ),
            ),
          ],
        ),
      ),
      isInverted: true,
    );
  }
}
