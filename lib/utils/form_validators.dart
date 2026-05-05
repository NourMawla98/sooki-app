final _emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Please enter your email';
  if (!_emailRegex.hasMatch(value)) return 'Please enter a valid email';
  return null;
}

bool isValidEmail(String value) => _emailRegex.hasMatch(value);
