import 'package:flutter/material.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:linum/screens/lock_screen/widgets/numeric_field.dart';
import 'package:provider/provider.dart';

class PeripheralsField extends StatelessWidget {
  const PeripheralsField({super.key});

  @override
  Widget build(BuildContext context) {
    final pinCodeService = context.read<PinCodeService>();
    return Expanded(
      flex: 5,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ..._generateNumericFields([1, 4, 7], pinCodeService, context),
                //Backspace
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    child: Material(
                      child: IconButton(
                        key: const Key("pinlockBackspace"),
                        icon: Icon(
                          Icons.backspace_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          pinCodeService.removeLastDigit();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children:
              _generateNumericFields([2, 5, 8, 0], pinCodeService, context),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ..._generateNumericFields([3, 6, 9], pinCodeService, context),
                // If Fingerprint is enabled, trigger dialog here
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    child: const Material(
                      child: IconButton(
                        icon: Icon(Icons.fingerprint_rounded),
                        onPressed: null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<NumericField> _generateNumericFields(
      List<int> numbers,
      PinCodeService pinCodeProvider,
      BuildContext context,
  ) {
    final fields = <NumericField>[];
    for (final number in numbers) {
      final field = NumericField(number, (digit) {
        pinCodeProvider.addDigit(digit, context);
      });
      fields.add(field);
    }
    return fields;
  }
}
