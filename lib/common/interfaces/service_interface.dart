import 'package:flutter/cupertino.dart';

abstract class IService {
  void dispose();
}

abstract mixin class NotifyReady  {
  Future<bool> ready();
}


abstract class IProvidableService with ChangeNotifier implements IService {}
