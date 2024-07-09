import 'package:flutter/material.dart';

class LinumBottomSheet extends StatelessWidget {
  final String title;
  final Widget body;

  const LinumBottomSheet({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              primary: false,
              automaticallyImplyLeading: false,
              title: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: Navigator.of(context).pop,
                ),
              ],
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body,
          ],
        ),
      ),
    );
  }
}
