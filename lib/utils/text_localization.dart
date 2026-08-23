import 'package:get_it/get_it.dart';

import '../services/language_service.dart';

/// Punctuation that changes shape with the language.
///
/// Arabic separates list items with the Arabic comma U+060C, which sits on the
/// baseline and mirrors the Latin one. Using the Latin comma inside Arabic text
/// looks like a typo to a native reader, and the bidi algorithm can pull it to
/// the wrong end of the run.
///
/// The code points are computed rather than written as literals so this file
/// stays plain ASCII.
const int _arabicComma = 0x060C;
const int _latinComma = 0x2C;

/// True when the active language wants Arabic punctuation.
bool get useArabicPunctuation {
  if (!GetIt.instance.isRegistered<LanguageService>()) return false;
  return GetIt.instance<LanguageService>()
      .currentLanguage
      .usesArabicPunctuation;
}

/// The list separator for the active language, comma plus a trailing space.
String get listSeparator =>
    '${String.fromCharCode(useArabicPunctuation ? _arabicComma : _latinComma)} ';

/// Join display parts with the active language's comma.
///
/// Blank and null parts are dropped, so a missing area does not leave a
/// dangling separator on the end of an address line.
String joinLocalized(Iterable<String?> parts) => parts
    .where((p) => p != null && p.trim().isNotEmpty)
    .map((p) => p!.trim())
    .join(listSeparator);
