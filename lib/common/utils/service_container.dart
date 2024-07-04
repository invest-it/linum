import 'package:flutter/widgets.dart';
import 'package:linum/common/interfaces/service_interface.dart';
import 'package:provider/provider.dart';

typedef ServiceEntry = ({
  IService service, ChangeNotifierProvider? provider,
});

class ServiceContainer {
  final List<ServiceEntry> services = [];

  void registerProvidableService<T extends IProvidableService>(T service) {
    services.add((
      service: service,
      provider: ChangeNotifierProvider<T>.value(
        value: service,
      ),
    ),);
  }

  void registerService(IService service) {
    services.add((
      service: service,
      provider: null,
    ),);
  }

  void clear() {
    for (final entry in services) {
      entry.service.dispose();
    }
    services.clear();
  }

  void dispose() {
    clear();
  }

  Widget build(BuildContext context, Widget? child) {
    final providers = services
        .where((entry) => entry.provider != null)
        .map((entry) {
      return entry.provider!;
    });

    return MultiProvider(
      providers: providers.toList(),
      child: child,
    );
  }
}
