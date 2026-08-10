import 'package:get_it/get_it.dart';

import '../services/language_service.dart';

/// Arabic-Indic digit localization.
///
/// Arabic renders numbers with Arabic-Indic digits (U+0660..U+0669). English and
/// French keep Western digits, so every helper here is a pass-through outside
/// Arabic.
///
/// Apply to values the shopper reads as quantities: prices, totals, counts,
/// badges, ratings, loyalty points, percentages and dates.
///
/// Do NOT apply to identifiers: order and tracking codes (SK-SEED-0001), phone
/// numbers, emails, URLs, or anything the shopper may need to read back to
/// support or paste into a search. Converting those breaks lookup and copy.
///
/// The digit code points are computed rather than written as literals so this
/// file stays plain ASCII.
const int _arabicIndicZero = 0x0660;
const int _asciiZero = 0x30;
const int _asciiNine = 0x39;

/// True when the active language wants Arabic-Indic digits.
bool get useArabicIndicDigits {
  if (!GetIt.instance.isRegistered<LanguageService>()) return false;
  return GetIt.instance<LanguageService>().currentLanguage.usesArabicIndicDigits;
}

/// Convert every ASCII digit in [value] to its Arabic-Indic form.
///
/// Non-digit characters (decimal separators, currency symbols, spaces) are left
/// untouched, so "20.99 USD" becomes Arabic-Indic digits with the same shape.
String toArabicIndicDigits(String value) {
  final buffer = StringBuffer();
  for (final rune in value.runes) {
    if (rune >= _asciiZero && rune <= _asciiNine) {
      buffer.writeCharCode(_arabicIndicZero + (rune - _asciiZero));
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

/// Localize the digits in an already-formatted string.
///
/// Use this for strings that are built elsewhere (prices with a currency, dates,
/// "3 / 10" counters). Returns [value] unchanged outside Arabic.
String localizedDigits(String value) =>
    useArabicIndicDigits ? toArabicIndicDigits(value) : value;

/// Localize a number for display.
///
/// [decimals] fixes the fraction digits the same way `toStringAsFixed` does;
/// omit it to use the number's natural representation.
String localizedNumber(num value, {int? decimals}) {
  final text = decimals == null ? '$value' : value.toStringAsFixed(decimals);
  return localizedDigits(text);
}

/// Convenience for the app's money formatting: two decimals, localized digits.
String localizedPrice(num value) => localizedNumber(value, decimals: 2);

/// Escape hatch for identifiers that must stay in Western digits even in Arabic.
///
/// Exists so call sites can state the intent explicitly instead of silently
/// leaving a value unformatted.
String keepWesternDigits(String value) => value;
