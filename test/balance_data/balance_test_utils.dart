import 'dart:math' as math;

import 'package:linum/core/balance/domain/balance_data_repository.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/domain/repository_impl/balance_data_repository_impl.dart';
import 'package:linum/core/balance/ports/firebase/balance_document.dart';
import 'package:linum/core/balance/ports/firebase/firebase_test_balance_adapter.dart';
import 'package:linum/core/balance/presentation/balance_data_service.dart';
import 'package:linum/core/balance/presentation/balance_data_service_impl.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';

Future<IBalanceDataRepository> createRepo(BalanceDocument doc) async {
  final repo = BalanceDataRepositoryImpl(
    adapter: FirebaseTestBalanceAdapter(
      doc: doc,
    ),
  );
  await repo.ready();
  return repo;
}

Future<IBalanceDataService> createService(BalanceDocument doc) async {
  final service = BalanceDataServiceImpl(
    repo: await createRepo(doc),
  );
  await service.ready();
  return service;
}

SerialTransaction createSerialTransactionWithId(String id) {
  return SerialTransaction(
    id: id,
    amount: 5.55,
    category: "sidejob",
    currency: "EUR",
    name: "Test",
    startDate: DateTime.now(),
    repeatDuration: 60 * 60 * 24 * 3,
  );
}

Transaction createTransactionWithId(String id) {
  return Transaction(
    amount: 5.55,
    category: "sidejob",
    currency: "EUR",
    name: "Test",
    date: DateTime.now(),
  );
}

({RepeatDurationType type, int duration}) randomRepeatInterval() {
  final rand = math.Random();
  final RepeatDurationType repeatDurationType = RepeatDurationType
      .values[rand.nextInt(RepeatDurationType.values.length)];
  int repeatDuration = rand.nextInt(99) + 1;
  if (repeatDurationType == RepeatDurationType.seconds) {
    repeatDuration *= 10000;
  }
  return (
    type: repeatDurationType,
    duration: repeatDuration,
  );
}
