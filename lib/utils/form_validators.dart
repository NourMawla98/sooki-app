import 'package:easy_localization/easy_localization.dart';

final _emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'validation.email_required'.tr();
  if (!_emailRegex.hasMatch(value)) return 'validation.invalid_email'.tr();
  return null;
}

bool isValidEmail(String value) => _emailRegex.hasMatch(value);
