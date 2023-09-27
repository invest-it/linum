import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeRateInfo {
  num rate;
  num standardCurrencyRate;
  Timestamp date;
  bool isCustom;
  bool isOtherDate;
  ExchangeRateInfo(this.rate, this.standardCurrencyRate, this.date, {this.isCustom = false, this.isOtherDate = false});


}
