//  Repeatable Change Type - Enum that specifies all Options a user has for deleting entries that are part of a repeatable
//
//  Author: SoTBurst
//  Co-Author: n/a
//

enum SerialTransactionChangeMode {
  all,
  thisAndAllBefore,
  thisAndAllAfter,
  onlyThisOne;

  bool isThisAndAllBefore() {
    return this == SerialTransactionChangeMode.thisAndAllBefore;
  }
  bool isThisAndAllAfter() {
    return this == SerialTransactionChangeMode.thisAndAllAfter;
  }
  bool isOnlyThisOne() {
    return this == SerialTransactionChangeMode.onlyThisOne;
  }
}
