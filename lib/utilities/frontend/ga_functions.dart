import 'package:firebase_analytics/firebase_analytics.dart';

extension CustomAnalytics on FirebaseAnalytics {
  Future<void> logButton(String buttonId) async {
    await logEvent(name: "click_button", parameters: {"button_id": buttonId});
  }
}
