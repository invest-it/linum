// Home Screen Card Data - Model for storing data for the home screen card
//
// Author: NightmindOfficial
// Co-Author: n/a
//
class HomeScreenCardData {
  // Front Side
  final num mtdBalance; //Month to date balance
  final num mtdIncome; // Month to date income
  final num mtdExpenses; // Month to date expenses

  //Back Side
  final num eomBalance; //End of Month projection of balance
  final num
      eomFutureSerialIncome; //End of Month outstanding serial income items (sum)
  final num
      eomFutureSerialExpenses; //End of Month outstanding serial expense items (sum)
  final num eomSerialIncome; //End of Month serial income items (sum)
  final num eomSerialExpenses; //End of Month serial expense items (sum)

  const HomeScreenCardData({
    this.mtdBalance = 0,
    this.mtdExpenses = 0,
    this.mtdIncome = 0,
    this.eomBalance = 0,
    this.eomFutureSerialIncome = 0,
    this.eomFutureSerialExpenses = 0,
    this.eomSerialIncome = 0,
    this.eomSerialExpenses = 0,
  });
}
