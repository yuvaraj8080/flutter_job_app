import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/validators/validator.dart';

class JobTextFormField extends StatelessWidget {
  const JobTextFormField({
    super.key,
    required this.valueKey,
    required this.controller,
    required this.enabled,
    required this.fct,
    // required this.maxLength,
  });
  final String valueKey;
  final TextEditingController controller;
  final bool enabled;
  final Function fct;
  // final int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => TValidator.stringValue(value),
      enabled: enabled,
      key: ValueKey(valueKey),
      maxLines: valueKey == 'JobDescription' ? 3 : 1,
      // maxLength: maxLength,
      keyboardType: TextInputType.text,

    );
  }
}
