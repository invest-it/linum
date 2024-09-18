import 'package:linum/core/balance/domain/balance_data_repository.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/domain/repository_impl/balance_data_repository_impl.dart';
import 'package:linum/core/balance/ports/firebase/balance_document.dart';
import 'package:linum/core/balance/ports/firebase/firebase_test_balance_adapter.dart';
import 'package:linum/core/balance/presentation/balance_data_service.dart';
import 'package:linum/core/balance/presentation/balance_data_service_impl.dart';

IBalanceDataRepository createRepo(BalanceDocument doc) {
  return BalanceDataRepositoryImpl(
    adapter: FirebaseTestBalanceAdapter(
      doc: doc,
    ),
  );
}

IBalanceDataService createService(BalanceDocument doc) {
  return BalanceDataServiceImpl(
    repo: createRepo(doc),
  );
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