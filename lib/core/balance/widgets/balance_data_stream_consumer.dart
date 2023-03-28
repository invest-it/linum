import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


class BalanceDataStreamConsumer<T> extends SingleChildStatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<T>, Widget?) builder;
  final Future<T> Function(DocumentSnapshot<BalanceDocument>) transformer;
  const BalanceDataStreamConsumer({
    super.key,
    required this.builder,
    required this.transformer,
  });

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer<BalanceDataService>(
      builder: (context, balanceDataService, child) {
        final transformedStream = balanceDataService.stream
            ?.asyncMap((snapshot) {
          return transformer(snapshot);
        });
        return StreamBuilder<T>(
          stream: transformedStream,
          builder: (context, snapshot) => builder(context, snapshot, child),
        );
      },
      child: child,
    );
  }
}

class BalanceDataStreamConsumer2<S1, T> extends SingleChildStatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<T>, Widget?) builder;
  final Future<T> Function(DocumentSnapshot<BalanceDocument>, S1) transformer;
  const BalanceDataStreamConsumer2({
    super.key,
    required this.builder,
    required this.transformer,
  });

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer2<BalanceDataService, S1>(
      builder: (context, balanceDataService, s1, child) {
        final transformedStream = balanceDataService.stream
            ?.asyncMap((snapshot) {
          return transformer(snapshot, s1);
        });
        return StreamBuilder<T>(
          stream: transformedStream,
          builder: (context, snapshot) => builder(context, snapshot, child),
        );
      },
      child: child,
    );
  }
}

class BalanceDataStreamConsumer3<S1, S2, T> extends SingleChildStatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<T>, Widget?) builder;
  final Future<T> Function(DocumentSnapshot<BalanceDocument>, S1, S2) transformer;
  const BalanceDataStreamConsumer3({
    super.key,
    required this.builder,
    required this.transformer,
  });

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer3<BalanceDataService, S1, S2>(
      builder: (context, balanceDataService, s1, s2, child) {
        final transformedStream = balanceDataService.stream
            ?.asyncMap((snapshot) {
          return transformer(snapshot, s1, s2);
        });
        return StreamBuilder<T>(
          stream: transformedStream,
          builder: (context, snapshot) => builder(context, snapshot, child),
        );
      },
      child: child,
    );
  }
}
