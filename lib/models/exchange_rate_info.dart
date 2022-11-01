import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeRateInfo {
  int rate;
  Timestamp date;
  bool isCustom;
  bool isOtherDate;
  ExchangeRateInfo(this.rate, this.date, {this.isCustom = false, this.isOtherDate = false});


}
